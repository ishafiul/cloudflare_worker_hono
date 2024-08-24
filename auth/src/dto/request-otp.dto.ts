import {z} from "zod";

export const RequestOtpSchema = z.object({
	email: z.string().email(),
	deviceUuid: z.string(),
})

export type RequestOtpDto = z.infer<typeof RequestOtpSchema>;
