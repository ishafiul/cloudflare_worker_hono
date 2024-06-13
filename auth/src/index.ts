import {Hono} from 'hono'
import {OpenAPIHono, createRoute, z} from '@hono/zod-openapi'
import {swaggerUI} from '@hono/swagger-ui'
import {hc} from 'hono/client'
import {AppRouterssss} from '../../users/src/'

import {zValidator} from "@hono/zod-validator";
import routes from "./routes";
import {Bindings} from "./config/bindings";

const app = new OpenAPIHono<{ Bindings: Bindings  }>()

app.get(
    '/ui',
    swaggerUI({
        url: '/doc'
    })
)

app.doc('/doc', {
    info: {
        title: 'Auth API',
        version: 'v1'
    },
    openapi: '3.1.0'
})

app.route('/', routes)

export default app
