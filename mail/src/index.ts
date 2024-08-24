import {RpcTarget, WorkerEntrypoint} from "cloudflare:workers";
import {Bindings} from "./config/bindings";

export class Email extends RpcTarget {
	#env: Bindings;


	constructor(env: Bindings) {
		super();
		this.#env = env;
	}

	async sentOtp(email: string, otp: number) {
		try {
			const url = new URL('https://api.groundcraft.xyz/mail')
			const response = await fetch('https://api.groundcraft.xyz/mail', {
				method: "POST",
				headers: {
					"Content-Type": "application/json",
					"Authorization": `Bearer ${this.#env.SERVER_KEY}`
				},
				body: JSON.stringify({
					"to": email,
					"type": {
						"otp": {
							"otpCode": otp.toString()
						}
					}
				}),
				cf: {resolveOverride: 'api.groundcraft.xyz'}
			});

			if (!response.ok) {
				const responseText = await response.text();
				throw new Error(`Failed to send email: ${response.status} - ${response.statusText} - ${responseText}`);
			}
		} catch (e) {
			console.error('Error sending OTP:', e);
			throw new Error('Failed to send email');
		}
	}

	async #fetchAndRetry(url: string, options: RequestInit, retries = 5): Promise<any> {
		const response = await fetch(url, options)
		if (response.ok || retries === 0) {
			return response
		}

		await this.#delay()

		return await this.#fetchAndRetry(url, options, retries - 1)
	}

	async #delay(ms = 1000) {
		return new Promise((resolve) => setTimeout(resolve, ms))
	}
}

export class EmailService extends WorkerEntrypoint<Bindings> {
	async newEmail() {

		return new Email(this.env);
	}
}

export default {
	fetch() {
		return new Response("Mail Service")
	}
}
