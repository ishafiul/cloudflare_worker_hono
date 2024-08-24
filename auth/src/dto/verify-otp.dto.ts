import {z} from "zod";

export const VerifyOtpSchema = z.object({
	email: z.string().email(),
	deviceUuid: z.string(),
	otp: z.number(),
})

export type VerifyOtpDto = z.infer<typeof VerifyOtpSchema>;
