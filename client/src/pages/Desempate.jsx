import React, { useEffect, useState, useContext } from "react";
import Axios from 'axios';
import { AuthContext } from "../context/authContext";
import { Link, useLocation, useNavigate } from "react-router-dom";

import Popup from "reactjs-popup";
import Espera from "../components/Espera.jsx";
import { API_BASE_URL } from "./ip";
import Navbar from "../components/Navbar";
import Stack from '@mui/material/Stack';
import Button from '@mui/material/Button';
import "./popup.scss";

function Desempate() {
  const { currentUser } = useContext(AuthContext);
  const [elements, setElements] = useState([]);
  const [modalIsOpen, setModalIsOpen] = useState(false);
  const [vacioIsOpen, setVacioIsOpen] = useState(false);
  const [pop, setPop] = useState(false);
  const [candidatasEmpatadas, setCandidatasEmpatadas] = useState([]);
  const [candidatasDetalles, setCandidatasDetalles] = useState([]);
  const [empateInfo, setEmpateInfo] = useState(null);
  const [showEmpatePopup, setShowEmpatePopup] = useState(true);
  const [tipoEmpate, setTipoEmpate] = useState('');
  const navigate = useNavigate();


  useEffect(() => {
    const fetchData = async () => {
      try {
        const response = await Axios.get(`${API_BASE_URL}/cali/verificar_empate`);
        if (response.data.candidatasEmpatadas) {
          setCandidatasEmpatadas(response.data.candidatasEmpatadas);
          setElements(Array(response.data.candidatasEmpatadas.length).fill({ nota: 0, nota_final: 0 }));
          
          // Configurar información del empate
          console.log("Datos de empate:", response.data);
          
          const tipo = response.data.candidatasEmpatadas[0].tipo;
          setTipoEmpate(tipo);
          
          const mensaje = {
            'primer-lugar': 'primer lugar',
            'segundo-lugar': 'segundo lugar', 
            'tercer-lugar': 'tercer lugar'
          }[tipo];

          setEmpateInfo({
            candidatas: response.data.candidatasEmpatadas.map(c => 
              `${c.CAND_NOMBRE1} ${c.CAND_APELLIDOPATERNO}`
            ).join(', '),
            tipo: mensaje
          });
        }
      } catch (err) {
        console.error("Error al obtener datos de empate:", err);
        setVacioIsOpen(true);
      }
    };
    fetchData();
  }, []);

  const cortarParteDerecha = (cadena) => {
    if (typeof cadena !== 'string') {
      console.error("La cadena no es válida");
      return "";
    }

    let parteDerecha = "";
    let i = cadena.length - 1;

    while (i >= 0 && cadena[i] !== "\\") {
      parteDerecha = cadena[i] + parteDerecha;
      i--;
    }

    return parteDerecha;
  };

const handleClick = async () => {
  try {
    if (!currentUser) {
      throw new Error("No autenticado");
    }

    // Verificar que todos los elementos tengan una nota válida
    if (elements.some(element => !element.nota || element.nota === 0)) {
      setVacioIsOpen(true);
      return;
    }

    // Obtener el tipo de empate y las calificaciones
    const calificaciones = elements.map((element, index) => ({
      EVENTO_ID: 5,
      USUARIO_ID: currentUser.id,
      CANDIDATA_ID: candidatasEmpatadas[index].CANDIDATA_ID,
      CALIFICACION_NOMBRE: "Desempate",
      CALIFICACION_PESO: 100,
      CALIFICACION_VALOR: parseFloat(element.nota) * 2, // Aseguramos que sea número
      tipo_empate: tipoEmpate
    }));

    console.log("Enviando calificaciones:", calificaciones); // Para debug

    const response = await Axios.post(`${API_BASE_URL}/cali/desempate_final`, {
      calificaciones,
      tipo_empate: tipoEmpate
    });

    if (response.data.message === "Desempate procesado exitosamente") {
      setPop(true);
      setTimeout(() => {
        navigate('/Gracias');
      }, 2000);
    }

  } catch (err) {
    console.error("Error detallado:", err.response?.data || err.message);
    alert("Error al procesar el desempate. Por favor, intente nuevamente.");
  }
};

  const Enviar = () => {
    if (elements.some(element => element.nota === 0)) {
      setVacioIsOpen(true);
    } else {
      setModalIsOpen(true);
    }
  };

  const handleModalClose = () => {
    setModalIsOpen(false);
  };

  const handleVacioClose = () => {
    setVacioIsOpen(false);
  };

  const setValue = (index, value) => {
    setElements((prevElements) => {
      const newElements = [...prevElements];
      newElements[index] = { ...newElements[index], nota: value };
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

  const EmpateModal = () => (
    <Popup open={showEmpatePopup} onClose={() => setShowEmpatePopup(false)}>
      <div className="modal">
        <h2 className="modal-title">¡Atención! Empate Detectado</h2>
        {empateInfo && (
          <div className="modal-content">
            <p>Se ha detectado un empate por el <b>{empateInfo.tipo}</b> entre las siguientes candidatas:</p>
            <br></br>
            <p className="candidatas-empatadas">{empateInfo.candidatas}</p>
            <br></br>
            <p>Por favor, proceda a calificar nuevamente a estas candidatas para resolver el empate.</p>
            <br></br>
          </div>
        )}
        <div className="botones-modal">
          <button onClick={() => setShowEmpatePopup(false)} className="btn-confirmar">
            Entendido
          </button>
        </div>
      </div>
    </Popup>
  );

  if (currentUser === null || (currentUser.rol !== "juez" && currentUser.rol !== "admin")) {
    return (
        <div className="App">
          <main>
            <div>
              <h1>Lo sentimos, no tienes permiso para ver esta página.</h1>
            </div>
          </main>
        </div>
    );
  } else {
    return (
        <>
          <Navbar texto="Desempate" />
          {pop && <Espera />}
          <div className="main-container">
            {empateInfo && (
              <div className={`empate-banner ${tipoEmpate}`}>
                <h2>Desempate por {empateInfo.tipo}</h2>
                <p>Calificación para resolver el empate entre: {empateInfo.candidatas}</p>
              </div>
            )}
            <div className="reinas-container">
              {candidatasEmpatadas.map((candidata, index) => (
                  <div className="item-reina" key={candidata.CANDIDATA_ID}>
                    <div className="espacio-imagen">
                      <img
                          alt="Foto candidata"
                          className="foto-candidata"
                          src={
                            candidata.FOTO_URL
                                ? "/reinas/" + cortarParteDerecha(candidata.FOTO_URL)
                                : '/reinas/default.jpg'
                          }
                      />
                      <div className="datos-candidata">
                        <h3>{candidata.CAND_NOMBRE1} {candidata.CAND_APELLIDOPATERNO}</h3>
                        <h4>{candidata.DEPARTMENTO_NOMBRE}</h4>                      </div>
                    </div>
                    <div className="dropdown" onClick={handleSelectClick}>
                      <div className="botones-container">
                        <div className="select">
                      <span className="selected">
                        {elements[index].nota !== 0 ? `${elements[index].nota} de 10` : 'Votar'}
                      </span>
                        </div>
                        <ul className="menu" aria-label="Action event example">
                          {Array.from({ length: 10 }, (_, i) => (
                              <li
                                  key={i + 1}
                                  onClick={() => setValue(index, i + 1)}
                                  className={elements[index].nota === i + 1 ? "active" : ""}
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
                      <Button color="success" variant="contained" onClick={() => { handleModalClose(); handleClick(); setPop(true); }} className="btn-confirmar">
                        Si
                      </Button>
                      <Button color="error" variant="outlined" onClick={handleModalClose} className="btn-cancelar">
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
            <EmpateModal />
          </div>
        </>
    );
  }
}

export default Desempate;
