import mongoose, { Schema, Document } from 'mongoose';

export interface IRule extends Document {
  category: mongoose.Types.ObjectId; // Reference to the category
  subcategory?: mongoose.Types.ObjectId; // Optional reference to the subcategory
  rule: string; // Rule description
  value: number; // Rule value (e.g., number of players)
}

const RuleSchema: Schema = new Schema(
  {
    category: { type: mongoose.Schema.Types.ObjectId, ref: 'Category', required: true },
    subcategory: { type: mongoose.Schema.Types.ObjectId, ref: 'Category.subcategories', required: false },
    rule: { type: String, required: true },
    value: { type: Number, required: true },
  },
  { timestamps: true }
);

const Rule = mongoose.models.Rule || mongoose.model<IRule>('Rule', RuleSchema);

export default Rule;

// Fantasy Match Model
export interface IFantasyMatch extends Document {
  matchId: mongoose.Types.ObjectId; // Reference to the real match (from Team/Match)
  entryFee: number;
  isActive: boolean;
  winners: mongoose.Types.ObjectId[]; // User IDs
  startTime: Date; // New field for match start time
}

const FantasyMatchSchema: Schema = new Schema(
  {
    matchId: { type: mongoose.Schema.Types.ObjectId, required: true },
    entryFee: { type: Number, default: 49 },
    isActive: { type: Boolean, default: true },
    winners: [{ type: mongoose.Schema.Types.ObjectId, ref: 'User' }],
    startTime: { type: Date, required: true }, // New field
  },
  { timestamps: true }
);

export const FantasyMatch = mongoose.models.FantasyMatch || mongoose.model<IFantasyMatch>('FantasyMatch', FantasyMatchSchema);

// Fantasy Team Model
export interface IFantasyTeam extends Document {
  user: mongoose.Types.ObjectId;
  fantasyMatch: mongoose.Types.ObjectId;
  players: mongoose.Types.ObjectId[]; // 11 players
  captain: mongoose.Types.ObjectId;
  viceCaptain: mongoose.Types.ObjectId;
  points: number;
}

const FantasyTeamSchema: Schema = new Schema(
  {
    user: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
    fantasyMatch: { type: mongoose.Schema.Types.ObjectId, ref: 'FantasyMatch', required: true },
    players: [{ type: mongoose.Schema.Types.ObjectId, ref: 'Player', required: true }],
    captain: { type: mongoose.Schema.Types.ObjectId, ref: 'Player', required: true },
    viceCaptain: { type: mongoose.Schema.Types.ObjectId, ref: 'Player', required: true },
    points: { type: Number, default: 0 },
  },
  { timestamps: true }
);

export const FantasyTeam = mongoose.models.FantasyTeam || mongoose.model<IFantasyTeam>('FantasyTeam', FantasyTeamSchema);

// Transaction Model
export interface ITransaction extends Document {
  user: mongoose.Types.ObjectId;
  fantasyMatch: mongoose.Types.ObjectId;
  amount: number;
  status: string; // 'success', 'failed'
}

const TransactionSchema: Schema = new Schema(
  {
    user: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
    fantasyMatch: { type: mongoose.Schema.Types.ObjectId, ref: 'FantasyMatch', required: true },
    amount: { type: Number, required: true },
    status: { type: String, enum: ['success', 'failed'], default: 'success' },
  },
  { timestamps: true }
);

export const Transaction = mongoose.models.Transaction || mongoose.model<ITransaction>('Transaction', TransactionSchema);