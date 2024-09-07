import { z } from 'zod';

// Define the Zod schema for validation
export const FindTodosOptionsSchema = z.object({
	page: z.number().int().min(1).default(1),
	perPage: z.number().int().min(1).default(20),
	taskDate: z.string().optional().default(() => new Date().toISOString().split('T')[0]),
	userId: z.string().min(1)
});

export type FindTodosOptions = z.infer<typeof FindTodosOptionsSchema>;
