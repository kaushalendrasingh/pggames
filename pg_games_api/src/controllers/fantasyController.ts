import { Request, Response, RequestHandler } from "express";
import { FantasyMatch, FantasyTeam, Transaction } from "../models/ruleModel";
import Player from "../models/playerModel";
import User from "../models/userModel";
import Team from "../models/teamModel";

// List all fantasy matches
export const listFantasyMatches = async (
  req: Request,
  res: Response
): Promise<void> => {
  try {
    const matches = await FantasyMatch.find({ isActive: true });
    res.json(matches);
  } catch (error) {
    res.status(500).json({ message: "Server error", error });
  }
};

// List all players for a match (playing 11)
export const listPlayersForMatch = async (req: Request, res: Response) => {
  const { matchId } = req.params;
  try {
    // Assume matchId is the real match (from Team/Match)
    // You may need to adjust this logic based on your data model
    const players = await Player.find({ team: matchId });
    res.status(200).json(players);
  } catch (error) {
    res.status(500).json({ message: "Server error", error });
  }
};

// Get all players for both teams in a fantasy match
export const listPlayersForFantasyMatch: RequestHandler = async (req, res) => {
  const { fantasyMatchId } = req.params;
  try {
    const fantasyMatch = await FantasyMatch.findById(fantasyMatchId);
    if (!fantasyMatch) {
      res.status(404).json({ message: 'Fantasy match not found' });
      return;
    }
    const homeTeam = await Team.findById(fantasyMatch.matchId);
    if (!homeTeam) {
      res.status(404).json({ message: 'Home team not found' });
      return;
    }
    let opponentTeam = null;
    if (homeTeam.matches && homeTeam.matches[0] && homeTeam.matches[0].opponent) {
      opponentTeam = await Team.findOne({ name: homeTeam.matches[0].opponent });
    }
    const teamIds = [homeTeam._id];
    if (opponentTeam) teamIds.push(opponentTeam._id);
    const players = await Player.find({ team: { $in: teamIds } });
    res.status(200).json(players);
  } catch (error) {
    res.status(500).json({ message: 'Server error', error });
  }
};

// Join a fantasy match (pay 49 rupees)
export const joinFantasyMatch = async (
  req: Request,
  res: Response
): Promise<void> => {
  const { userId, fantasyMatchId } = req.body;
  try {
    // Check if already joined
    const existing = await FantasyTeam.findOne({
      user: userId,
      fantasyMatch: fantasyMatchId,
    });
    if (existing) {
      res.status(400).json({ message: "Already joined this match" });
    }
    // Create transaction
    const txn = new Transaction({
      user: userId,
      fantasyMatch: fantasyMatchId,
      amount: 49,
      status: "success",
    });
    await txn.save();
    res.status(200).json({ message: "Joined match. Now create your team." });
  } catch (error) {
    res.status(500).json({ message: "Server error", error });
  }
};

// Create or update fantasy team
export const createOrUpdateFantasyTeam = async (
  req: Request,
  res: Response
): Promise<void> => {
  const { userId, fantasyMatchId, players, captain, viceCaptain } = req.body;
  if (!players || players.length !== 11) {
    res.status(400).json({ message: "Select exactly 11 players" });
    return;
  }
  try {
    const fantasyMatch = await FantasyMatch.findById(fantasyMatchId);
    if (!fantasyMatch) {
      res.status(404).json({ message: "Fantasy match not found" });
      return;
    }
    // Check if match has started
    if (fantasyMatch.startTime && new Date() >= new Date(fantasyMatch.startTime)) {
      res.status(403).json({ message: "Cannot edit or create team after match has started." });
      return;
    }
    let team = await FantasyTeam.findOne({
      user: userId,
      fantasyMatch: fantasyMatchId,
    });
    if (team) {
      team.players = players;
      team.captain = captain;
      team.viceCaptain = viceCaptain;
      await team.save();
    } else {
      team = new FantasyTeam({
        user: userId,
        fantasyMatch: fantasyMatchId,
        players,
        captain,
        viceCaptain,
      });
      await team.save();
    }
    res.status(200).json({ message: "Team saved", team });
  } catch (error) {
    res.status(500).json({ message: "Server error", error });
  }
};

// Get all teams and their points for a fantasy match
export const getTeamsAndPoints = async (req: Request, res: Response) => {
  const { fantasyMatchId } = req.params;
  try {
    const teams = await FantasyTeam.find({ fantasyMatch: fantasyMatchId })
      .populate("user")
      .sort({ points: -1 });
    res.status(200).json(teams);
  } catch (error) {
    res.status(500).json({ message: "Server error", error });
  }
};

// Declare winners (admin only)
export const declareWinners = async (
  req: Request,
  res: Response
): Promise<void> => {
  const { fantasyMatchId, winnerUserIds } = req.body;
  try {
    const match = await FantasyMatch.findById(fantasyMatchId);
    if (!match) res.status(404).json({ message: "Fantasy match not found" });
    match.winners = winnerUserIds;
    match.isActive = false;
    await match.save();
    res.status(200).json({ message: "Winners declared", match });
  } catch (error) {
    res.status(500).json({ message: "Server error", error });
  }
};

// Get today's and upcoming matches
export const getTodayAndUpcomingMatches = async (req: Request, res: Response) => {
  try {
    const today = new Date();
    today.setHours(0, 0, 0, 0);
    // Find fantasy matches that are active and scheduled for today or later
    const matches = await FantasyMatch.find({ isActive: true })
      .populate({
        path: 'matchId',
        model: 'Team',
        select: 'name image matches',
      });
    // Filter by today's or future matches (assuming match date is in Team.matches[0].date)
    const filtered = await Promise.all(matches.filter((fm) => {
      const team = fm.matchId;
      if (!team || !team.matches || !team.matches[0]) return false;
      const matchDate = new Date(team.matches[0].date);
      return matchDate >= today;
    }).map(async (fm) => {
      const homeTeam = fm.matchId;
      let opponentTeam = null;
      if (homeTeam && homeTeam.matches && homeTeam.matches[0]) {
        opponentTeam = await Team.findOne({ name: homeTeam.matches[0].opponent });
      }
      return {
        ...fm.toObject(),
        homeTeam,
        opponentTeam,
      };
    }));
    res.status(200).json(filtered);
  } catch (error) {
    res.status(500).json({ message: 'Server error', error });
  }
};

// Get user's match history (matches user has joined)
export const getUserMatchHistory = async (req: Request, res: Response) => {
  const { userId } = req.params;
  try {
    const teams = await FantasyTeam.find({ user: userId })
      .populate({
        path: 'fantasyMatch',
        populate: { path: 'matchId', model: 'Team', select: 'name image matches' },
      })
      .sort({ createdAt: -1 });
    res.status(200).json(teams);
  } catch (error) {
    res.status(500).json({ message: 'Server error', error });
  }
}
