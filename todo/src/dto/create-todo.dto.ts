import {z} from "zod";

export const CreateTodoSchema = z.object({
	userId: z.string(),
	title: z.string(),
	description: z.string().optional(),
	startTime: z.string(),
	endTime: z.boolean(),
	completedAt: z.string().optional(),
	taskDate: z.string(),
	status: z.string(),
	setAlarmBeforeMin: z.number().optional(),
})

export type CreateDeviceUuidDto = z.infer<typeof CreateTodoSchema>;
