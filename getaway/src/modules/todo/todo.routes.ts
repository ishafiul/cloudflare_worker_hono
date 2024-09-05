import {OpenAPIHono, createRoute, z} from "@hono/zod-openapi"
import {Bindings} from "../../config/bindings";
import {CreateDeviceUuidDto} from "../../../../auth/src/dto/create-device-uuid.dto";
import {zValidator} from "@hono/zod-validator";
import {CreateTodoDto, CreateTodoSchema} from "../../../../todo/src/dto/create-todo.dto";
import {jwt} from "hono/jwt";
import authRoutes from "../auth/auth.routes";
import {ApiCreateTodoDto, ApiCreateTodoDtoSchema} from "./dto/create-todo.dto";
import {ApiTodoEntitySchema} from "./entity/create-todo.entity";


const todoRoutes = new OpenAPIHono<{ Bindings: Bindings }>()


todoRoutes.openapi(
    createRoute({
        method: 'post',
        path: '/createTodo',
        tags: ['Todo'],
        security: [{
            "AUTH": []
        }],
        description: 'Create a new todo item',
        middleware: [zValidator('json', ApiCreateTodoDtoSchema)], // Validate the request body with the Zod schema
        responses: {
            200: {
                description: 'Respond with the created todo item',
                content: {
                    'application/json': {
                        schema: ApiTodoEntitySchema
                    }
                }
            },
            422: {
                description: 'Respond with an error message',
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
                description: 'The data required to create a todo item',
                required: true,
                content: {
                    'application/json': {
                        schema: ApiCreateTodoDtoSchema, // Schema to validate the request body
                    }
                }
            }
        }
    }),
    async (c) => {
        const body = ApiCreateTodoDtoSchema.parse(await c.req.json());

        try {
            const todoService = await c.env.TODO_SERVICE.newTodo();
            // @ts-ignore
            const jwtPayload: { authID: string } = c.get('jwtPayload');
            type CreateTodoDtoWithUserId = ApiCreateTodoDto & { userId: string };
            const reBody: CreateTodoDtoWithUserId = {
                ...body, // spreading the original body object
                userId: jwtPayload.authID, // adding the userId
            };

            const todoEntity = await todoService.create(reBody)
            const validatedTodoEntity = ApiTodoEntitySchema.parse(todoEntity[0]);
            return c.json(validatedTodoEntity, 200);
        } catch (error) {
            return c.json({message: "Failed to create todo"}, 422);
        }
    },
)

export default todoRoutes