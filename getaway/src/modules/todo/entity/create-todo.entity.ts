import { z } from '@hono/zod-openapi'

export const ApiTodoEntitySchema = z.object({
    id: z.string(),
    userId: z.string(),
    title: z.string(),
    description: z.string().optional(),
    startTime: z.string(),
    endTime: z.string(),
    completedAt: z.string().optional(),
    taskDate: z.string(),
    status: z.enum(['pending', 'completed', 'in-progress']).optional(),
    setAlarmBeforeMin: z.number().optional(),
}).openapi('Todo')

export type ApiTodoEntity = z.infer<typeof ApiTodoEntitySchema>;
