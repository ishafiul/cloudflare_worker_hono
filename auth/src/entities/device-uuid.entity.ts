import {z} from "zod";

export const DeviceUuidSchema = z.object({
	deviceUuid: z.string(),
})

export type DeviceUuidEntity = z.infer<typeof DeviceUuidSchema>;
