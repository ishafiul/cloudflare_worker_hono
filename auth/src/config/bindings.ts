export type Bindings = {
    TURSO_DATABASE_URL: string;
    TURSO_AUTH_TOKEN: string;
} & Services

type Services = {
    [k in typeof ServiceList[number]]: Fetcher
}

export const ServiceList = [
    "USER_SERVICE",
    "TEST_SERVICE"
] as const;


