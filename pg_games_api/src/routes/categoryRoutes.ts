import { Router } from 'express';
import { createCategory, addSubcategory, getAllCategories } from '../controllers/categoryController';

const router = Router();

// Category routes
router.post('/', createCategory);
router.post('/:categoryId/subcategories', addSubcategory);
router.get('/', getAllCategories);

export default router;