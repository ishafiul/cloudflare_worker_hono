import {OpenAPIHono, createRoute, z} from "@hono/zod-openapi"
import {Bindings} from "../../config/bindings";
import {zValidator} from "@hono/zod-validator";
import {ApiCreateTodoDto, ApiCreateTodoDtoSchema} from "./dto/create-todo.dto";
import {ApiTodoEntitySchema, ApiTodosEntitySchema} from "./entity/create-todo.entity";
import {ApiUpdateTodoDto, ApiUpdateTodoDtoSchema} from "./dto/update-todo.dto";
import {FindTodosOptionsSchema} from "../../../../todo/src/dto/get-todos.dto";
import {ApiFindTodosOptionsSchema} from "./dto/get-todos.dto";


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
            const authService = await c.env.AUTH_SERVICE.newAuth();
            const userId = await authService.findUserIdByAuthId(jwtPayload.authID);
            if (!userId) return c.json({message: "User not found"}, 403);
            const reBody: CreateTodoDtoWithUserId = {
                ...body,
                userId: userId,
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
            const authService = await c.env.AUTH_SERVICE.newAuth();
            const userId = await authService.findUserIdByAuthId(jwtPayload.authID);
            if (!userId) return c.json({message: "User not found"}, 403);
            type UpdateTodoDtoWithUserId = ApiUpdateTodoDto & { userId: string };
            const reBody: UpdateTodoDtoWithUserId = {
                ...body,
                userId: userId,
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
            const authService = await c.env.AUTH_SERVICE.newAuth();
            const userId = await authService.findUserIdByAuthId(jwtPayload.authID);
            if (!userId) return c.json({message: "User not found"}, 403);
            if (todoEntity[0].userId !== userId) {
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

todoRoutes.openapi(
    createRoute({
        method: 'get',
        path: '/',
        tags: ['Todo'],
        security: [{
            "AUTH": []
        }],
        description: 'Get a list of todos with pagination and date filtering',
        responses: {
            200: {
                description: 'Respond with the list of todos',
                content: {
                    'application/json': {
                        schema: ApiTodosEntitySchema
                    }
                }
            },
            404: {
                description: 'No todos found',
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
                description: 'Validation error',
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
            query: ApiFindTodosOptionsSchema
        }
    }),
    async (c) => {
        // Extract query parameters
        let {page, perPage, taskDate} = c.req.query() as {
            page?: string;
            perPage?: string;
            taskDate?: string;
        };
        console.log(taskDate);

        if (taskDate && taskDate.includes('T')) {
            // Split at 'T' to get the date part if 'T' is present
            taskDate = taskDate.split('T')[0];
        }

        console.log(taskDate);
        try {
            const todoService = await c.env.TODO_SERVICE.newTodo();
            const authService = await c.env.AUTH_SERVICE.newAuth();
            // @ts-ignore
            const jwtPayload: { authID: string } = c.get('jwtPayload'); // Get the auth ID
            const userId = await authService.findUserIdByAuthId(jwtPayload.authID);
            if (!userId) {
                return c.json({message: "User not found"}, 401);
            }
            console.log("ok2")
            console.log(page)
            console.log(perPage)
            // Validate and normalize query parameters
            const options = {
                page: parseInt(page ?? "1"),
                perPage: parseInt(perPage ?? "20"),
                taskDate: taskDate ?? new Date().toISOString().split('T')[0],
                userId: userId
            };
            console.log("ok3")
            // Fetch todos using the findTodos function
            const todos = await todoService.getTodos(FindTodosOptionsSchema.parse(options));
            const apiTodos = ApiTodosEntitySchema.parse({
                pageNumber: options.page,
                perPageCount: options.perPage,
                data: z.array(ApiTodoEntitySchema).parse(todos),
            })
            if (apiTodos) {
                console.log("ok4")
                return c.json(apiTodos, 200)
            }
            console.log("ok5")

        } catch (error) {
            console.error(error);
            return c.json({message: "Failed to retrieve todos"}, 422);
        }
    }
);

todoRoutes.openapi(
    createRoute({
        method: 'get',
        path: '/month-todo-count',
        tags: ['Todo'],
        security: [{
            "AUTH": []
        }],
        description: 'Get a count of todos for each date in a given month and year',
        responses: {
            200: {
                description: 'Respond with the todo count per date in the specified month',
                content: {
                    'application/json': {
                        schema: z.object({
                            month: z.string(), // ISO month string
                            data: z.array(
                                z.object({
                                    date: z.string(), // ISO date string
                                    count: z.number()
                                })
                            )
                        })
                    }
                }
            },
            404: {
                description: 'No todos found for the specified month',
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
                description: 'Validation error',
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
            query: z.object({
                year: z.string().length(4, 'Invalid year format'), // Expected year (e.g., "2024")
                month: z.string().min(1).max(2, 'Invalid month format'), // Month as "1" to "12"
            })
        }
    }),
    async (c) => {
        try {
            // Extract query parameters
            const {year, month} = c.req.query() as { year: string; month: string };
            console.log(year)
            console.log(month)
            // Fetch user ID from auth
            const authService = await c.env.AUTH_SERVICE.newAuth();
            // @ts-ignore
            const jwtPayload: { authID: string } = c.get('jwtPayload');
            const userId = await authService.findUserIdByAuthId(jwtPayload.authID);
            console.log(year)
            console.log(month)
            // Fetch todos for the specified month and year
            const todoService = await c.env.TODO_SERVICE.newTodo();
            if (!userId) {
                return c.json({message: 'User ID not found'}, 404);
            }
            console.log(year)
            console.log(month)
            const todos = todoService.getTodoCountsForMonth({year, month, userId});
            console.log(year)
            console.log(month)
            return c.json(todos, 200);

        } catch (error) {
            return c.json({message: 'Failed to retrieve todos'}, 422);
        }
    }
);


export default todoRoutes