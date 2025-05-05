import { Router } from 'express';
import {
  createTeam,
  addMatch,
  getAllTeams,
  getTeamById,
  updateMatch,
  deleteMatch,
  getMatchDetails, // Import the new controller function
  addPlayerToTeam, // Import the new controller function
} from '../controllers/teamController';

const router = Router();

// Team routes
router.post('/', createTeam);
router.get('/', getAllTeams);
router.get('/:teamId', getTeamById);

// Match routes
router.post('/:teamId/matches', addMatch);
router.put('/:teamId/matches/:matchId', updateMatch);
router.delete('/:teamId/matches/:matchId', deleteMatch);
router.get('/:teamId/matches/:matchId', getMatchDetails); // Add the new route

// Player routes
router.post('/:teamId/players', addPlayerToTeam);

export default router;