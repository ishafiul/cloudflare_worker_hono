import {UserService} from "../../../user/src";
import {EmailService} from "../../../mail/src";

export type Bindings = {
	TURSO_URL: string;
	TURSO_AUTH_TOKEN: string;
} & Services

type Services = {
	USER_SERVICE: Service<UserService>
	EMAIL_SERVICE: Service<EmailService>
}
