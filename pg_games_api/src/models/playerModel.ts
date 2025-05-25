import mongoose, { Schema, Document } from 'mongoose';

export interface IPlayer extends Document {
  name: string;
  role: string; // e.g., Batsman, Bowler, Goalkeeper
  team: mongoose.Types.ObjectId; // Reference to the team
  image?: string; // URL or path to player image
}

const PlayerSchema: Schema = new Schema(
  {
    name: { type: String, required: true },
    role: { type: String, required: true },
    team: { type: mongoose.Schema.Types.ObjectId, ref: 'Team', required: true },
    image: { type: String }, // Player image URL
  },
  { timestamps: true } // Add created_at and updated_at fields
);

const Player = mongoose.models.Player || mongoose.model<IPlayer>('Player', PlayerSchema);

export default Player;