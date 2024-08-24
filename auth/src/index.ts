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
			isPhysicalDevice: payload.isPhysicalDevice,
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
				isPhysicalDevice: payload.isPhysicalDevice,
				osName: payload.osName,
				appVersion: payload.appVersion,
				ipAddress: payload.ipAddress,
				osVersion: payload.osVersion
			}
		});
		return {
			deviceUuid: devicesRes[0].deviceUuid
		}
	}

	async reqOtp(payload: RequestOtpDto, userInfo: { id: string, email: string }): Promise<{ otp: number }> {
		const device = await this.getDevice(payload.deviceUuid)
		if (device === undefined) {
			throw new Error('device not found');
		}
		await this.db.delete(auths).where(eq(auths.userId, userInfo.id))
		const otp = await this.getOtp(payload.deviceUuid, payload.email)
		if (otp == undefined) {
			const otp = generateOtp(5)
			await this.insertOtp({
				otp: parseInt(otp),
				email: payload.email,
				deviceUuId: payload.deviceUuid
			})
			return {
				otp: parseInt(otp)
			}
		}
		// check is [otp.expiredAt] expired or not
		if (otp.expiredAt !== null && otp.expiredAt.toISOString() < new Date().toISOString()) {
			await this.updateOtp(otp.id)
			return {
				otp: otp.otp
			}
		}
		await this.insertOtp({
			otp: otp.otp,
			email: payload.email,
			deviceUuId: payload.deviceUuid
		})
		return {
			otp: otp.otp
		}
	}

	async verifyOtp(payload: VerifyOtpDto) {
		const userService = this.#env.USER_SERVICE.newUser();
		const user = await userService.findUserByEmail(payload.email)
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
