import {OpenAPIHono, createRoute, z} from "@hono/zod-openapi"
import {Bindings} from "../../config/bindings";
import {createDeviceUuidHandler, reqOtpHandler, verifyOtpHandler} from "./auth.handler";
import {DeviceUuidSchema} from "../../../../auth/src/entities/device-uuid.entity";
import {CreateDeviceUuidSchema} from "../../../../auth/src/dto/create-device-uuid.dto";
import {zValidator} from "@hono/zod-validator";
import {RequestOtpSchema} from "../../../../auth/src/dto/request-otp.dto";
import {VerifyOtpSchema} from "../../../../auth/src/dto/verify-otp.dto";

const authRoutes = new OpenAPIHono<{ Bindings: Bindings }>()

const createDeviceUuid = createRoute({
    method: 'post',
    path: '/createDeviceUuid',
    tags: ['Auth'],
    middleware: [zValidator('json', z.object({CreateDeviceUuidSchema}))],
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
            description: 'Create device uuid',

            content: {
                'application/json': {
                    schema: CreateDeviceUuidSchema

                }
            }
        }
    }
})

const reqOtp = createRoute({
    method: 'post',
    path: '/reqOtp',
    tags: ['Auth'],
    middleware: [zValidator('json', RequestOtpSchema)],
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
        },
        422: {
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
                    schema: RequestOtpSchema
                }
            }
        }
    }
})


const verifyOtp = createRoute({
    method: 'post',
    path: '/verifyOtp',
    tags: ['Auth'],
    middleware: [zValidator('json', RequestOtpSchema)],
    responses: {
        200: {
            description: 'Respond a message',
            content: {
                'application/json': {
                    schema: z.object({
                        accessToken: z.string()
                    })
                }
            }
        }
    },
    request: {
        body: {
            content: {
                'application/json': {
                    schema: VerifyOtpSchema
                }
            }
        }
    }
})

const loginWithGoogle = createRoute({
    method: 'post',
    path: '/loginWithGoogle',
    tags: ['Auth'],
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
                    schema: z.object({
                        username: z.string(),
                        password: z.string()
                    })
                }
            }
        }
    }
})


const refreshToken = createRoute({
    method: 'post',
    path: '/refreshToken',
    tags: ['Auth'],
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
                    schema: z.object({
                        username: z.string(),
                        password: z.string()
                    })
                }
            }
        }
    }
})


const logout = createRoute({
    method: 'post',
    path: '/logout',
    tags: ['Auth'],

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
                    schema: z.object({
                        username: z.string(),
                        password: z.string()
                    })
                }
            }
        }
    }
})


authRoutes.openapi(
    createDeviceUuid, createDeviceUuidHandler,
)

authRoutes.openapi(
    reqOtp, reqOtpHandler,
)

authRoutes.openapi(
    verifyOtp, verifyOtpHandler,
)

authRoutes.openapi(
    createRoute({
        method: 'get',
        path: '/test',
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
        request: {}
    }),
    async (c) => {
        const ds = await c.env.EMAIL_SERVICE.newEmail();
        await ds.sentOtp("shafiulislam20@gmail.com", 123);
        return c.json({
            message: 'Respond a message',
        })
    }
)
/*
authRoutes.openapi(
    refreshToken, loginHandler,
)

authRoutes.openapi(
    refreshToken, loginHandler,
)

authRoutes.openapi(
    logout, loginHandler,
)*/
export default authRoutes