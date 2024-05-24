CREATE TABLE `auth` (
	`id` integer PRIMARY KEY NOT NULL,
	`userId` integer NOT NULL,
	`deviceId` integer NOT NULL,
	`lastRefresh` text
);
--> statement-breakpoint
CREATE TABLE `devices` (
	`id` integer PRIMARY KEY NOT NULL,
	`deviceType` text NOT NULL,
	`osName` text,
	`osVersion` text,
	`deviceModel` text,
	`isPhysicalDevice` text,
	`appVersion` text,
	`ipAddress` text,
	`fcmToken` text NOT NULL
);
--> statement-breakpoint
CREATE TABLE `otp` (
	`id` integer PRIMARY KEY NOT NULL,
	`otp` text NOT NULL,
	`email` text NOT NULL,
	`deviceUuId` text NOT NULL,
	`expiredAt` text NOT NULL
);
--> statement-breakpoint
CREATE UNIQUE INDEX `auth_id_unique` ON `auth` (`id`);--> statement-breakpoint
CREATE UNIQUE INDEX `devices_id_unique` ON `devices` (`id`);--> statement-breakpoint
CREATE UNIQUE INDEX `otp_id_unique` ON `otp` (`id`);