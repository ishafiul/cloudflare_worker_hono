import {OpenAPIHono, z} from '@hono/zod-openapi'
import {Bindings} from "./config/bindings";
import {swaggerUI} from '@hono/swagger-ui'
import authRoutes from "./modules/auth/auth.routes";
import {logger} from 'hono/logger';
import {jwt} from "hono/jwt";

const app = new OpenAPIHono<{ Bindings: Bindings }>()
app.use(logger())
app.get('/', (c) => c.text('Api Server'))

app.get(
    '/ui',
    swaggerUI({
        url: '/doc',
    })
)

app.doc('/doc', {
    info: {
        title: 'Auth API',
        version: 'v1'
    },
    openapi: '3.1.0'
})


app.route('/auth', authRoutes)

export default app