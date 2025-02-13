import React, { useEffect, useState, useContext } from "react";
import { Link, useNavigate } from "react-router-dom";
import Popup from "reactjs-popup";
import Axios from "axios";
import { AuthContext } from "../context/authContext";
import { API_BASE_URL } from "./ip"; // Ajusta según tu estructura
import Navbar from "../components/Navbar";
import Stack from '@mui/material/Stack';
import Button from '@mui/material/Button';

const PanelAdmin = () => {
  const { currentUser } = useContext(AuthContext);
  const navigate = useNavigate();

  // Listas y estados
  const [listaReinas, setListaReinas] = useState([]);
  const [listaJueces, setListaJueces] = useState([]);
  const [votaciones, setVotaciones] = useState([]);
  const [showDesempateError, setShowDesempateError] = useState(false);

  // Manejo de popups
  const [mostrarPopUp, setMostrarPopUp] = useState(false);       // PopUp para REINICIAR Votaciones
  const [popUpCerrarFinal, setPopUpCerrarFinal] = useState(false); // PopUp para CERRAR Y Generar Reporte

  const [estadoEventos, setEstadoEventos] = useState({
    1: false, // Traje Típico
    2: false, // Traje Gala
    3: false, // Preguntas
    4: false, // Votación Pública
    5: false  // Desempate
  });

  const [estadoDesempate, setEstadoDesempate] = useState("no");

  // --- Funciones "helper" para pintar celdas en la tabla ---
  const getVotacionClass = (candidataId, userId, eventId) => {
    // Buscar si existe una calificación para esta combinación
    const votacion = votaciones.find(v => 
        v.CANDIDATA_ID === candidataId && 
        v.USUARIO_ID === userId && 
        v.EVENTO_ID === eventId
    );

    // Si existe votación y su estado es 'si', retornar verde
    return votacion ? "celda-verde" : "celda-roja";
  };

  const getVotacionTexto = (candidataId, userId, eventId) => {
    const votacion = votaciones.find(v => 
        v.CANDIDATA_ID === candidataId && 
        v.USUARIO_ID === userId && 
        v.EVENTO_ID === eventId
    );
    
    return votacion ? "Votado" : "Pendiente";
  };
  // --- Fin funciones helper ---

  // 1) Obtener candidatas
  const fetchCandidatas = async () => {
    try {
      const res = await Axios.get(`${API_BASE_URL}/candidatas`);
      setListaReinas(res.data);
    } catch (err) {
      console.log(err);
    }
  };

  // 2) Obtener jueces
  const fetchJueces = async () => {
    try {
      const res = await Axios.get(`${API_BASE_URL}/candidatas/jueces`);
      setListaJueces(res.data);
    } catch (err) {
      console.log(err);
    }
  };

  // 3) Obtener votaciones
  const fetchVotaciones = async () => {
    try {
      const res = await Axios.get(`${API_BASE_URL}/candidatas/votaciones`, {
        withCredentials: true
      });
      console.log("Votaciones recibidas:", res.data); // Para debugging
      setVotaciones(res.data);
    } catch (err) {
      console.error("Error obteniendo votaciones:", err);
    }
  };

  // 4) Cambiar estado de evento (ej. "si"/"no") para un evento puntual
  const cambiarEvento = async (idEvento, estado) => {
    try {
      // Ajusta la ruta si tu backend es distinta
      await Axios.put(`/user/cambio/${estado}/${idEvento}`);
    } catch (err) {
      console.log(err);
    }
  };

  // 5) Limpiar votaciones
  const limpiarVotaciones = async () => {
    try {
      await Axios.post(`/user/limpiarVotaciones`);
    } catch (err) {
      console.log(err);
    }
  };

  // --- PopUp para Reiniciar Votaciones ---
  const handleModalClose = () => {
    setMostrarPopUp(false);
  };

  const handleClickReiniciar = () => {
    setMostrarPopUp(false);
    limpiarVotaciones();
  };

  // === Cerrar TODOS los eventos (eventoId: 1,2,3,4) ===
  const cerrarVotacionGlobal = async () => {
    try {
      // PUT /api/evento/cerrarTodo (ajusta si tu endpoint es distinto)
      await Axios.put(`${API_BASE_URL}/evento/cerrarTodo`);
      console.log("Todos los eventos han sido cerrados (EVENTO_ESTADO = 'no').");
    } catch (err) {
      console.log(err);
    }
  };

  // 6) Actualizar Puntaje Final
  const actualizarPuntajeFinal = async () => {
    try {
      await Axios.put(`${API_BASE_URL}/evento/actualizarPuntajeFinal`);
      console.log("Puntaje final de candidatas actualizado correctamente.");
    } catch (err) {
      console.log(err);
    }
  };

  // Manejo PopUp para "Cerrar y Generar Reporte"
  const handleGenerarReporte = async () => {
    try {
      // 1) Cerrar votaciones (todos los eventos)
      await Axios.put(`${API_BASE_URL}/cali/cerrarVotaciones`);
      console.log("Todos los eventos han sido cerrados (EVENTO_ESTADO = 'no').");
  
      // 2) Actualizar PUNTAJE FINAL
      await Axios.put(`${API_BASE_URL}/cali/actualizarPuntajeFinal`);
      console.log("Puntaje final de candidatas actualizado correctamente.");
  
      // 3) Cerrar popup
      setPopUpCerrarFinal(false);
  
      // 4) Redirigir a /reporte
      navigate("/reporte");
    } catch (err) {
      console.log(err);
    }
  };

  const handleDesempate = async (estado) => {
    try {
      await Axios.put(`${API_BASE_URL}/user/cambio-desempate/${estado}`);
      setEstadoDesempate(estado);
    } catch (error) {
      console.error("Error cambiando estado de desempate:", error);
    }
  };

  // Función para obtener estado de eventos
  const fetchEstadoEventos = async () => {
    try {
      const res = await Axios.get(`${API_BASE_URL}/evento/estado`);
      setEstadoEventos(res.data);
    } catch (err) {
      console.error("Error al obtener estado de eventos:", err);
    }
  };

  // --- Efectos (componentDidMount & actualización en tiempo real) ---
  useEffect(() => {
    const fetchData = async () => {
      try {
        // Obtener candidatas
        const resCandidatas = await Axios.get(`${API_BASE_URL}/candidatas`);
        setListaReinas(resCandidatas.data);

        // Obtener jueces
        const resJueces = await Axios.get(`${API_BASE_URL}/candidatas/jueces`);
        setListaJueces(resJueces.data);

        // Obtener votaciones
        const resVotaciones = await Axios.get(`${API_BASE_URL}/candidatas/votaciones`);
        setVotaciones(resVotaciones.data);
      } catch (err) {
        console.error("Error obteniendo datos:", err);
      }
    };

    fetchData();
    const interval = setInterval(fetchData, 5000); // Actualizar cada 5 segundos

    return () => clearInterval(interval);
  }, []);

  useEffect(() => {
    const verificarEstadoDesempate = async () => {
      try {
        const response = await Axios.get(`${API_BASE_URL}/user/check-desempate`);
        setEstadoDesempate(response.data.EVENTO_ESTADO);
      } catch (error) {
        console.error("Error verificando estado de desempate:", error);
      }
    };
    verificarEstadoDesempate();
  }, []);

  // Verificación de permisos
  if (!currentUser || currentUser.rol !== "admin") {
    return (
      <div>
        <h1>Lo sentimos, no tienes permiso para ver esta página.</h1>
      </div>
    );
  } else {
    return (
      <>
        
        <div className="panel-admin-container">
          <main>
            <br />
            <h1 className="reporte">Panel de Administración</h1>
            <h2>Eventos</h2>

            <p>Evento 1 (Traje Típico):</p>
            <div>
              <button className="btn" onClick={() => cambiarEvento(1, "si")}>
                Empezar
              </button>
              <button className="btn" onClick={() => cambiarEvento(1, "no")}>
                Cerrar
              </button>
            </div>

            <p>Evento 2 (Traje Gala):</p>
            <div>
              <button className="btn" onClick={() => cambiarEvento(2, "si")}>
                Empezar
              </button>
              <button className="btn" onClick={() => cambiarEvento(2, "no")}>
                Cerrar
              </button>
            </div>

            <p>Evento 3 (Preguntas):</p>
            <div>
              <button className="btn" onClick={() => cambiarEvento(3, "si")}>
                Empezar
              </button>
              <button className="btn" onClick={() => cambiarEvento(3, "no")}>
                Cerrar
              </button>
            </div>

            <p>Evento 4 (Publico):</p>
            <div>
              <button className="btn" onClick={() => cambiarEvento(4, "si")}>
                Empezar
              </button>
              <button className="btn" onClick={() => cambiarEvento(4, "no")}>
                Cerrar
              </button>
            </div>



            {showDesempateError && (
              <div className="error-message">
                No hay empate entre candidatas para activar el desempate
              </div>
            )}

            <h2>Votaciones</h2>
            <div>
              <button className="btn" onClick={() => setMostrarPopUp(true)}>
                Reiniciar Votaciones
              </button>
            </div>

            {/* Botón para "Cerrar todo" y Generar Reporte */}
            <div style={{ marginTop: "20px" }}>
              <button className="btn" onClick={() => setPopUpCerrarFinal(true)}>
                Generar Reporte
              </button>
            </div>

            <h1 className="reina-informacion">
              <br />
              Tabla de Notario (Control de Votos Jueces)
            </h1>

            {listaReinas.length > 0 ? (
              listaReinas.map((candidata) => (
                <div className="matrix" key={candidata.CANDIDATA_ID}>
                  <div>
                    <br />
                    <h1>
                      {candidata.CAND_NOMBRE1} {candidata.CAND_APELLIDOPATERNO}
                    </h1>
                  </div>

                  <section className="wrapper">
                    <main className="row title">
                      <ul>
                        <li>Juez</li>
                        <li>Traje Típico (E1)</li>
                        <li>Traje Gala (E2)</li>
                        <li>Preguntas (E3)</li>
                      </ul>
                    </main>

                    <section className="row-fadeIn-wrapper">
                      <article className="row fadeIn nfl">
                        {/* Mapeamos todos los jueces */}
                        {listaJueces.map((juez) => (
                          <ul key={juez.id}>
                            {/* Nombre del juez */}
                            <li>
                              {juez.id} - {juez.name}
                            </li>

                            {/* EVENTO 1 -> Traje Típico */}
                            <li
                              className={getVotacionClass(
                                candidata.CANDIDATA_ID,
                                juez.id,
                                1
                              )}
                            >
                              {getVotacionTexto(
                                candidata.CANDIDATA_ID,
                                juez.id,
                                1
                              )}
                            </li>

                            {/* EVENTO 2 -> Traje Gala */}
                            <li
                              className={getVotacionClass(
                                candidata.CANDIDATA_ID,
                                juez.id,
                                2
                              )}
                            >
                              {getVotacionTexto(
                                candidata.CANDIDATA_ID,
                                juez.id,
                                2
                              )}
                            </li>

                            {/* EVENTO 3 -> Preguntas */}
                            <li
                              className={getVotacionClass(
                                candidata.CANDIDATA_ID,
                                juez.id,
                                3
                              )}
                            >
                              {getVotacionTexto(
                                candidata.CANDIDATA_ID,
                                juez.id,
                                3
                              )}
                            </li>
                          </ul>
                        ))}
                      </article>
                    </section>
                  </section>
                </div>
              ))
            ) : (
              <div>Cargando candidatas...</div>
            )}

            {/* Popup de confirmación para reiniciar votaciones */}
            <Popup open={mostrarPopUp} onClose={handleModalClose}>
              <div className="modal">
                <h2 className="modal-title">
                  ¿Estás seguro de querer reiniciar la votación?
                </h2>
                <div className="botones-modal">
                  <button onClick={handleModalClose} className="btn-cancelar">
                    Cancelar
                  </button>
                  <button
                    onClick={() => {
                      handleModalClose();
                      handleClickReiniciar();
                    }}
                    className="btn-confirmar"
                  >
                    Aceptar
                  </button>
                </div>
              </div>
            </Popup>

            {/* Popup de confirmación para "Cerrar y Generar Reporte" */}
            <Popup
              open={popUpCerrarFinal}
              onClose={() => setPopUpCerrarFinal(false)}
            >
              <div className="modal">
                <h2 className="modal-title">
                  ¿Estás seguro de cerrar la votación y generar el reporte?
                </h2>
                <div className="botones-modal">
                  <button
                    onClick={() => setPopUpCerrarFinal(false)}
                    className="btn-cancelar"
                  >
                    Cancelar
                  </button>
                  <button onClick={handleGenerarReporte} className="btn-confirmar">
                    Cerrar y Generar
                  </button>
                </div>
              </div>
            </Popup>
          </main>
        </div>
      </>
    );
  }
};

export default PanelAdmin;
