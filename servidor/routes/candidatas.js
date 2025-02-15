// candidatas.js
import express from "express";
import { 
    getCandidatas, 
    getCandidatasFotos, 
    getCandidatasTrajeTipico, 
    getJueces, 
    getVotacionesNotario, 
    getCandidatasTrajeGala, 
    getCandidatasBarra, 
    getCandidataCarrusel, 
    getTopCandidatas,
    createCandidata,
    updateCandidata,
    deleteCandidata,
    getAllCandidatas,
    getAllCarreras,
    verificarEvento,
    verificarEstadoGlobal,
    verificarDesempateCompleto,
    verificarEmpate,
    submitVotacionPublica,
    contabilizarVotosPublicos,
    getVistaPuntuaciones
} from "../controllers/candidatas.js";

const router = express.Router();

// Ruta que faltaba para el panel admin
router.get("/", getCandidatas);

// Rutas específicas primero
router.get("/carruselCandidatas", getCandidataCarrusel);
router.get("/jueces", getJueces);
router.get("/votaciones", getVotacionesNotario);
router.get("/tt", getCandidatasTrajeTipico);
router.get("/tg", getCandidatasTrajeGala);
router.get("/topCandidatas", getTopCandidatas);
router.get("/vistaPuntuaciones", getVistaPuntuaciones);
router.get("/carreras", getAllCarreras);
router.get("/all", getAllCandidatas);
router.get("/verificar-evento/:eventoId", verificarEvento);
router.get("/estado-global", verificarEstadoGlobal);
router.get("/verificar-desempate", verificarDesempateCompleto);
router.get("/verificar-empate", verificarEmpate);

// Rutas con parámetros después
router.get("/:id", getCandidatasFotos);

//obtener candidatas
// POST -> create
router.post("/", createCandidata);
router.put("/:id", updateCandidata);
router.delete("/:id", deleteCandidata);

router.post("/votacion-publica", submitVotacionPublica);
router.post("/contabilizar-votos", contabilizarVotosPublicos);

export default router;
