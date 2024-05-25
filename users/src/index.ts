import {Hono} from 'hono'
import { cors } from 'hono/cors'

const app = new Hono()
app.use('*', cors())
const appRouterssss = app.get('/', (c) => {
    return c.text('Hello Hono!')
}).get('/test', (c) => {
    return c.json({test: 'test'})
})

export default app

export type AppRouterssss = typeof appRouterssss
