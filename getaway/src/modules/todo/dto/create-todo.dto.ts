import {z} from "zod";

export const ApiCreateTodoDtoSchema = z.object({
	title: z.string(),
	description: z.string().optional(),
	startTime: z.string(),
	endTime: z.string(),
	completedAt: z.string().optional(),
	taskDate: z.string(),
	status: z.enum(['pending', 'completed', 'in-progress']).optional(),
	setAlarmBeforeMin: z.number().optional(),
})

export type ApiCreateTodoDto = z.infer<typeof ApiCreateTodoDtoSchema>;
