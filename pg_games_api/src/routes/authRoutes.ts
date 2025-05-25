import { Router } from 'express';
import { registerUser, loginUser, getUserWallet, getUserProfile } from '../controllers/authController';

const router = Router();

// Register route
router.post('/register', registerUser);

// Login route
router.post('/login', loginUser);

// Wallet route
router.get('/wallet/:userId', getUserWallet);

// Profile route
router.get('/profile/:userId', getUserProfile);

export default router; // Ensure this export is present