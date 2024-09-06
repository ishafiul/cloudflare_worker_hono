import { z } from '@hono/zod-openapi'

export const RequestOtpSchema = z.object({
	email: z.string().email(),
	deviceUuid: z.string(),
}).openapi('RequestOtpDto')

export type RequestOtpDto = z.infer<typeof RequestOtpSchema>;
