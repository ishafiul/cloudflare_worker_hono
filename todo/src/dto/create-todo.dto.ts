import {z} from "zod";

export const CreateTodoSchema = z.object({
	userId: z.string(),
	title: z.string(),
	description: z.string().optional(),
	startTime: z.string(),
	endTime: z.string(),
	completedAt: z.string().optional(),
	taskDate: z.string(),
	status: z.enum(['pending', 'completed', 'in-progress']).optional(),
	setAlarmBeforeMin: z.number().optional(),
})

export type CreateTodoDto = z.infer<typeof CreateTodoSchema>;
