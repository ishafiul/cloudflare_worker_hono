import {z} from "@hono/zod-openapi";

export type TypeToZod<T> = Required<{
    [K in keyof T]: T[K] extends string | number | boolean | null | undefined
        ? undefined extends T[K]
            ? z.ZodDefault<z.ZodType<Exclude<T[K], undefined>>>
            : z.ZodType<T[K]>
        : z.ZodObject<TypeToZod<T[K]>>;
}>;

export const createZodObject = <T>(obj: TypeToZod<T>) => {
    return z.object(obj);
};