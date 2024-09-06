import {z} from '@hono/zod-openapi'

export const ApiUpdateTodoDtoSchema = z.object({
    title: z.string().optional(),
    description: z.string().optional(),
    startTime: z.string().optional(),
    endTime: z.string().optional(),
    completedAt: z.string().optional(),
    taskDate: z.string().optional(),
    status: z.enum(['pending', 'completed', 'in-progress']).optional(),
    setAlarmBeforeMin: z.number().optional(),
}).openapi('CreateTodoDto')

export type ApiUpdateTodoDto = z.infer<typeof ApiUpdateTodoDtoSchema>;