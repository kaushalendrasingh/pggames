import mongoose, { Schema, Document } from 'mongoose';

export interface ISubcategory extends Document {
  name: string;
  year?: number; // Optional: For tournaments like IPL2025
}

export interface ICategory extends Document {
  name: string;
  subcategories: ISubcategory[];
}

const CategorySchema: Schema = new Schema(
  {
    name: { type: String, required: true, unique: true },
    subcategories: [
      new Schema(
        {
          name: { type: String, required: true },
          year: { type: Number, required: false },
        },
        { timestamps: true }
      ),
    ],
  },
  { timestamps: true }
);

// Check if the model already exists before defining it
const Category = mongoose.models.Category || mongoose.model<ICategory>('Category', CategorySchema);

export default Category;
