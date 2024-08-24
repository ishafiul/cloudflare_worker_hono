import {z} from "zod";

export const AccessTokenSchema = z.object({
	deviceUuid: z.string(),
})

export type AccessTokenEntity = z.infer<typeof AccessTokenSchema>;
