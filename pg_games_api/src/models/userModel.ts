import mongoose, { Schema, Document } from 'mongoose';

export interface IUser extends Document {
  username: string;
  email: string;
  password: string;
  first_name: string;
  last_name?: string;
  withdrawable: number;
  nonWithdrawable: number;
}

const UserSchema: Schema = new Schema({
  username: { type: String, required: true, unique: true },
  email: { type: String, required: true, unique: true },
  password: { type: String, required: true },
  withdrawable: { type: Number, default: 0 },
  nonWithdrawable: { type: Number, default: 100 },
});

const User = mongoose.model<IUser>('User', UserSchema);

export default User;