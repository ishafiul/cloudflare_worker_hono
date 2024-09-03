import {WorkerEntrypoint, RpcTarget} from "cloudflare:workers";
import {drizzle, LibSQLDatabase} from "drizzle-orm/libsql";
import {createClient} from "@libsql/client";
import {DeviceUuidEntity} from "./entities/device-uuid.entity";
import {CreateDeviceUuidDto} from "./dto/create-device-uuid.dto";
import {RequestOtpDto} from "./dto/request-otp.dto";
import {auths, devices, otps} from "../drizzle/schema";
import {v4 as uuidv4} from 'uuid';
import {Bindings} from "./config/bindings";
import {and, eq} from "drizzle-orm";
import {VerifyOtpDto} from "./dto/verify-otp.dto";
import {generateOtp} from "./utils/functions";

export class Auth extends RpcTarget {
	#env: Bindings;
	private readonly db: LibSQLDatabase;


	constructor(env: Bindings) {
		super();
		this.#env = env;
		this.db = this.#buildDbClient();
	}

	#buildDbClient(): LibSQLDatabase {
		const url = this.#env.TURSO_URL;
		if (url === undefined) {
			throw new Error('TURSO_URL is not defined');
		}

		const authToken = this.#env.TURSO_AUTH_TOKEN;
		if (authToken === undefined) {
			throw new Error('TURSO_AUTH_TOKEN is not defined');
		}

		return drizzle(createClient({url, authToken}));
	}

	async createDeviceUuid(payload: CreateDeviceUuidDto): Promise<DeviceUuidEntity> {

		if (this.db === undefined) {
			throw new Error('db is not defined');
		}
		const devicesRes = await this.db.insert(devices).values({
			id: uuidv4(),
			deviceType: payload.deviceType,
			deviceModel: payload.deviceModel,
			isPhysicalDevice: payload.isPhysicalDevice ? "true" : "false",
			osName: payload.osName,
			appVersion: payload.appVersion,
			ipAddress: payload.ipAddress,
			osVersion: payload.osVersion,
			fcmToken: payload.fcmToken
		}).returning({deviceUuid: devices.id}).onConflictDoUpdate({
			target: devices.fcmToken,
			set: {
				deviceType: payload.deviceType,
				deviceModel: payload.deviceModel,
				osName: payload.osName,
				appVersion: payload.appVersion,
				isPhysicalDevice: payload.isPhysicalDevice ? "true" : "false",
				ipAddress: payload.ipAddress,
				fcmToken: payload.fcmToken,
				osVersion: payload.osVersion
			}
		});
		return {
			deviceUuid: devicesRes[0].deviceUuid
		}
	}

	async reqOtp(payload: RequestOtpDto, userInfo: { id: string, email: string }): Promise<{ otp: number }> {
		// Step 1: Check if the device exists
		const device = await this.getDevice(payload.deviceUuid);
		if (device === undefined) {
			throw new Error('Device not found');
		}

		// Step 2: Delete existing auths for the user
		await this.db.delete(auths).where(eq(auths.userId, userInfo.id));

		// Step 3: Try to get an existing OTP for the device and email
		let otp = await this.getOtp(payload.deviceUuid, payload.email);

		// Step 4: If no OTP exists, generate a new one
		if (otp === undefined) {
			const newOtp = generateOtp(5);
			await this.insertOtp({
				otp: parseInt(newOtp),
				email: payload.email,
				deviceUuId: payload.deviceUuid
			});
			return {
				otp: parseInt(newOtp)
			};
		}

		// Step 5: Check if the existing OTP has expired
		if (otp.expiredAt !== null && otp.expiredAt.toISOString() < new Date().toISOString()) {
			await this.updateOtp(otp.id); // Mark the OTP as used or expired
			return {
				otp: otp.otp
			};
		}

		// Step 6: If OTP is still valid, re-insert it (optional, depending on your logic)
		await this.insertOtp({
			otp: otp.otp,
			email: payload.email,
			deviceUuId: payload.deviceUuid
		});
		return {
			otp: otp.otp
		};
	}


	async verifyOtp(payload: VerifyOtpDto, user: { id: string, email: string }) {
		if (user === undefined) {
			throw new Error('user not found');
		}

		const otp = await this.getOtp(payload.deviceUuid, payload.email)
		if (otp == undefined) {
			throw new Error('otp not found');
		}

		if (otp.expiredAt !== null && otp.expiredAt.toISOString() < new Date().toISOString()) {
			///
			throw new Error('otp expired');
		}
		if (otp.otp !== payload.otp) {
			///
			throw new Error('invalid otp');
		}

		await this.db.delete(otps).where(and(eq(otps.deviceUuId, payload.deviceUuid), eq(otps.email, payload.email)))

		const auth = await this.db.insert(auths).values({
			id: uuidv4(),
			deviceId: payload.deviceUuid,
			userId: user.id

		}).returning({
			id: auths.id
		})
		return auth[0];
	}

	async logout(authId: string) {
		const auth = await this.db.select().from(auths).where(eq(auths.id, authId)).get();
		if (auth === undefined) {
			return false
		}
		try {
			await this.db.delete(auths).where(eq(auths.id, authId))
			return true
		} catch (e) {
			return false
		}

	}

	private async getDevice(deviceId: string) {
		return this.db.select().from(devices).where(eq(devices.id, deviceId)).get();
	}

	private async getOtp(deviceId: string, email: string) {
		return this.db.select().from(otps).where(and(eq(otps.deviceUuId, deviceId), eq(otps.email, email))).get();
	}

	private async updateOtp(id: string,) {
		return this.db.update(otps).set({
			expiredAt: new Date(Date.now() + 5 * 60 * 1000),
		}).where(eq(otps.id, id)).get();
	}

	private async insertOtp(args: {
		otp: number,
		email: string,
		deviceUuId: string
	}) {
		return this.db.insert(otps).values({
			id: uuidv4(),
			otp: args.otp,
			email: args.email,
			deviceUuId: args.deviceUuId,
			expiredAt: new Date(Date.now() + 5 * 60 * 1000),
		});
	}
}

export class AuthService extends WorkerEntrypoint<Bindings> {
	async newAuth() {

		return new Auth(this.env);
	}
}

export default {
	fetch() {
		return new Response("ok")
	}
}
