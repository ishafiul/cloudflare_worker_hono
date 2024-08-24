import {WorkerEntrypoint, RpcTarget} from "cloudflare:workers";
import {drizzle, LibSQLDatabase} from "drizzle-orm/libsql";
import {createClient} from "@libsql/client";
import {Bindings} from "./config/bindings";
import {users} from "../drizzle/schema";
import {eq} from "drizzle-orm";
import {v4 as uuidv4} from 'uuid';

export class Auth extends RpcTarget {
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

	async findUserOrCreate(email: string): Promise<{ id: string, email: string }> {
		if (this.db === undefined) {
			throw new Error('db is not defined');
		}
		const alreadyExistsUsers = await this.db.select().from(users).where(eq(users.email, email));

		if (alreadyExistsUsers.length === 0) {
			const newCreatedUsers = await this.db.insert(users).values({
				id: uuidv4(),
				email: email
			}).returning({
				id: users.id,
				email: users.email
			});
			return newCreatedUsers[0];
		} else {
			return alreadyExistsUsers[0];
		}
	}

	async findUserByEmail(email: string) {
		if (this.db === undefined) {
			throw new Error('db is not defined');
		}
		const alreadyExistsUsers = await this.db.select().from(users).where(eq(users.email, email));
		return alreadyExistsUsers[0];
	}
}

export class UserService extends WorkerEntrypoint<Bindings> {
	async newUser() {

		return new Auth(this.env);
	}
}


export default {
	fetch() {
		return new Response("User Service")
	}
}


