import type {Config} from 'drizzle-kit';
import {config} from "dotenv";

config({path: '.dev.vars'});

export default {
    schema: "./src/drizzle/schema.ts",
    out: "./drizzle/migrations",
    driver: "turso",
    dialect: "sqlite",
    dbCredentials: {
        url: process.env.TURSO_DATABASE_URL ?? '',
        authToken: process.env.TURSO_AUTH_TOKEN,
    },
} satisfies Config