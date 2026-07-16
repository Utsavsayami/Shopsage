import authService from "../services/auth.service.js";

const register = async (req, res) => {
  try {
    const { name, email, password, roleId } = req.body;

    const result = await authService.register({
      name,
      email,
      password,
      role: roleId,
    });

    return res.status(201).json({
      message: "User registered successfully",
      data: result,
    });
  } catch (err) {
    return res.status(400).json({
      message: err.message,
    });
  }
};

const login = async (req, res) => {
  try {
    const result = await authService.login(req.body);
    return res.status(200).json({ message: "Login successful", data: result });
  } catch (err) {
    return res.status(401).json({ message: err.message });
  }
};

const forgotPassword = async (req, res) => {
  try {
    const result = await authService.forgotPassword(req.body.email);
    return res.status(200).json(result);
  } catch (err) {
    return res.status(400).json({ message: err.message });
  }
};

export default { register, login, forgotPassword };
