import { z } from '@hono/zod-openapi'

export const DeviceUuidSchema = z.object({
	deviceUuid: z.string(),
})

export type DeviceUuidEntity = z.infer<typeof DeviceUuidSchema>;
