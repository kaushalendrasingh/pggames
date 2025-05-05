import { Request, Response } from "express";
import { FantasyMatch, FantasyTeam, Transaction } from "../models/ruleModel";
import Player from "../models/playerModel";
import User from "../models/userModel";

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
  }
  try {
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
