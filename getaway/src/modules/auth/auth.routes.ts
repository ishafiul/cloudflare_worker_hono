import {OpenAPIHono, createRoute, z} from "@hono/zod-openapi"
import {Bindings} from "../../config/bindings";
import {CreateDeviceUuidDto, CreateDeviceUuidSchema} from "../../../../auth/src/dto/create-device-uuid.dto";
import {zValidator} from "@hono/zod-validator";
import {RequestOtpDto, RequestOtpSchema} from "../../../../auth/src/dto/request-otp.dto";
import {VerifyOtpDto, VerifyOtpSchema} from "../../../../auth/src/dto/verify-otp.dto";
import {jwt, sign} from "hono/jwt";

const authRoutes = new OpenAPIHono<{ Bindings: Bindings }>()

// Route: Create Device UUID
const createDeviceUuid = createRoute({
    method: 'post',
    path: '/createDeviceUuid',
    tags: ['Auth'],
    description: 'Create device UUID',
    middleware: [zValidator('json', CreateDeviceUuidSchema)],
    responses: {
        200: {
            description: 'Respond with device UUID',
            content: {
                'application/json': {schema: z.object({deviceUuid: z.string()})},
            },
        },
        422: {
            description: 'Validation error',
            content: {
                'application/json': {schema: z.object({message: z.string()})},
            },
        },
    },
    request: {
        body: {
            description: 'Device UUID creation request',
            required: true,
            content: {
                'application/json': {schema: CreateDeviceUuidSchema},
            },
        },
    },
});

// Route: Request OTP
const reqOtp = createRoute({
    method: 'post',
    path: '/reqOtp',
    tags: ['Auth'],
    middleware: [zValidator('json', RequestOtpSchema)],
    responses: {
        200: {
            description: 'OTP sent successfully',
            content: {
                'application/json': {schema: z.object({message: z.string()})},
            },
        },
        422: {
            description: 'Validation error',
            content: {
                'application/json': {schema: z.object({message: z.string()})},
            },
        },
    },
    request: {
        body: {
            content: {
                'application/json': {
                    schema: RequestOtpSchema,
                    example: {
                        email: 'shafiulislam20@gmail.com',
                        deviceUuid: 'e3716131-6aaa-4c5d-b468-71eb9a410b5c',
                    },
                },
            },
        },
    },
});

// Route: Verify OTP
const verifyOtp = createRoute({
    method: 'post',
    path: '/verifyOtp',
    tags: ['Auth'],
    middleware: [zValidator('json', VerifyOtpSchema)],
    responses: {
        200: {
            description: 'Access Token',
            content: {
                'application/json': {schema: z.object({accessToken: z.string()})},
            },
        },
        422: {
            description: 'Validation error',
            content: {
                'application/json': {schema: z.object({message: z.string()})},
            },
        },
    },
    request: {
        body: {
            content: {
                'application/json': {
                    schema: VerifyOtpSchema,
                    example: {
                        email: 'shafiulislam20@gmail.com',
                        deviceUuid: 'e3716131-6aaa-4c5d-b468-71eb9a410b5c',
                        otp: 12345,
                    },
                },
            },
        },
    },
});

// Route: Login with Google
const loginWithGoogle = createRoute({
    method: 'post',
    path: '/loginWithGoogle',
    tags: ['Auth'],
    responses: {
        200: {
            description: 'Login successful',
            content: {
                'application/json': {schema: z.object({message: z.string()})},
            },
        },
    },
    request: {
        body: {
            content: {
                'application/json': {
                    schema: z.object({
                        username: z.string(),
                        password: z.string(),
                    }),
                },
            },
        },
    },
});

// Route: Refresh Token
const refreshToken = createRoute({
    method: 'post',
    path: '/refreshToken',
    tags: ['Auth'],
    middleware: [zValidator('json', z.object({deviceUuid: z.string()}))],
    responses: {
        200: {
            description: 'New access token',
            content: {
                'application/json': {schema: z.object({accessToken: z.string()})},
            },
        },
        401: {
            description: 'Unauthorized',
            content: {
                'application/json': {schema: z.object({message: z.string()})},
            },
        },
    },
    request: {
        body: {
            content: {
                'application/json': {
                    schema: z.object({deviceUuid: z.string()}).openapi('RefreshTokenDto'),
                },
            },
        },
    },
});

