import { Router } from 'express';
import { addRule } from '../controllers/ruleController';

const router = Router();

router.post('/', addRule);

export default router;