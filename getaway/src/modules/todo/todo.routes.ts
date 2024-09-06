import {OpenAPIHono, createRoute, z} from "@hono/zod-openapi"
import {Bindings} from "../../config/bindings";
import {zValidator} from "@hono/zod-validator";
import {ApiCreateTodoDto, ApiCreateTodoDtoSchema} from "./dto/create-todo.dto";
import {ApiTodoEntitySchema} from "./entity/create-todo.entity";
import {ApiUpdateTodoDto, ApiUpdateTodoDtoSchema} from "./dto/update-todo.dto";


const todoRoutes = new OpenAPIHono<{ Bindings: Bindings }>()


todoRoutes.openapi(
    createRoute({
        method: 'post',
        path: '/',
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
            },
            403: {
                description: 'Forbidden',
                content: {
                    'application/json': {
                        schema: z.object({
                            message: z.string()
                        })
                    }
                }
            },
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
                ...body,
                userId: jwtPayload.authID,
            };

            const todoEntity = await todoService.create(reBody)
            const validatedTodoEntity = ApiTodoEntitySchema.parse(todoEntity[0]);
            return c.json(validatedTodoEntity, 200);
        } catch (error) {
            return c.json({message: "Failed to create todo"}, 422);
        }
    },
)


todoRoutes.openapi(
    createRoute({
        method: 'put',
        path: '/{todoId}',
        tags: ['Todo'],
        security: [{
            "AUTH": []
        }],
        description: 'Update an existing todo item',
        middleware: [zValidator('json', ApiUpdateTodoDtoSchema)], // Validate the request body with the Zod schema
        responses: {
            200: {
                description: 'Respond with the updated todo item',
                content: {
                    'application/json': {
                        schema: ApiTodoEntitySchema
                    }
                }
            },
            404: {
                description: 'Todo item not found',
                content: {
                    'application/json': {
                        schema: z.object({
                            message: z.string()
                        })
                    }
                }
            },
            422: {
                description: 'Validation error or update failed',
                content: {
                    'application/json': {
                        schema: z.object({
                            message: z.string()
                        })
                    }
                }
            },
            403: {
                description: 'Forbidden',
                content: {
                    'application/json': {
                        schema: z.object({
                            message: z.string()
                        })
                    }
                }
            },
        },
        request: {
            body: {
                description: 'The data required to update a todo item',
                required: true,
                content: {
                    'application/json': {
                        schema: ApiUpdateTodoDtoSchema, // Schema for updating a todo item
                    }
                }
            },
            params: z.object({
                todoId: z
                    .string()
                    .min(3)
                    .openapi({
                        param: {
                            name: 'todoId',
                            in: 'path',
                        },
                    }),
            })
        }
    }),
    async (c) => {
        const todoId = c.req.param('todoId'); // Extract the todoId from the URL
        const body = ApiUpdateTodoDtoSchema.parse(await c.req.json()); // Parse the request body

        try {
            const todoService = await c.env.TODO_SERVICE.newTodo(); // Use update service
            // @ts-ignore
            const jwtPayload: { authID: string } = c.get('jwtPayload');
            const todoExists = await todoService.findById(todoId);

            if (!todoExists) {
                return c.json({message: "Todo item not found"}, 404); // Return 404 if not found
            }
            if (todoExists[0].userId !== jwtPayload.authID) {
                return c.json({message: "You don't have permission to update this todo item"}, 403);
            }
            type UpdateTodoDtoWithUserId = ApiUpdateTodoDto & { userId: string };
            const reBody: UpdateTodoDtoWithUserId = {
                ...body,
                userId: jwtPayload.authID,
            };

            const updatedTodoEntity = await todoService.update(todoId, reBody); // Perform the update
            const validatedUpdatedTodo = ApiTodoEntitySchema.parse(updatedTodoEntity[0]);
            return c.json(validatedUpdatedTodo, 200);
        } catch (error) {
            return c.json({message: "Failed to update todo"}, 422);
        }
    },
);


