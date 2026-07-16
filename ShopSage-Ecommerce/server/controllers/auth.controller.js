import authService from "../services/auth.service.js";

const register = async (req, res) => {
  try {
    const { name, email, password } = req.body;

    const result = await authService.register({
      name,
      email,
      password,
      role: ["CUSTOMER"],
    });

    return res.status(201).json({
      message: "User registered successfully",
      data: result,
    });
  } catch (err) {
    console.log("REGISTER ERROR:", err);

    return res.status(400).json({
      message: err.message,
    });
  }
};

const login = async (req, res) => {
  try {
    const { email, password } = req.body;

    const result = await authService.login({
      email,
      password,
    });

    return res.status(200).json({
      message: "Login successful",
      data: result,
    });
  } catch (err) {
    console.log("LOGIN ERROR:", err);

    return res.status(401).json({
      message: err.message,
    });
  }
};

export default {
  register,
  login,
};