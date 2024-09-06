import { z } from '@hono/zod-openapi'

export const AccessTokenSchema = z.object({
	deviceUuid: z.string(),
})

export type AccessTokenEntity = z.infer<typeof AccessTokenSchema>;
