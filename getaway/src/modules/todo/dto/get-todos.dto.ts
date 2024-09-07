import { z } from '@hono/zod-openapi'

export const ApiFindTodosOptionsSchema = z.object({
    page: z.string().optional().default("1").openapi({
        param: {
            name: 'page',
            in: 'query',
            description: 'The page number for pagination',
            required: false,
            schema: { type: 'string', minimum: 1, default: 1 }
        }
    }),
    perPage: z.string().optional().default("20").openapi({
        param: {
            name: 'perPage',
            in: 'query',
            description: 'Number of items per page',
            required: false,
            schema: { type: 'integer', minimum: 1, default: 20 }
        }
    }),
    taskDate: z.string().optional().default(new Date().toISOString().split('T')[0]).openapi({
        param: {
            name: 'taskDate',
            in: 'query',
            description: 'Filter todos by task date (in YYYY-MM-DD format)',
            required: false,
            schema: { type: 'string', format: 'date' },
            example: new Date().toISOString().split('T')[0],
        }
    })
});


export type ApiFindTodosOptions = z.infer<typeof ApiFindTodosOptionsSchema>;
