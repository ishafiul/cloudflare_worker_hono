import {z} from '@hono/zod-openapi'

export const TodoCountSchema = z.object({
    taskDate: z.string(), // ISO date string
    count: z.number().int()
}).openapi('TodoCountEntity');
export const TodosCountSchema = z.object({
    month: z.string(), // ISO month string
    data: z.array(TodoCountSchema)
}).openapi('TodosCountEntity');

export type TodoCountEntity = z.infer<typeof TodoCountSchema>;
export type TodosCountEntity = z.infer<typeof TodosCountSchema>;