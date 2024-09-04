import { defineConfig } from "drizzle-kit";
export default defineConfig({
	dialect: "sqlite", // "mysql" | "sqlite"
	schema: "./drizzle/schema.ts",
	out: "./drizzle/migrations",
});
