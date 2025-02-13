import express from "express";
import {
  getAllRoles,
  createRole,
  updateRole,
  deleteRole,
  getRoleFeatures,
  updateRoleFeatures
} from "../controllers/roles.js";

const router = express.Router();

router.get("/", getAllRoles);
router.post("/", createRole);
router.put("/:id", updateRole);
router.delete("/:id", deleteRole);
router.get("/:roleId/features", getRoleFeatures);
router.put("/:roleId/features", updateRoleFeatures);

export default router;
