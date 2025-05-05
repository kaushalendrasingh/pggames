import express from 'express';
import {
  listFantasyMatches,
  listPlayersForMatch,
  joinFantasyMatch,
  createOrUpdateFantasyTeam,
  getTeamsAndPoints,
  declareWinners,
} from '../controllers/fantasyController';

const router = express.Router();

// List all fantasy matches
router.get('/matches', listFantasyMatches);

// List all players for a match
router.get('/players/:matchId', listPlayersForMatch);

// Join a fantasy match
router.post('/join', joinFantasyMatch);

// Create or update fantasy team
router.post('/team', createOrUpdateFantasyTeam);

// Get all teams and their points
router.get('/teams/:fantasyMatchId', getTeamsAndPoints);

// Declare winners (admin)
router.post('/declare-winners', declareWinners);

export default router;
