CREATE TABLE `todos` (
	`id` text PRIMARY KEY NOT NULL,
	`userId` text NOT NULL,
	`title` text NOT NULL,
	`description` text,
	`startTime` text NOT NULL,
	`endTime` text NOT NULL,
	`completedAt` text,
	`taskDate` text NOT NULL,
	`status` text NOT NULL,
	`setAlarmBeforeMin` integer
);
