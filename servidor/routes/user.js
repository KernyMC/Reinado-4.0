import express from "express";
import { 
  getUsuarios,
  getUserById,
  createUser,
  updateUser,
  deleteUser,
  actualizarActivo,
  actualizarEstadoEvento,
  limpiarTabla,
  limpiarVotaciones,
  checkVotes1,
  checkVotes2,
  checkVotes3,
  activarEventoPublico,
  getUsersWithFeatures,
  updateUserFeatures,
  cambioDesempate,
  checkDesempate,
  cerrarVotacionPublica
} from "../controllers/user.js";

const router = express.Router();

// Rutas específicas primero (sin parámetros)
router.get("/with-features", getUsersWithFeatures);
router.get("/ck1", checkVotes1);
router.get("/ck2", checkVotes2);
router.get("/ck3", checkVotes3);
router.post("/limpiarTabla", limpiarTabla);
router.post("/limpiarVotaciones", limpiarVotaciones);
router.put("/activarEventoPublico", activarEventoPublico);
router.put("/cambio/:estado/:idEvento", actualizarEstadoEvento);
router.put("/:userId/features", updateUserFeatures);
router.put("/cambio-desempate/:estado", cambioDesempate);
router.get("/check-desempate", checkDesempate);
router.put("/cerrar-votacion-publica", cerrarVotacionPublica);

// Rutas CRUD
router.get("/", getUsuarios);
router.post("/", createUser);
router.get("/:id", getUserById);
router.put("/:id", updateUser);
router.delete("/:id", deleteUser);
router.put("/:username", actualizarActivo);

export default router;