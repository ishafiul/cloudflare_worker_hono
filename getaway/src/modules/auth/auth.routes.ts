import {OpenAPIHono, createRoute, z} from "@hono/zod-openapi"
import {Bindings} from "../../config/bindings";
import {CreateDeviceUuidDto, CreateDeviceUuidSchema} from "../../../../auth/src/dto/create-device-uuid.dto";
import {zValidator} from "@hono/zod-validator";
import {RequestOtpDto, RequestOtpSchema} from "../../../../auth/src/dto/request-otp.dto";
import {VerifyOtpDto, VerifyOtpSchema} from "../../../../auth/src/dto/verify-otp.dto";
import {HTTPException} from "hono/http-exception";
import {jwt, sign} from "hono/jwt";
import {JWTPayload} from "hono/dist/types/utils/jwt/types";
import {Context} from "hono";

const authRoutes = new OpenAPIHono<{ Bindings: Bindings }>()

const createDeviceUuid = createRoute({
    method: 'post',
    path: '/createDeviceUuid',
    tags: ['Auth'],
    description: 'Create device uuid',
    middleware: [zValidator('json', CreateDeviceUuidSchema)],
    responses: {
        200: {
            description: 'Respond a message',
            content: {
                'application/json': {
                    schema: z.object({
                        deviceUuid: z.string()
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
            description: 'Create device uuid',
            required: true,
            content: {
                'application/json': {
                    schema: CreateDeviceUuidSchema,
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
    method: 'delete',
    path: '/logout',
    security: [{
        "AUTH": []
    }],
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
})


authRoutes.openapi(
    createDeviceUuid, async (c) => {
        const auth = await c.env.AUTH_SERVICE.newAuth();
        const body = await c.req.json<CreateDeviceUuidDto>()

        const deviceUuidEntity = await auth.createDeviceUuid(body);
        if (deviceUuidEntity === undefined) {
            return c.json({message: "create device uuid failed"}, 422)
        }
        return c.json(deviceUuidEntity, 200)
    },
)

authRoutes.openapi(
    reqOtp, async (c) => {
        let auth = await c.env.AUTH_SERVICE.newAuth();
        let mailService = await c.env.EMAIL_SERVICE.newEmail();
        const body = await c.req.json<RequestOtpDto>()
        let userService = await c.env.USER_SERVICE.newUser();

        const user = await userService.findUserOrCreate(body.email)
        if (user === undefined) {
            return c.json({
                message: "user not found"
            }, 422)
        }
        try {
            const requestOtpEntity = await auth.reqOtp(body, user);
            await mailService.sentOtp(body.email, requestOtpEntity.otp);
            return c.json({
                message: "send otp success"
            }, 200)
        } catch (e: any) {
            return c.json({
                message: e.message
            }, 422)
        }

    },
)

authRoutes.openapi(
    verifyOtp, async (c) => {
        console.log(`in`);
        let authService = await c.env.AUTH_SERVICE.newAuth();
        let userService = await c.env.USER_SERVICE.newUser();
        const body = await c.req.json<VerifyOtpDto>()


        const user = await userService.findUserOrCreate(body.email)
        console.log(user);
        let auth: { id: string }
        try {
            auth = await authService.verifyOtp(body, user);
            console.log(auth);
        } catch (e: any) {
            console.log(e);
            throw new HTTPException(422, {
                message: e.message
            })
        }
        const jwtPayload = {
            authID: auth.id,
        };
        return c.json({
            accessToken: await sign(jwtPayload, c.env.JWT_SECRET,),
        }, 200);
    },
)
authRoutes.use('/logout', (c, next) => {
    const jwtMiddleware = jwt({
        secret: c.env.JWT_SECRET,
    })
    // @ts-ignore
    return jwtMiddleware(c, next)
})
authRoutes.openapi(
    logout, async (c) => {
        const auth = await c.env.AUTH_SERVICE.newAuth();
        // @ts-ignore
        const jwtPayload: { authID: string } = c.get('jwtPayload');
        console.log(jwtPayload.authID)
       const result = await auth.logout(jwtPayload.authID);
        console.log(result)
        if (!result) {
            return c.json({message: "logout failed"}, 200)
        }
        return c.json({message: "logout success"}, 200)
    }
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


interface Env {
    GOOGLE_CLIENT_ID: string;
    GOOGLE_CLIENT_SECRET: string;
    GOOGLE_REDIRECT_URI: string;
}

// Route to start the OAuth flow
authRoutes.get('/google', async (c) => {
    const env: Env = c.env;
    const GOOGLE_AUTH_ENDPOINT = 'https://accounts.google.com/o/oauth2/v2/auth';
    const responseType = 'code';
    const scope = encodeURIComponent('https://www.googleapis.com/auth/userinfo.email');
    const accessType = 'offline'; // For getting a refresh token

    // Construct the authorization URL manually
    const authUrl = `${GOOGLE_AUTH_ENDPOINT}?response_type=${responseType}&client_id=${encodeURIComponent(env.GOOGLE_CLIENT_ID)}&redirect_uri=${encodeURIComponent(env.GOOGLE_REDIRECT_URI)}&scope=${scope}&access_type=${accessType}`;
    return c.redirect(authUrl);
});

// OAuth callback route
authRoutes.get('/oauth2callback', async (c) => {
    const env: Env = c.env;
    const url = new URL(c.req.url);
    const code = url.searchParams.get('code');

    if (!code) {
        return c.text('Authorization code not found', 400);
    }

    const GOOGLE_TOKEN_ENDPOINT = 'https://oauth2.googleapis.com/token';

    const tokenResponse = await fetch(GOOGLE_TOKEN_ENDPOINT, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: new URLSearchParams({
            code: code,
            client_id: env.GOOGLE_CLIENT_ID,
            client_secret: env.GOOGLE_CLIENT_SECRET,
            redirect_uri: env.GOOGLE_REDIRECT_URI,
            grant_type: 'authorization_code',
        }),
    });

    const tokenData = await tokenResponse.json();

    return c.text('User account created successfully.');

});

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