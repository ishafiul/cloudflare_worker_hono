import {z} from '@hono/zod-openapi'

export const ApiTodoEntitySchema = z.object({
    id: z.string(),
    userId: z.string(),
    title: z.string(),
    description: z.string().optional(),
    startTime: z.string(),
    endTime: z.string(),
    completedAt: z.string().optional(),
    taskDate: z
        .string()
        .optional()
        .default(() => {
            // Set default to today's date in ISO string format without the time part
            const today = new Date();
            today.setUTCHours(0, 0, 0, 0); // Set the time to 00:00:00
            return today.toISOString(); // Return the ISO string format
        })
        .refine((val) => !isNaN(Date.parse(val)), {message: 'Invalid ISO date format'}) // Validate as ISO date string
        .openapi({
            param: {
                name: 'taskDate',
                in: 'query',
                description: 'Filter todos by task date (in ISO format)',
                required: false,
                schema: {type: 'string', format: 'date-time'},
                example: new Date().toISOString(),
            }
        }),
    status: z.enum(['pending', 'completed', 'in-progress']).optional(),
    setAlarmBeforeMin: z.number().optional(),
}).openapi('Todo')


export const ApiTodosEntitySchema = z.object({
    pageNumber: z.number(),
    perPageCount: z.number(),
    data: z.array(ApiTodoEntitySchema)
}).openapi('Todos')


export type ApiTodosEntity = z.infer<typeof ApiTodosEntitySchema>;
export type ApiTodoEntity = z.infer<typeof ApiTodoEntitySchema>;
