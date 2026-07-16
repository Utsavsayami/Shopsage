import z from "zod";
import {
  ROLE_CUSTOMER,
  ROLE_ADMIN,
  ROLE_VENDOR,
} from "../../constants/roles.js";

export const registerSchema = z.object({
  name: z
    .string()
    .trim()
    .min(1, "Name is required"),

  email: z
    .string()
    .trim()
    .email("Enter a valid email"),

  password: z
    .string()
    .min(6, "Password must be at least 6 characters"),

  roleId: z
    .array(
      z.enum([
        ROLE_CUSTOMER,
        ROLE_ADMIN,
        ROLE_VENDOR,
      ]),
    )
    .default([ROLE_CUSTOMER]),
});