// Route: Logout
const logout = createRoute({
    method: 'delete',
    path: '/logout',
    security: [{AUTH: []}],
    tags: ['Auth'],
    responses: {
        200: {
            description: 'Logout successful',
            content: {
                'application/json': {schema: z.object({message: z.string()})},
            },
        },
        401: {
            description: 'Unauthorized',
            content: {
                'application/json': {schema: z.object({message: z.string()})},
            },
        },
    },
});

// Implementing API Handlers
authRoutes.openapi(createDeviceUuid, async (c) => {
    const auth = await c.env.AUTH_SERVICE.newAuth();
    const bodyJson = await c.req.json<CreateDeviceUuidDto>();
    const body = CreateDeviceUuidSchema.parse(bodyJson);

    try {
        const deviceUuidEntity = await auth.createDeviceUuid(body);
        if (!deviceUuidEntity) return c.json({message: 'Device UUID not created'}, 422);
        return c.json(deviceUuidEntity, 200);
    } catch (error) {
        return c.json({message: 'Something went wrong'}, 422);
    }
});

authRoutes.openapi(reqOtp, async (c) => {
    const auth = await c.env.AUTH_SERVICE.newAuth();
    const mailService = await c.env.EMAIL_SERVICE.newEmail();
    const userService = await c.env.USER_SERVICE.newUser();
    const bodyJson = await c.req.json<RequestOtpDto>();
    const body = RequestOtpSchema.parse(bodyJson);

    try {
        const user = await userService.findUserOrCreate(body.email);
        if (!user) return c.json({message: 'User not found'}, 422);

        const otpEntity = await auth.reqOtp(body, user);
        if (body.email !== 'shafiulislam20@gmail.com') {
            await mailService.sentOtp(body.email, otpEntity.otp);
        }
        return c.json({message: 'OTP sent successfully'}, 200);
    } catch (error) {
        return c.json({message: 'Something went wrong'}, 422);
    }
});

authRoutes.openapi(verifyOtp, async (c) => {
    const authService = await c.env.AUTH_SERVICE.newAuth();
    const userService = await c.env.USER_SERVICE.newUser();
    const bodyJson = await c.req.json<VerifyOtpDto>();
    const body = VerifyOtpSchema.parse(bodyJson);

    try {
        const user = await userService.findUserOrCreate(body.email);
        const auth = await authService.verifyOtp(body, user);
        const jwtPayload = {
            authID: auth.id,
            exp: Math.floor(Date.now() / 1000) + 60 * 5,
        };
        return c.json({accessToken: await sign(jwtPayload, c.env.JWT_SECRET)}, 200);
    } catch (error) {
        return c.json({message: "Invalid OTP"}, 422);
    }
});

authRoutes.use('/logout', (c, next) => {
    const jwtMiddleware = jwt({secret: c.env.JWT_SECRET});
    // @ts-ignore
    return jwtMiddleware(c, next);
});

authRoutes.openapi(logout, async (c) => {
    const auth = await c.env.AUTH_SERVICE.newAuth();
    // @ts-ignore
    const {authID} = c.get('jwtPayload');
    const result = await auth.logout(authID);

    return result
        ? c.json({message: "Logout successful"}, 200)
        : c.json({message: "Something went wrong"}, 401);
});

authRoutes.openapi(refreshToken, async (c) => {
    const auth = await c.env.AUTH_SERVICE.newAuth();
    const bodyJson = await c.req.json<{ deviceUuid: string }>();
    const {deviceUuid} = z.object({deviceUuid: z.string()}).parse(bodyJson);

    const authResult = await auth.findAuthByDeviceId(deviceUuid);
    if (!authResult) return c.json({message: "Unauthorized"}, 401);

    if (!(await auth.isCanRefresh(authResult.id))) {
        return c.json({message: "Unauthorized"}, 401);
    }

    await auth.updateLastRefresh(authResult.id);
    const jwtPayload = {
        authID: authResult.id,
        exp: Math.floor(Date.now() / 1000) + 60 * 5,
    };

    return c.json({
        accessToken: await sign(jwtPayload, c.env.JWT_SECRET),
    }, 200);
});

export default authRoutes;