import {Hono} from 'hono'
import {OpenAPIHono, createRoute, z} from '@hono/zod-openapi'
import {swaggerUI} from '@hono/swagger-ui'
import {hc} from 'hono/client'
import {AppRouterssss} from '../../users/src/'

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

    async (c) => {
        const url = new URL(c.req.url)
        const baseUrl = `${url.protocol}//${url.hostname}`
        const client = hc<AppRouterssss>(baseUrl, {fetch: c.env.USER_SERVICE.fetch.bind(c.env.USER_SERVICE)})
        const res = await client.test.$get();
        const  fd =await res.json()
        return c.json({
            message: fd.test
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
