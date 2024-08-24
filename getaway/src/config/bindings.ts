import {AuthService} from "../../../auth/src";
import {UserService} from "../../../user/src";
import {EmailService} from "../../../mail/src";

export type Bindings = {
    JWT_SECRET: string;
} & Services

type Services = {
    AUTH_SERVICE: Service<AuthService>
    USER_SERVICE: Service<UserService>
    EMAIL_SERVICE: Service<EmailService>
}
/*type Services = {
    [k in typeof ServiceList[number]]: Service
}

export const ServiceList = [
    "AUTH_SERVICE",
    "TEST_SERVICE"
] as const;*/


