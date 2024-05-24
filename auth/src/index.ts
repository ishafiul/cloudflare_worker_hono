import {Hono} from 'hono'
import {OpenAPIHono, createRoute, z} from '@hono/zod-openapi'
import {swaggerUI} from '@hono/swagger-ui'
import {zValidator} from "@hono/zod-validator";

const app = new OpenAPIHono<{ Bindings: Bindings }>()
app.openapi(
    createRoute({
        method: 'get',
        path: '/hello',
        tags: ['hello'],
        responses: {
            200: {
                description: 'Respond a message',
                content: {
                    'application/json': {
                        schema: z.object({
                            message: z.string()
                        })
                    }
                }
            }
        }
    }),

    (c) => {
        return c.json({
            message: 'hello'
        })
    }
)

app.get(
    '/ui',
    swaggerUI({
        url: '/doc'
    })
)

app.doc('/doc', {
    info: {
        title: 'An API',
        version: 'v1'
    },
    openapi: '3.1.0'
})

app.get('/', (c) => {
    return c.text('Auth Server')
})

app.openapi(
    createRoute({
        method: 'post',
        path: '/hello',
        request: {
            body: {
                content: {
                    'application/json': {
                        schema: z.object({
                            name: z.string()
                        })
                    }
                }
            },
            params: z.object({
                name: z.string().nullable()
            }),
            query: z.object({
                name: z.string()
            })
        },
        responses: {
            200: {
                description: 'Respond a message',
                content: {
                    'application/json': {
                        schema: z.object({
                            message: z.string()
                        })
                    }
                }
            }
        }
    }), (c) => {
        return c.json({message: 'ok'})
    })

export default app
