import express from "express";
import validate from "../middlewares/validator.js";
import authController from "../controllers/auth.controller.js";
import { registerSchema } from "../libs/schemas/auth.schema.js";

const router = express.Router();

router.post(
  "/register",
  validate(registerSchema),
  authController.register
);

router.post(
  "/login",
  authController.login
);

export default router;