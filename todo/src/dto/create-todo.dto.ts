import {z} from "zod";

export const CreateTodoSchema = z.object({
	userId: z.string(),
	title: z.string(),
	description: z.string().optional(),
	startTime: z.string(),
	endTime: z.string(),
	completedAt: z.string().optional(),
	taskDate: z.string().optional().default(() => {
		// Set default to today's date in ISO string format without the time part
		const today = new Date();
		today.setUTCHours(0, 0, 0, 0); // Set the time to 00:00:00
		return today.toISOString(); // Return the ISO string format
	}),
	status: z.enum(['pending', 'completed', 'in-progress']).optional(),
	setAlarmBeforeMin: z.number().optional(),
})

export type CreateTodoDto = z.infer<typeof CreateTodoSchema>;
