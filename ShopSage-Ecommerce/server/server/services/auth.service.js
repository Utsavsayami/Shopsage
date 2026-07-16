import bcrypt from "bcrypt";
import jwt from "jsonwebtoken";
import User from "../models/User.js";

const generateAccessToken = (user) => jwt.sign(
  { id: user._id, email: user.email, role: user.role },
  process.env.JWT_SECRET,
  { expiresIn: process.env.JWT_EXPIRES_IN || "15m" },
);

const generateRefreshToken = (user) => jwt.sign(
  { id: user._id },
  process.env.JWT_REFRESH_SECRET,
  { expiresIn: process.env.JWT_REFRESH_EXPIRES_IN || "7d" },
);

const register = async ({ name, email, password, role }) => {
  const existingUser = await User.findOne({ email });
  if (existingUser) throw new Error("Email already in use");
  const user = await User.create({
    name,
    email,
    password: await bcrypt.hash(password, 10),
    role: role?.length ? role : ["CUSTOMER"],
  });
  return {
    accessToken: generateAccessToken(user),
    refreshToken: generateRefreshToken(user),
    user: { id: user._id, name: user.name, email: user.email, role: user.role },
  };
};

const login = async ({ email, password }) => {
  const user = await User.findOne({ email });
  if (!user || !(await bcrypt.compare(password, user.password))) {
    throw new Error("Invalid email or password");
  }
  return {
    accessToken: generateAccessToken(user),
    refreshToken: generateRefreshToken(user),
    user: { id: user._id, name: user.name, email: user.email, role: user.role },
  };
};

const forgotPassword = async (email) => {
  if (!email) throw new Error("Email is required");
  // Safe generic response. Add Nodemailer/OTP here when backend email settings exist.
  await User.findOne({ email: email.toLowerCase() });
  return { message: "If this email exists, password reset instructions will be sent." };
};

export default { register, login, forgotPassword };
