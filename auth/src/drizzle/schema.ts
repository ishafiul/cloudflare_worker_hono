import {text, sqliteTable, integer} from "drizzle-orm/sqlite-core";

export const Auth = sqliteTable("auth", {
    id: integer("id").notNull().primaryKey().unique(),
    userId: integer("userId").notNull(),
    deviceId: integer("deviceId").notNull(),
    lastRefresh: text("lastRefresh"),
});

export const Devices = sqliteTable("devices", {
    id: integer("id").notNull().primaryKey().unique(),
    deviceType: text("deviceType").notNull(),
    osName: text("osName"),
    osVersion: text("osVersion"),
    deviceModel: text("deviceModel"),
    isPhysicalDevice: text("isPhysicalDevice"),
    appVersion: text("appVersion"),
    ipAddress: text("ipAddress"),
    fcmToken: text("fcmToken").notNull(),
})

export const Otp = sqliteTable("otp", {
    id: integer("id").notNull().primaryKey().unique(),
    otp: text("otp").notNull(),
    email: text("email").notNull(),
    deviceUuId: text("deviceUuId").notNull(),
    expiredAt: text("expiredAt").notNull(),
})
