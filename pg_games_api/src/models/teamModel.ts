import mongoose, { Schema, Document } from 'mongoose';

export interface IMatch {
  date: string;
  opponent: string;
  venue: string;
  result?: string;
}

export interface ITeam extends Document {
  name: string;
  matches: IMatch[];
  subcategory: mongoose.Types.ObjectId;
  players: mongoose.Types.ObjectId[]; // Array of player IDs
  image?: string; // URL or path to team logo
}

const MatchSchema: Schema = new Schema(
  {
    date: { type: String, required: true },
    opponent: { type: String, required: true },
    venue: { type: String, required: true },
    result: { type: String, enum: ['Win', 'Loss', 'Draw', 'null'], default: null },
  },
  { timestamps: true }
);

const TeamSchema: Schema = new Schema(
  {
    name: { type: String, required: true, unique: true },
    matches: [MatchSchema],
    subcategory: { type: mongoose.Schema.Types.ObjectId, ref: 'Category.subcategories', required: true },
    players: [{ type: mongoose.Schema.Types.ObjectId, ref: 'Player' }], // Reference to players
    image: { type: String }, // Team logo URL
  },
  { timestamps: true }
);

const Team = mongoose.models.Team || mongoose.model<ITeam>('Team', TeamSchema);

export default Team;
