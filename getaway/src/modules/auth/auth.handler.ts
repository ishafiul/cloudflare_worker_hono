import {Context} from "hono";
import {Bindings} from "../../config/bindings";
import {CreateDeviceUuidDto} from "../../../../auth/src/dto/create-device-uuid.dto";
import {RequestOtpDto} from "../../../../auth/src/dto/request-otp.dto";
import {decode, sign, verify} from 'hono/jwt'
import {VerifyOtpDto} from "../../../../auth/src/dto/verify-otp.dto";
import {HTTPException} from 'hono/http-exception'

export async function createDeviceUuidHandler(c: Context<{ Bindings: Bindings } >) {
    const auth = await c.env.AUTH_SERVICE.newAuth();
    const body = await c.req.json<CreateDeviceUuidDto>()

    const deviceUuidEntity = await auth.createDeviceUuid(body);
    if(deviceUuidEntity === undefined) {
        return c.json({message: "create device uuid failed"}, 422)
    }
    return c.json(deviceUuidEntity, 200)
}

export async function reqOtpHandler(c: Context<{ Bindings: Bindings }>) {
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
        await mailService.sentOtp(body.email, requestOtpEntity.otp)
        return c.json({
            message: "send otp success"
        }, 200)
    } catch (e: any) {
        return c.json({
            message: e.message
        }, 422)
    }


}

export async function verifyOtpHandler(c: Context<{ Bindings: Bindings }>) {
    let authService = await c.env.AUTH_SERVICE.newAuth();
    const body = await c.req.json<VerifyOtpDto>()
    let userService = await c.env.USER_SERVICE.newUser();

    const user = await userService.findUserOrCreate(body.email)
    let auth: { id: string }
    try {
        auth = await authService.verifyOtp(body, user);
    } catch (e: any) {
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
}


