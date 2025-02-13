import React, { useEffect, useState, useContext } from "react";
import { AuthContext } from "../context/authContext";
import { useLocation, useNavigate } from "react-router-dom";
import Axios from 'axios';
import Popup from "reactjs-popup";
import "./popup.scss";
import Espera from "../components/Espera.jsx";
import { API_BASE_URL } from "./ip";
import Navbar from "../components/Navbar";
import Stack from '@mui/material/Stack';
import Button from '@mui/material/Button';

function Desempate() {
  const cat = useLocation().search;
  const { currentUser } = useContext(AuthContext);
  const [elements, setElements] = useState([]);
  const [modalIsOpen, setModalIsOpen] = useState(false);
  const [vacioIsOpen, setVacioIsOpen] = useState(false);
  const [pop, setPop] = useState(false);
  const [listaCandidatas, setListaCandidatas] = useState([]);
  const navigate = useNavigate();
  const [esperando, setEsperando] = useState(false);

  const cortarParteDerecha = (cadena) => {
    if (!cadena) return "";
    let parteDerecha = "";
    let i = cadena.length - 1;
    while (i >= 0 && cadena[i] !== "\\") {
      parteDerecha = cadena[i] + parteDerecha;
      i--;
    }
    return parteDerecha;
  };

  // Cargar candidatas empatadas
  useEffect(() => {
    const cargarCandidatasEmpatadas = async () => {
      try {
        // Primero obtener las candidatas empatadas
        const empateResponse = await Axios.get(`${API_BASE_URL}/candidatas/verificar-empate`);
        console.log("Respuesta de empate:", empateResponse.data);
        
        if (empateResponse.data.hayEmpate) {
          // Obtener los IDs de las candidatas empatadas
          const candidatasIds = empateResponse.data.candidatasEmpatadas.map(c => c.CANDIDATA_ID);
          
          // Obtener los detalles completos de las candidatas
          const detallesResponse = await Axios.get(`${API_BASE_URL}/candidatas/tt`);
          const candidatasCompletas = detallesResponse.data.filter(
            candidata => candidatasIds.includes(candidata.CANDIDATA_ID)
          );

          setListaCandidatas(candidatasCompletas);
          setElements(Array(candidatasCompletas.length).fill(0));
        }
      } catch (err) {
        console.error("Error cargando candidatas empatadas:", err);
      }
    };

    cargarCandidatasEmpatadas();
  }, []);

  useEffect(() => {
    const verificarEstadoDesempate = async () => {
      try {
        const response = await Axios.get(`${API_BASE_URL}/user/check-desempate`);
        const estaActivo = response.data.EVENTO_ESTADO === "si";
        
        if (!estaActivo) {
          navigate("/");
        }
      } catch (error) {
        console.error("Error verificando estado de desempate:", error);
      }
    };

    const interval = setInterval(verificarEstadoDesempate, 5000);
    return () => clearInterval(interval);
  }, [navigate]);

  const handleClick = async () => {
    try {
      const calificaciones = elements.map((valor, index) => ({
        EVENTO_ID: 5, // ID del evento de desempate
        USUARIO_ID: currentUser.id,
        CANDIDATA_ID: listaCandidatas[index].CANDIDATA_ID,
        CALIFICACION_NOMBRE: "Desempate",
        CALIFICACION_PESO: 100,
        CALIFICACION_VALOR: valor * 2
      }));

      for (const calificacion of calificaciones) {
        if (calificacion.CALIFICACION_VALOR > 0) {
          await Axios.post(`${API_BASE_URL}/cali`, calificacion);
        }
      }

      setEsperando(true);
      await Axios.put(`${API_BASE_URL}/user/cambio/no/5`);
      navigate("/Gracias");
    } catch (err) {
      console.error("Error al enviar calificaciones:", err);
      setEsperando(false);
    }
  };

  const Enviar = () => {
    if (elements.includes(0)) {
      setVacioIsOpen(true);
    } else {
      setModalIsOpen(true);
    }
  };

  const handleModalClose = () => setModalIsOpen(false);
  const handleVacioClose = () => setVacioIsOpen(false);

  const setValue = (index, value) => {
    setElements((prevElements) => {
      const newElements = [...prevElements];
      newElements[index] = value;
      return newElements;
    });
  };

  let currentDropdown = null;

  const handleSelectClick = (e) => {
    e.stopPropagation();
    if (currentDropdown && currentDropdown !== e.currentTarget) {
      currentDropdown.querySelector(".menu").classList.remove("menu-open");
    }

    const dropdown = e.currentTarget.querySelector(".menu");
    dropdown.classList.toggle("menu-open");

    currentDropdown = dropdown.classList.contains("menu-open") ? e.currentTarget : null;

    const handleClickOutside = (event) => {
      if (!dropdown.contains(event.target)) {
        dropdown.classList.remove("menu-open");
        window.removeEventListener('click', handleClickOutside);

        if (currentDropdown === e.currentTarget) {
          currentDropdown = null;
        }
      }
    };

    window.addEventListener('click', handleClickOutside);
  };

  if (!currentUser || (currentUser.rol !== "juez" && currentUser.rol !== "admin")) {
    return (
      <div className="App">
        <main>
          <div>
            <h1>Lo sentimos, no tienes permiso para ver esta página.</h1>
          </div>
        </main>
      </div>
    );
  }

  return (
    <>
      <Navbar texto="Desempate" />
      {esperando ? (
        <Espera />
      ) : (
        <>
          <div className="main-container">
            <div className="reinas-container">
              {listaCandidatas.map((candidata, index) => (
                <div className="item-reina" key={candidata.CANDIDATA_ID}>
                  <div className="espacio-imagen">
                    <img
                      alt="Foto candidata"
                      className="foto-candidata"
                      src={"/reinas/" + cortarParteDerecha(candidata.FOTO_URL)}
                    />
                    <div className="datos-candidata">
                      <h3>
                        {candidata.CAND_NOMBRE1} {candidata.CAND_APELLIDOPATERNO}
                      </h3>
                      <h4>{candidata.DEPARTMENTO_NOMBRE}</h4>
                    </div>
                  </div>
                  <div className="dropdown" onClick={handleSelectClick}>
                    <div className="botones-container">
                      <div className="select">
                        <span className="selected">
                          {elements[index] !== 0 ? `${elements[index]} de 10` : 'Votar'}
                        </span>
                      </div>
                      <ul className="menu" aria-label="Action event example">
                        {Array.from({ length: 10 }, (_, i) => (
                          <li
                            key={i + 1}
                            onClick={() => setValue(index, i + 1)}
                            className={elements[index] === i + 1 ? "active" : ""}
                          >
                            {i + 1}
                          </li>
                        ))}
                      </ul>
                    </div>
                  </div>
                </div>
              ))}
            </div>
            <div id="enviarbarra" className="enviar">
              <Button type="button" className="btn-enviar" onClick={Enviar}>
                ENVIAR
              </Button>

              <Popup open={modalIsOpen} onClose={handleModalClose}>
                <div className="modal">
                  <h2 className="modal-title">¿Está seguro de registrar su voto?</h2>
                  <div className="botones-modal">
                    <Stack direction="row" spacing={4} justifyContent="center" alignItems="center">
                      <Button 
                        color="success" 
                        variant="contained" 
                        onClick={() => {
                          handleModalClose();
                          handleClick();
                          setPop(true);
                        }}
                        className="btn-confirmar"
                      >
                        Si
                      </Button>
                      <Button 
                        color="error" 
                        variant="outlined" 
                        onClick={handleModalClose} 
                        className="btn-cancelar"
                      >
                        No
                      </Button>
                    </Stack>
                  </div>
                </div>
              </Popup>

              <Popup open={vacioIsOpen} onClose={handleVacioClose}>
                <div className="modal">
                  <h2 className="modal-title">Por favor, registre su voto por cada candidata.</h2>
                  <div className="botones-modal">
                    <Button onClick={handleVacioClose} className="btn-confirmar">
                      Aceptar
                    </Button>
                  </div>
                </div>
              </Popup>
            </div>
          </div>
        </>
      )}
    </>
  );
}

export default Desempate;
