import {OpenAPIHono, createRoute, z} from '@hono/zod-openapi'
import {zValidator} from "@hono/zod-validator";
import {hc} from 'hono/client'
import {AppRouterssss} from '../../users/src/'
import {createDeviceIdInputSchema} from "./dto/create_device_id.input";
import {Bindings, ServiceList} from "./config/bindings";

const routes = new OpenAPIHono<{ Bindings: Bindings }>()

routes.get('/', (c) => c.text('Auth Service'))

routes.openapi(
    createRoute({
        method: 'post',
        path: '/login',
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
        },
        request: {
            body: {
                content: {
                    'application/json': {
                        schema: createDeviceIdInputSchema
                    }
                }
            }
        }
    }),

    async (c) => {
        return c.json({
            message: "Hello World"
        })
    }
)

const paramsSchema = z.object(
    {
        service: z.enum(ServiceList)
    }
)

routes.all('/api/:service/*', zValidator("param", paramsSchema), async (c, next) => {
    const params = paramsSchema.parse(c.req.param())

    const url = new URL(c.req.url.replace('/api/' + params.service, ''));

    const service = c.env[params.service]
    /*
    const client = hc<AppRouterssss>(baseUrl, {fetch: service.fetch.bind(service)})
    client.test.$get()

     */
    console.log(url)
    console.log(service)
    /*return c.json({
        message: "Hello World"
    })*/
    return service.fetch(url, {
        headers: c.req.header(),
        method: c.req.method,
    })
});


export default routes