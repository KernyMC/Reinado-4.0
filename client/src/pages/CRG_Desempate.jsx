import React, { useEffect, useState, useContext } from "react";
import { useNavigate } from "react-router-dom";
import { AuthContext } from "../context/authContext";
import Axios from "axios";
import { API_BASE_URL } from "./ip";

const CRG_Desempate = () => {
  const [eventoActivo, setEventoActivo] = useState(false);
  const { currentUser } = useContext(AuthContext);
  const navigate = useNavigate();

  useEffect(() => {
    const verificarEstado = async () => {
      try {
        const res = await Axios.get(`${API_BASE_URL}/evento/estado`);
        setEventoActivo(res.data[5]); // Evento 5 es desempate
      } catch (err) {
        console.error("Error al verificar estado:", err);
      }
    };

    verificarEstado();
    const interval = setInterval(verificarEstado, 5000);
    return () => clearInterval(interval);
  }, []);

  const handleIniciarVotacion = () => {
    navigate("/Desempate");
  };

  if (!currentUser || currentUser.rol !== "juez") {
    return <div>No tienes permiso para ver esta página</div>;
  }

  return (
    <div className="crg-desempate-container">
      <h1>Votación de Desempate</h1>
      {eventoActivo ? (
        <button 
          className="btn-iniciar-votacion"
          onClick={handleIniciarVotacion}
        >
          Iniciar Votación
        </button>
      ) : (
        <p>Esperando que el administrador active el evento...</p>
      )}
    </div>
  );
};

export default CRG_Desempate; 