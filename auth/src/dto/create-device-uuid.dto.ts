import {z} from "zod";
import {v4 as uuidv4} from 'uuid';

export const CreateDeviceUuidSchema = z.object({
	deviceType: z.string().optional(),
	osName: z.string().optional(),
	osVersion: z.string().optional(),
	deviceModel: z.string().optional(),
	isPhysicalDevice: z.boolean().optional(),
	appVersion: z.string().optional(),
	ipAddress: z.string().optional(),
	fcmToken: z.string(),
})

export type CreateDeviceUuidDto = z.infer<typeof CreateDeviceUuidSchema>;
