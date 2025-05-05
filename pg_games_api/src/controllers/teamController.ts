import { Request, Response } from 'express';
import Team from '../models/teamModel';
import Player from '../models/playerModel';

// Create a new team linked to a subcategory
export const createTeam = async (req: Request, res: Response): Promise<void> => {
  const { name, subcategoryId } = req.body;

  try {
    const existingTeam = await Team.findOne({ name });
    if (existingTeam) {
      res.status(400).json({ message: 'Team already exists' });
      return;
    }

    const newTeam = new Team({ name, matches: [], subcategory: subcategoryId });
    await newTeam.save();
    res.status(201).json({ message: 'Team created successfully', team: newTeam });
  } catch (error) {
    res.status(500).json({ message: 'Server error', error });
  }
};

// Add a match to a team
export const addMatch = async (req: Request, res: Response): Promise<void> => {
  const { teamId } = req.params;
  const { date, opponent, venue, result } = req.body;

  console.log('Adding match:', { teamId, date, opponent, venue, result });

  try {
    const team = await Team.findById(teamId);
    if (!team) {
      res.status(404).json({ message: 'Team not found' });
      return;
    }

    // Directly push the match object into the matches array
    team.matches.push({ date, opponent, venue, result });

    await team.save();
    res.status(200).json({ message: 'Match added successfully', team });
  } catch (error) {
    res.status(500).json({ message: 'Server error', error });
  }
};

// Get all teams
export const getAllTeams = async (req: Request, res: Response): Promise<void> => {
  try {
    const teams = await Team.find();
    res.status(200).json(teams);
  } catch (error) {
    res.status(500).json({ message: 'Server error', error });
  }
};

// Get a team by ID
export const getTeamById = async (req: Request, res: Response): Promise<void> => {
  const { teamId } = req.params;

  try {
    const team = await Team.findById(teamId);
    if (!team) {
      res.status(404).json({ message: 'Team not found' });
      return;
    }

    res.status(200).json(team);
  } catch (error) {
    res.status(500).json({ message: 'Server error', error });
  }
};

// Update a match
export const updateMatch = async (req: Request, res: Response): Promise<void> => {
  const { teamId, matchId } = req.params;
  const { date, opponent, venue, result } = req.body;

  try {
    const team = await Team.findById(teamId);
    if (!team) {
      res.status(404).json({ message: 'Team not found' });
      return;
    }

    // Use the _id property to find the match
    const match = team.matches.find((m: { id: { toString: () => string; }; }) => m.id && m.id.toString() === matchId);
    if (!match) {
      res.status(404).json({ message: 'Match not found' });
      return;
    }

    // Update the match fields
    match.date = date || match.date;
    match.opponent = opponent || match.opponent;
    match.venue = venue || match.venue;
    match.result = result || match.result;

    await team.save();
    res.status(200).json({ message: 'Match updated successfully', team });
  } catch (error) {
    res.status(500).json({ message: 'Server error', error });
  }
};

// Delete a match
export const deleteMatch = async (req: Request, res: Response): Promise<void> => {
  const { teamId, matchId } = req.params;

  try {
    const team = await Team.findById(teamId);
    if (!team) {
      res.status(404).json({ message: 'Team not found' });
      return;
    }

    // Find and remove the match by its _id
    const match = team.matches.find((m: { id: { toString: () => string; }; }) => m.id && m.id.toString() === matchId);
    if (!match) {
      res.status(404).json({ message: 'Match not found' });
      return;
    }

    team.matches = team.matches.filter((m: { id: { toString: () => string; }; }) => m.id && m.id.toString() !== matchId);
    await team.deleteOne();
    res.status(200).json({ message: 'Match deleted successfully', team });
  } catch (error) {
    res.status(500).json({ message: 'Server error', error });
  }
};

// Get match details by teamId and matchId
export const getMatchDetails = async (req: Request, res: Response): Promise<void> => {
  const { teamId, matchId } = req.params;

  try {
    const team = await Team.findById(teamId);
    if (!team) {
      res.status(404).json({ message: 'Team not found' });
      return;
    }

    // Use the id method to find the match by its _id
    const match = team.matches.find((m: { id: { toString: () => string; }; }) => m.id && m.id.toString() === matchId);
    if (!match) {
      res.status(404).json({ message: 'Match not found' });
      return;
    }

    res.status(200).json({
      message: 'Match details retrieved successfully',
      team: {
        id: team._id,
        name: team.name,
      },
      match,
    });
  } catch (error) {
    res.status(500).json({ message: 'Server error', error });
  }
};

// Add a player to a team
export const addPlayerToTeam = async (req: Request, res: Response): Promise<void> => {
  const { teamId } = req.params;
  const { name, role } = req.body;

  try {
    const team = await Team.findById(teamId);
    if (!team) {
      res.status(404).json({ message: 'Team not found' });
      return;
    }

    const newPlayer = new Player({ name, role, team: teamId });
    await newPlayer.save();

    team.players.push(newPlayer._id);
    await team.save();

    res.status(201).json({ message: 'Player added successfully', player: newPlayer });
  } catch (error) {
    res.status(500).json({ message: 'Server error', error });
  }
};