todoRoutes.openapi(
    createRoute({
        method: 'get',
        path: '/{todoId}',
        tags: ['Todo'],
        security: [{
            "AUTH": []
        }],
        description: 'Get a specific todo item by ID',
        responses: {
            200: {
                description: 'Respond with the requested todo item',
                content: {
                    'application/json': {
                        schema: ApiTodoEntitySchema
                    }
                }
            },
            404: {
                description: 'Todo item not found',
                content: {
                    'application/json': {
                        schema: z.object({
                            message: z.string()
                        })
                    }
                }
            },
            403: {
                description: 'Forbidden',
                content: {
                    'application/json': {
                        schema: z.object({
                            message: z.string()
                        })
                    }
                }
            },
        },
        request: {
            params: z.object({
                todoId: z
                    .string()
                    .min(3)
                    .openapi({
                        param: {
                            name: 'todoId',
                            in: 'path',
                        },
                    }),
            })
        }
    }),
    async (c) => {
        const todoId = c.req.param('todoId'); // Extract the todoId from the URL

        try {
            const todoService = await c.env.TODO_SERVICE.newTodo(); // Fetch the Todo service
            // @ts-ignore
            const jwtPayload: { authID: string } = c.get('jwtPayload'); // Get the auth ID

            const todoEntity = await todoService.findById(todoId);

            if (!todoEntity) {
                return c.json({message: "Todo item not found"}, 404); // Return 404 if not found
            }
            if (todoEntity[0].userId !== jwtPayload.authID) {
                return c.json({message: "You don't have permission to update this todo item"}, 403);
            }
            const validatedTodoEntity = ApiTodoEntitySchema.parse(todoEntity[0]);
            return c.json(validatedTodoEntity, 200);
        } catch (error) {
            return c.json({message: "Failed to retrieve todo"}, 404);
        }
    },
);

todoRoutes.openapi(
    createRoute({
        method: 'delete',
        path: '/{todoId}',
        tags: ['Todo'],
        security: [{
            "AUTH": []
        }],
        description: 'Delete a specific todo item by ID',
        responses: {
            200: {
                description: 'Respond with a success message after deleting the todo',
                content: {
                    'application/json': {
                        schema: z.object({
                            message: z.string()
                        })
                    }
                }
            },
            404: {
                description: 'Todo item not found',
                content: {
                    'application/json': {
                        schema: z.object({
                            message: z.string()
                        })
                    }
                }
            },
            403: {
                description: 'Forbidden',
                content: {
                    'application/json': {
                        schema: z.object({
                            message: z.string()
                        })
                    }
                }
            },
            422: {
                description: 'Validation error or update failed',
                content: {
                    'application/json': {
                        schema: z.object({
                            message: z.string()
                        })
                    }
                }
            },
        },
        request: {
            params: z.object({
                todoId: z
                    .string()
                    .openapi({
                        param: {
                            name: 'todoId',
                            in: 'path',
                        },
                    }),
            })
        }
    }),
    async (c) => {
        const todoId = c.req.param('todoId'); // Extract the todoId from the URL

        try {
            const todoService = await c.env.TODO_SERVICE.newTodo(); // Fetch the Todo service
            // @ts-ignore
            const jwtPayload: { authID: string } = c.get('jwtPayload');

            const todoEntity = await todoService.findById(todoId);

            if (!todoEntity || todoEntity.length === 0) {
                return c.json({message: "Todo item not found"}, 404); // Return 404 if not found
            }

            // Ensure the user deleting the todo is the owner
            if (todoEntity[0].userId !== jwtPayload.authID) {
                return c.json({message: "You don't have permission to delete this todo item"}, 403);
            }

            // Perform the delete operation
            await todoService.delete(todoId);

            return c.json({message: "Todo item deleted successfully"}, 200);
        } catch (error) {
            return c.json({message: "Failed to delete todo"}, 422);
        }
    },
);


export default todoRoutes