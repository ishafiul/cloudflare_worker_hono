import {WorkerEntrypoint, RpcTarget} from "cloudflare:workers";
import {drizzle, LibSQLDatabase} from "drizzle-orm/libsql";
import {createClient} from "@libsql/client";
import {Bindings} from "./config/bindings";
import {todos} from "../drizzle/schema";
import {v4 as uuidv4} from 'uuid';
import {CreateTodoDto, CreateTodoSchema} from "./dto/create-todo.dto";
import {eq} from "drizzle-orm";

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
			const data= await this.db.insert(todos).values({
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


