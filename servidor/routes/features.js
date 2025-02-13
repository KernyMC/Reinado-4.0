import express from "express";
import {
  getFeatures,
  createFeature,
  updateFeature,
  deleteFeature,
} from "../controllers/features.js";

const router = express.Router();

router.get("/", getFeatures);
router.post("/", createFeature);
router.put("/:id", updateFeature);
router.delete("/:id", deleteFeature);

export default router;
