import { Request, Response } from 'express';
import Category from '../models/categoryModel';

// Create a new category
export const createCategory = async (req: Request, res: Response): Promise<void> => {
  const { name } = req.body;

  try {
    const existingCategory = await Category.findOne({ name });
    if (existingCategory) {
      res.status(400).json({ message: 'Category already exists' });
      return;
    }

    const newCategory = new Category({ name, subcategories: [] });
    await newCategory.save();
    res.status(201).json({ message: 'Category created successfully', category: newCategory });
  } catch (error) {
    res.status(500).json({ message: 'Server error', error });
  }
};

// Add a subcategory to a category
export const addSubcategory = async (req: Request, res: Response): Promise<void> => {
  const { categoryId } = req.params;
  const { name, year } = req.body;

  try {
    const category = await Category.findById(categoryId);
    if (!category) {
      res.status(404).json({ message: 'Category not found' });
      return;
    }

    category.subcategories.push({ name, year });
    await category.save();
    res.status(200).json({ message: 'Subcategory added successfully', category });
  } catch (error) {
    res.status(500).json({ message: 'Server error', error });
  }
};

// Get all categories
export const getAllCategories = async (req: Request, res: Response): Promise<void> => {
  try {
    const categories = await Category.find();
    res.status(200).json(categories);
  } catch (error) {
    res.status(500).json({ message: 'Server error', error });
  }
};