import {RpcTarget, WorkerEntrypoint} from "cloudflare:workers";
import {drizzle, LibSQLDatabase} from "drizzle-orm/libsql";
import {createClient} from "@libsql/client";
import {Bindings} from "./config/bindings";
import {todos} from "../drizzle/schema";
import {CreateTodoDto, CreateTodoSchema} from "./dto/create-todo.dto";
import {and, asc, eq, sql} from "drizzle-orm";
import {FindTodosOptions, FindTodosOptionsSchema} from "./dto/get-todos.dto";
import {v4 as uuidv4} from 'uuid';

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

		return drizzle(createClient({url, authToken}));
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

	async getTodoCountsForMonth({year, month, userId}: { year: string, month: string, userId: string }) {
		const startDate = new Date(Number(year), Number(month) - 1, 1).toISOString(); // First day of the month
		const endDate = new Date(Number(year), Number(month), 0).toISOString();       // Last day of the month
		console.log(year)
		console.log(month)
		try {
			const res = await this.db.all(sql`
			select ${todos.taskDate} as taskDate, COUNT(*) as count
			from  ${todos}
			where ${todos.userId} = ${userId}
			and ${todos.taskDate} >= ${startDate}
			and ${todos.taskDate} < ${endDate}
			group by ${todos.taskDate}
  		`);
			console.log(res)
			return res;
		} catch (error) {
			console.log(error)
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


