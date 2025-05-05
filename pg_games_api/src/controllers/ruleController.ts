import { Request, Response } from 'express';
import Rule from '../models/ruleModel';

export const addRule = async (req: Request, res: Response): Promise<void> => {
  const { categoryId, subcategoryId, rule, value } = req.body;

  try {
    const newRule = new Rule({
      category: categoryId,
      subcategory: subcategoryId || null,
      rule,
      value,
    });

    await newRule.save();
    res.status(201).json({ message: 'Rule added successfully', rule: newRule });
  } catch (error) {
    res.status(500).json({ message: 'Server error', error });
  }
};