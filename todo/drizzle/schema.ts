import {
	integer,
	sqliteTable,
	text,
} from 'drizzle-orm/sqlite-core';
import {createInsertSchema, createSelectSchema} from 'drizzle-zod';


export const todos = sqliteTable(
	'todos',
	{
		id: text('id').primaryKey(),
		userId: text('userId').notNull(),
		title: text('title').notNull(),
		description: text('description'),
		startTime: text('startTime').notNull(),
		endTime: text('endTime').notNull(),
		completedAt: text('completedAt'),
		taskDate: text('taskDate').notNull(),
		status: text('status').notNull(),
		setAlarmBeforeMin: integer('setAlarmBeforeMin'),
	},
);
export const insertTodosSchema = createInsertSchema(todos);
export const selectTodosSchema = createSelectSchema(todos);

