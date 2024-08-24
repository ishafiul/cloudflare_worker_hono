import {sql} from 'drizzle-orm';
import {
	integer,
	sqliteTable,
	text,
} from 'drizzle-orm/sqlite-core';
import {createInsertSchema, createSelectSchema} from 'drizzle-zod';


export const otps = sqliteTable(
	'otps',
	{
		id: text('id').primaryKey(),
		otp: integer('otp').notNull(),
		email: text('email').notNull(),
		deviceUuId: text('deviceUuId').notNull(),
		expiredAt: integer('expiredAt', {mode: 'timestamp'}).default(sql`(strftime('%s', 'now'))`),
	},
);
export const insertOtpSchema = createInsertSchema(otps);
export const selectOtpSchema = createSelectSchema(otps);


export const devices = sqliteTable(
	'devices',
	{
		id: text('id').primaryKey(),
		deviceType: text('deviceType'),
		osName: text('osName'),
		osVersion: text('osVersion'),
		deviceModel: text('deviceModel'),
		isPhysicalDevice: text('isPhysicalDevice'),
		appVersion: text('appVersion'),
		ipAddress: text('ipAddress'),
		fcmToken: text('fcmToken').notNull().unique(),
	},
);
export const insertDevicesSchema = createInsertSchema(devices);
export const selectDevicesSchema = createSelectSchema(devices);

export const auths = sqliteTable(
	'auths',
	{
		id: text('id').primaryKey(),
		userId: text('userId').notNull(),
		deviceId: text('deviceId').notNull(),
		lastRefresh: integer('lastRefresh', {mode: 'timestamp'}).default(sql`(strftime('%s', 'now'))`),
	},
);
export const insertAuthsSchema = createInsertSchema(auths);
export const selectAuthsSchema = createSelectSchema(auths);
