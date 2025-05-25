import { Request, Response } from "express";
import bcrypt from "bcryptjs";
import jwt from "jsonwebtoken";
import User, { IUser } from "../models/userModel";

// Register a new user
export const registerUser = async (
  req: Request,
  res: Response
): Promise<void> => {
  const { username, email, password, first_name, last_name } = req.body;

  try {
    // Check if the user already exists
    const existingUser = await User.findOne({ email });
    if (existingUser) {
      res.status(400).json({ message: "User already exists" });
      return;
    }

    // Hash the password
    const hashedPassword = await bcrypt.hash(password, 10);

    // Create a new user
    const newUser: IUser = new User({
      username,
      email,
      password: hashedPassword,
      first_name,
      last_name,
      withdrawable: 0,
      nonWithdrawable: 100,
    });

    await newUser.save();

    // Generate a JWT token for the new user
    const token = jwt.sign(
      { id: newUser._id, userName: newUser.username, email: newUser.email },
      process.env.JWT_SECRET || "secret",
      {
        expiresIn: "48h",
      }
    );

    res.status(201).json({ message: "User registered successfully", token });
  } catch (error) {
    res.status(500).json({ message: "Server error", error });
  }
};

// Login a user
export const loginUser = async (req: Request, res: Response): Promise<void> => {
  const { email, password } = req.body;

  try {
    // Check if the user exists
    const user = await User.findOne({ email });
    if (!user) {
      res.status(400).json({ message: "Invalid email or password" });
      return;
    }

    // Compare the password
    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) {
      res.status(400).json({ message: "Invalid email or password" });
      return;
    }

    // Generate a JWT token
    const token = jwt.sign(
      { id: user._id, userName: user.username, email: user.email },
      process.env.JWT_SECRET || "secret",
      {
        expiresIn: "48h",
      }
    );

    res.status(200).json({ message: "Login successful", token });
  } catch (error) {
    res.status(500).json({ message: "Server error", error });
  }
};

// Get user wallet info
export const getUserWallet = async (req: Request, res: Response): Promise<void> => {
  const userId = req.params.userId;
  try {
    const user = await User.findById(userId);
    if (!user) {
      res.status(404).json({ message: 'User not found' });
      return;
    }
    res.status(200).json({
      withdrawable: user.withdrawable,
      nonWithdrawable: user.nonWithdrawable,
      total: user.withdrawable + user.nonWithdrawable,
    });
  } catch (error) {
    res.status(500).json({ message: 'Server error', error });
  }
};

// Get user profile
export const getUserProfile = async (req: Request, res: Response) => {
  const { userId } = req.params;
  try {
    const user = await User.findById(userId);
    if (!user) {
      res.status(404).json({ message: 'User not found' });
      return;
    }
    res.status(200).json({
      username: user.username,
      email: user.email,
    });
  } catch (error) {
    res.status(500).json({ message: 'Server error', error });
  }
};
