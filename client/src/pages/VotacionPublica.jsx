import React, { useState, useEffect, useContext } from "react";
import Axios from "axios";
import { API_BASE_URL } from "./ip.js";
import { AuthContext } from "../context/authContext";
import Navbar from "../components/Navbar";
import Espera from "../components/Espera";

const VotacionPublica = () => {
  const { currentUser } = useContext(AuthContext);
  const [candidatas, setCandidatas] = useState([]);
  const [seleccionada, setSeleccionada] = useState(null);
  const [mensaje, setMensaje] = useState("");
  const [error, setError] = useState("");
  const [pop, setPop] = useState(false);

  const cortarParteDerecha = (cadena) => {
    if (!cadena) return ''; // Protección contra undefined
    let parteDerecha = '';
    let i = cadena.length - 1;

    while (i >= 0 && cadena[i] !== '\\') {
      parteDerecha = cadena[i] + parteDerecha;
      i--;
    }

    return parteDerecha;
  }

  useEffect(() => {
    const fetchCandidatas = async () => {
      try {
        const res = await Axios.get(`${API_BASE_URL}/candidatas`);
        setCandidatas(res.data);
      } catch (err) {
        console.error(err);
      }
    };
    fetchCandidatas();
  }, []);

  const enviarVoto = async () => {
    if (!seleccionada) {
      setError("Debes seleccionar una candidata antes de enviar.");
      return;
    }

    try {
      await Axios.post(`${API_BASE_URL}/cali/votarPublico`, {
        usuarioId: currentUser.id,
        candidataId: seleccionada,
      });
      setMensaje("Voto registrado exitosamente.");
      setError("");
      setPop(true);
    } catch (err) {
      console.error(err);
      setError("Hubo un error al registrar tu voto. Intenta nuevamente.");
    }
  };

  if (!currentUser || currentUser.rol !== "usuario") {
    return (
      <div className="App">
        <h1>No tienes permiso para acceder a esta página.</h1>
      </div>
    );
  }

  return (
    <>
      <Navbar texto="Votación Pública" />
      {pop === true && <Espera />}
      <div className="VotacionPublica">
        <h1>Votación Pública</h1>

        <div >
        <div className="candidatas-container">
          {candidatas.map((candidata) => (
            <div
              key={candidata.CANDIDATA_ID}
              className={`candidata-card ${seleccionada === candidata.CANDIDATA_ID ? "seleccionada" : ""}`}
              onClick={() => setSeleccionada(candidata.CANDIDATA_ID)}
            >
              <img 
                src={`/reinas/${cortarParteDerecha(candidata.FOTO_URL)}`} 
                alt={candidata.CAND_NOMBRE1}
                width="350px"
              />
              <h3>
                {candidata.CAND_NOMBRE1} {candidata.CAND_APELLIDOPATERNO}
              </h3>
            </div>
          ))}
        </div>
        </div>
        <button className="btn-enviar" onClick={enviarVoto}>
          Enviar Voto
        </button>
        {mensaje && <p className="success-message">{mensaje}</p>}
        {error && <p className="error-message">{error}</p>}
      </div>
    </>
  );
};

export default VotacionPublica;