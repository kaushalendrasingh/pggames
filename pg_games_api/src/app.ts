import express, { Application, Request, Response } from 'express';
import dotenv from 'dotenv';
import authRoutes from './routes/authRoutes';
import teamRoutes from './routes/teamRoutes';
import categoryRoutes from './routes/categoryRoutes';
import fantasyRoutes from './routes/fantasyRoutes';
import connectDB from './utils/db';

dotenv.config();

const app: Application = express();
const PORT = process.env.PORT || 3000;

// Connect to the database
connectDB();

// Middleware
app.use(express.json());

app.use('/api/auth', authRoutes);
app.use('/api/teams', teamRoutes);
app.use('/api/categories', categoryRoutes);
app.use('/api/fantasy', fantasyRoutes);

// Test API
app.get('/api/test', (req: Request, res: Response) => {
  res.send('API is working!');
});

// Start server
app.listen(PORT, () => {
  console.log(`Server is running on http://localhost:${PORT}`);
});