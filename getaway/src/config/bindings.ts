import {AuthService} from "../../../auth/src";
import {UserService} from "../../../user/src";
import {EmailService} from "../../../mail/src";
import {TodoService} from "../../../todo/src";

export type Bindings = {
    JWT_SECRET: string;
    GOOGLE_CLIENT_ID: string;
    GOOGLE_CLIENT_SECRET: string;
    GOOGLE_REDIRECT_URI: string;
} & Services

type Services = {
    AUTH_SERVICE: Service<AuthService>
    USER_SERVICE: Service<UserService>
    EMAIL_SERVICE: Service<EmailService>
    TODO_SERVICE: Service<TodoService>
}
/*type Services = {
    [k in typeof ServiceList[number]]: Service
}

export const ServiceList = [
    "AUTH_SERVICE",
    "TEST_SERVICE"
] as const;*/


