import {OpenAPIHono, z} from '@hono/zod-openapi'
import {Bindings} from "./config/bindings";
import {swaggerUI} from '@hono/swagger-ui'
import authRoutes from "./modules/auth/auth.routes";
import {logger} from 'hono/logger';
import {jwt} from "hono/jwt";
import todoRoutes from "./modules/todo/todo.routes";

const app = new OpenAPIHono<{ Bindings: Bindings }>()

app.get('/', (c) => c.text('Api Server'))
app.openAPIRegistry.registerComponent("securitySchemes", "AUTH", {
    type: "http",
    name: "Authorization",
    scheme: "bearer",
    in: "header",
    description: "Bearer token",
});
app.get(
    '/ui',
    swaggerUI({
        url: '/doc',
    })
)

app.doc('/doc', {
    info: {
        title: 'Todo API',
        version: 'v1'
    },
    openapi: '3.1.0'
})


app.route('/auth', authRoutes)


app.use('/todo/*', (c, next) => {
    const jwtMiddleware = jwt({
        secret: c.env.JWT_SECRET,
    })
    // @ts-ignore
    return jwtMiddleware(c, next)
})
app.route('/todo', todoRoutes)

export default app