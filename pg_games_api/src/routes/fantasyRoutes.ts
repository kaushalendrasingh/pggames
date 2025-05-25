import express from 'express';
import {
  listFantasyMatches,
  listPlayersForMatch,
  joinFantasyMatch,
  createOrUpdateFantasyTeam,
  getTeamsAndPoints,
  declareWinners,
  getTodayAndUpcomingMatches,
  getUserMatchHistory,
  listPlayersForFantasyMatch,
} from '../controllers/fantasyController';

const router = express.Router();

// List all fantasy matches
router.get('/matches', listFantasyMatches);

// Get today's and upcoming matches
router.get('/matches/today', getTodayAndUpcomingMatches);

// List all players for a match
router.get('/players/:matchId', listPlayersForMatch);

// Join a fantasy match
router.post('/join', joinFantasyMatch);

// Create or update fantasy team
router.post('/team', createOrUpdateFantasyTeam);

// Get all teams and their points
router.get('/teams/:fantasyMatchId', getTeamsAndPoints);

// Get user's match history
router.get('/my-matches/:userId', getUserMatchHistory);

// Declare winners (admin)
router.post('/declare-winners', declareWinners);

// List players for a fantasy match
router.get('/players-for-fantasy-match/:fantasyMatchId', listPlayersForFantasyMatch);

export default router;
