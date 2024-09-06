import {z} from '@hono/zod-openapi'

export const VerifyOtpSchema = z.object({
	email: z.string().email(),
	deviceUuid: z.string(),
	otp: z.number(),
}).openapi('VerifyOtpDto')

export type VerifyOtpDto = z.infer<typeof VerifyOtpSchema>;
