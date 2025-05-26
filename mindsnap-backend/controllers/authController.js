const User = require("../models/User");
const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");


exports.register = async (req, res) => {
    const { username, password, role = "user" } = req.body;
    try {
      const hashed = await bcrypt.hash(password, 10);
      const user = await User.create({ username, password: hashed, role });
      res.status(201).json({ message: "User registered" });
    } catch (err) {
      res.status(400).json({ error: "Registration failed" });
    }
  };
  

exports.login = async (req, res) => {
  const { username, password } = req.body;
  try {

    const token = jwt.sign(
        { userId: user._id, role: user.role },
        process.env.JWT_SECRET
      );
      
    const user = await User.findOne({ username });
    if (!user) return res.status(404).json({ error: "User not found" });

    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) return res.status(401).json({ error: "Invalid password" });

 
  } catch (err) {
    res.status(500).json({ error: "Login failed" });
  }
};
