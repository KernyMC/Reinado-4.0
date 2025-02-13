import React, { useEffect, useState, useContext } from "react";
import { AuthContext } from "../context/authContext";
import { Link, useLocation, useNavigate } from "react-router-dom";
import Axios, { all } from 'axios';
import ReactModal from "react-modal";
import Popup from "reactjs-popup";
import "./popup.scss";
import Espera from "../components/Espera.jsx";
import { API_BASE_URL } from "./ip";
import Navbar from "../components/Navbar";
import "./Barras.scss";
import Stack from '@mui/material/Stack';
import Button from '@mui/material/Button';
function Preguntas() {

  const cat = useLocation().search;
  const { currentUser } = useContext(AuthContext);
  const [elements, setElements] = useState(Array.from({ length: 12 }, () => 0));
  const [modalIsOpen, setModalIsOpen] = useState(false);
  const [vacioIsOpen, setVacioIsOpen] = useState(false);
  const [pop, setPop] = useState(false);
  const navigate = useNavigate();

  const cortarParteDerecha = (cadena) => {
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
      // Enviar calificaciones
      const calificaciones = elements.map((valor, index) => ({
        EVENTO_ID: 3,
        USUARIO_ID: currentUser.id,
        CANDIDATA_ID: index + 1,
        CALIFICACION_NOMBRE: "Preguntas",
        CALIFICACION_PESO: 100,
        CALIFICACION_VALOR: valor * 2
      }));

      // Enviar calificaciones una por una
      for (const calificacion of calificaciones) {
        if (calificacion.CALIFICACION_VALOR > 0) {
          await Axios.post(`${API_BASE_URL}/cali`, calificacion);
        }
      }

      // Verificar empate
      const empateResponse = await Axios.get(`${API_BASE_URL}/user/verificar_empate`);
      
      setPop(true);

      if (empateResponse.data.empate) {
        try {
          // Activar evento de desempate
          await Axios.put(`${API_BASE_URL}/events/5`, {
            EVENTO_NOMBRE: 'Desempate',
            EVENTO_PESO: 100,
            EVENTO_ESTADO: 'si'
          });

          // Esperar un momento antes de redirigir
          setTimeout(() => {
            navigate('/Desempate');
          }, 2000);
        } catch (error) {
          console.error("Error activando evento de desempate:", error);
        }
      } else {
        // Si no hay empate, esperar 2 segundos y redirigir al panel
        setTimeout(() => {
          navigate('/PanelAdmin');
        }, 2000);
      }

    } catch (err) {
      console.error("Error al enviar calificaciones:", err);
    }
  };

  const Enviar = () => {
    if (elements.includes(0)) {
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
      newElements[index] = value;
      return newElements;
    });
  };

  useEffect(() => {
    const fetchData = async () => {
      try {
        const response1 = await Axios.get(`${API_BASE_URL}/user/ck3?id=${12}`);
        if (response1.data[0].total === 0) {
          // Maneja el caso donde total es 0 si es necesario
        } else {
          const response2 = await Axios.get(`${API_BASE_URL}/user/verificar_empate`);
          if (response2.data.empate) {
            navigate("/Desempate");
          } else {
            navigate("/Gracias");
          }
        }
      } catch (error) {
        console.error(error);
      }
    };
  
    const interval = setInterval(() => {
      fetchData();
    }, 5000);
  
    return () => {
      clearInterval(interval);
    };
  }, []);
  

  const [listaCandidatas, setListaCandidatas] = useState([]);

  useEffect(() => {
    const fetchData = async () => {
      try {
        const res = await Axios.get(`${API_BASE_URL}/barra`);
        setListaCandidatas(res.data);
      } catch (err) {
        console.log(err);
      }
    };
    fetchData();
  }, [cat + "1"]);



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
        <Navbar texto="Evento - Preguntas" />
        {pop === true && <Espera />}

        <div className="main-container">
          <div className="reinas-container">
            {listaCandidatas.map((candidata, index) => (
              <div className="item-reina" key={candidata.CANDIDATA_ID}><div className="espacio-imagen">
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
                        {elements[candidata.CANDIDATA_ID - 1] !== 0 ? `${elements[candidata.CANDIDATA_ID - 1]} de 10` : 'Votar'}
                      </span>

                    </div>
                    <ul className="menu" aria-label="Action event example">
                      {Array.from({ length: 10 }, (_, i) => (
                        <li
                          key={i + 1}
                          onClick={() => {
                            setValue(candidata.CANDIDATA_ID - 1, i + 1);
                          }}
                          className={elements[candidata.CANDIDATA_ID - 1] === i + 1 ? "active" : ""}
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
                        <Button color="success" variant="contained" onClick={()=> {handleModalClose(); handleClick(); setPop(true);}} className="btn-confirmar">
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
                  <button onClick={handleVacioClose} className="btn-confirmar">
                    Aceptar
                  </button>
                </div>
              </div>
            </Popup>
          </div>
        </div>

      </>
    );
  }
}

export default Preguntas;
