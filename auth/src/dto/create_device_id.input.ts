import {z} from "@hono/zod-openapi";
import {createZodObject} from "../utils/zod.utils";

export const createDeviceIdInputSchema = z.object({
    deviceType: z.string(),
    osName: z.string().optional(),
    deviceModel: z.string().optional(),
    isPhysicalDevice: z.string().optional(),
    appVersion: z.string().optional(),
    ipAddress: z.string().optional(),
    fcmToken: z.string(),
});

export type CreateDeviceIdInput = z.infer<typeof createDeviceIdInputSchema>;

