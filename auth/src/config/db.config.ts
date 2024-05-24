import {createClient} from "@libsql/client";
import {drizzle} from "drizzle-orm/libsql";


export const dbClient = (env: Bindings) => {
    const client = createClient({
        url: env.TURSO_DATABASE_URL,
        authToken: env.TURSO_AUTH_TOKEN,
    });
    return drizzle(client);
};