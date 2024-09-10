import {RpcTarget, WorkerEntrypoint} from "cloudflare:workers";
import {drizzle, LibSQLDatabase} from "drizzle-orm/libsql";
import {createClient} from "@libsql/client";
import {Bindings} from "./config/bindings";
import {todos} from "../drizzle/schema";
import {CreateTodoDto, CreateTodoSchema} from "./dto/create-todo.dto";
import {and, asc, eq, gte, lt, SQL, sql} from "drizzle-orm";
import {FindTodosOptions, FindTodosOptionsSchema} from "./dto/get-todos.dto";
import {v4 as uuidv4} from 'uuid';
import {SQLiteSyncDialect} from "drizzle-orm/sqlite-core";

export class Todo extends RpcTarget {
	#env: Bindings;
	private readonly db: LibSQLDatabase;


	constructor(env: Bindings) {
		super();
		this.#env = env;
		this.db = this.#buildDbClient();
	}

	#buildDbClient(): LibSQLDatabase {
		const url = this.#env.TURSO_URL;
		if (url === undefined) {
			throw new Error('TURSO_URL is not defined');
		}

		const authToken = this.#env.TURSO_AUTH_TOKEN;
		if (authToken === undefined) {
			throw new Error('TURSO_AUTH_TOKEN is not defined');
		}

		return drizzle(createClient({url, authToken}), {
			logger: true,
		});
	}

	async create(createTodoDto: CreateTodoDto) {
		const validation = CreateTodoSchema.safeParse(createTodoDto);

		if (!validation.success) {
			throw new Error('Invalid input data');
		}

		const validatedData = validation.data;

		try {
			const data = await this.db.insert(todos).values({
				id: uuidv4(),
				userId: validatedData.userId,
				title: validatedData.title,
				description: validatedData.description || null,
				startTime: validatedData.startTime,
				endTime: validatedData.endTime,
				completedAt: validatedData.completedAt || null,
				taskDate: validatedData.taskDate || new Date().toISOString(),
				status: validatedData.status || 'pending',
				setAlarmBeforeMin: validatedData.setAlarmBeforeMin || 5,
			}).returning();
			return data;
		} catch (error) {
			throw new Error('Failed to create todo');
		}
	}

	async findById(id: string) {
		try {
			return await this.db
				.select()
				.from(todos)
				.where(eq(todos.id, id));
		} catch (error) {
			throw new Error(`Failed to find todo with ID: ${id}`);
		}
	}

	async update(id: string, updateDeviceUuidDto: Partial<CreateTodoDto>) {
		const UpdateTodoSchema = CreateTodoSchema.partial();

		const validation = UpdateTodoSchema.safeParse(updateDeviceUuidDto);

		if (!validation.success) {
			throw new Error('Invalid input data');
		}

		const validatedData = validation.data;

		try {
			return this.db.update(todos)
				.set({
					...validatedData,
				})
				.where(eq(todos.id, id))
				.returning();
		} catch (error) {
			throw new Error('Failed to update todo');
		}
	}

	async delete(id: string) {
		// Validate the ID
		if (!id) {
			throw new Error('Invalid ID');
		}

		try {
			const result = await this.db
				.delete(todos)
				.where(eq(todos.id, id))
				.returning(); // Optionally return the deleted record

			if (result.length === 0) {
				throw new Error('Todo not found or already deleted');
			}

			return result;
		} catch (error) {
			throw new Error(`Failed to delete todo`);
		}
	}

	async getTodos(options: FindTodosOptions) {
		console.log("todo0")
		const validatedOptions = FindTodosOptionsSchema.parse(options);
		console.log("todo1")
		// Extract and use validated options
		const {page, perPage, taskDate, userId} = validatedOptions;
		try {
			console.log("todo2")
			console.log(page)
			console.log(taskDate)
			const currentPage = Math.max(1, page);
			const currentPerPage = Math.max(1, perPage);

			const offset = (currentPage - 1) * currentPerPage;

			console.log("todo3")
			let res = await this.db
				.select()
				.from(todos)
				.where(
					and(
						eq(todos.userId, userId),
					)
				)
				.orderBy(asc(todos.startTime))
				.limit(currentPerPage)
				.offset(offset);
			if (!res) {
				res = [];
			}
			const todo: typeof res = [];

			res.forEach((item) => {
				try {
					const date = new Date(item.taskDate).toISOString().split('T')[0];
					if (date === taskDate) {
						todo.push(item)
					}
				} catch (_) {

				}
			})

			return todo;


		} catch (error) {
			throw new Error(`Failed to fetch todos for user with ID: ${userId}`);
		}
	}

	private generateMonthDates(year: number, month: number) {
		const dates: string[] = [];
		const numDays = new Date(year, month, 0).getDate(); // Number of days in the month

		for (let day = 1; day <= numDays; day++) {
			const date = new Date(year, month - 1, day);
			dates.push(date.toISOString().split('T')[0]); // YYYY-MM-DD format
		}

		return dates;
	}

	async getTodoCountsForMonth({year, month, userId}: { year: string, month: string, userId: string }) {
		const startDate = new Date(Number(year), Number(month) - 1, 1).toISOString(); // First day of the month
		const endDate = new Date(Number(year), Number(month), 0).toISOString();       // Last day of the month

		const dates = this.generateMonthDates(Number(year), Number(month));

		try {
			if (!this.db) {
				console.log('Database connection is not initialized');
				return;
			}

			let res: {taskDate: string; count: number; }[] = await this.db
				.select({
					taskDate: todos.taskDate,
					count: sql<number>`COUNT(*)` // Use the SQL helper for COUNT
				})
				.from(todos)
				.where(
					and(
						eq(todos.userId, userId),
						gte(todos.taskDate, startDate),
						lt(todos.taskDate, endDate)
					)
				)
				.groupBy(todos.taskDate);

			// Initialize a result object with zero counts for all dates

			if (!res) {
				return []
			}
			const results: { taskDate: string; count: number; }[] = dates.map(date => ({
				taskDate: date,
				count: 0
			}));

			const resultsMap = new Map(results.map(item => [item.taskDate, item]));

			res.forEach(row => {
				const formattedDate = new Date(row.taskDate).toISOString().split('T')[0];
				if (resultsMap.has(formattedDate)) {
					resultsMap.get(formattedDate)!.count = row.count;
				}
			});

			// Return results as an array
			return Array.from(resultsMap.values());

		} catch (error) {
			console.error('Error during query execution:', error);
		}
	}


}

export class TodoService extends WorkerEntrypoint<Bindings> {
	async newTodo() {

		return new Todo(this.env);
	}
}


export default {
	fetch() {
		return new Response("User Service")
	}
}


interface TodoCountRecord {
	date: string;
	count: number;
}
