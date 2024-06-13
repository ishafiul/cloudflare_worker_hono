import { WorkerEntrypoint, RpcTarget } from 'cloudflare:workers';

class User extends RpcTarget {
	#value = 0;

	increment(amount) {
		this.#value += amount;
		return this.#value;
	}

	get value() {
		return this.#value;
	}
}

export class UserService extends WorkerEntrypoint {
	async newUser() {
		return new User();
	}
}
