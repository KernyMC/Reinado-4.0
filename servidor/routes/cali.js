import express from "express";
import { 
    getCali, 
    addCali, 
    getCalificacionCandidatas,
    updateDesempate,
    getDesempateNotas,
    getCandidatasEmpatadas,
    votarPublico,
    checkVotacionPublica,
    actualizarPuntajeFinal,
    cerrarVotaciones,
    getCandidatasParaVotacion,
    checkUserVoted
} from "../controllers/cali.js";

const router = express.Router();

router.get("/calificacion", getCali);
router.post("/", addCali);
router.get("/1", getCalificacionCandidatas);
router.post("/desempate", updateDesempate);
router.get("/desempate_notas", getDesempateNotas);
router.get('/verificar_empate', getCandidatasEmpatadas);
router.post("/votacionPublica", votarPublico);
router.get("/checkVotacionPublica", checkVotacionPublica);
router.put("/actualizarPuntajeFinal", actualizarPuntajeFinal);
router.put("/cerrarVotaciones", cerrarVotaciones);
router.get("/candidatasVotacion", getCandidatasParaVotacion);
router.get("/checkUserVoted/:userId", checkUserVoted);

export default router;