import {
	sqliteTable,
	text,
} from 'drizzle-orm/sqlite-core';
import {createInsertSchema, createSelectSchema} from 'drizzle-zod';


export const users = sqliteTable(
	'users',
	{
		id: text('id').primaryKey(),
		email: text('email').notNull().unique(),
	},
);
export const insertUsersSchema = createInsertSchema(users);
export const selectUsersSchema = createSelectSchema(users);

