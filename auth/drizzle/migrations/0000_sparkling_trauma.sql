CREATE TABLE `auths` (
	`id` text PRIMARY KEY NOT NULL,
	`userId` text NOT NULL,
	`deviceId` text NOT NULL,
	`lastRefresh` integer DEFAULT (strftime('%s', 'now'))
);
--> statement-breakpoint
CREATE TABLE `devices` (
	`id` text PRIMARY KEY NOT NULL,
	`deviceType` text,
	`osName` text,
	`osVersion` text,
	`deviceModel` text,
	`isPhysicalDevice` text,
	`appVersion` text,
	`ipAddress` text,
	`fcmToken` text NOT NULL
);
--> statement-breakpoint
CREATE TABLE `otps` (
	`id` text PRIMARY KEY NOT NULL,
	`otp` integer NOT NULL,
	`email` text NOT NULL,
	`deviceUuId` text NOT NULL,
	`expiredAt` integer DEFAULT (strftime('%s', 'now'))
);
