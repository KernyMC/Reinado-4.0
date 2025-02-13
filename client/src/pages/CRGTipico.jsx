import { useState, useEffect, useContext } from "react";
import { API_BASE_URL } from './ip.js';
import Axios from 'axios';
import React from "react";
import { Link, useLocation } from "react-router-dom";
import { AuthContext } from "../context/authContext.js";
import "./CRG_Tipico.scss";
import logoTipico from "../img/logoespereina.png";

const CRG_Tipico = () => {
  const cat = useLocation().search;
  const [listaEvento, setListaEvento] = useState([]);
  useEffect(() => {
    const fetchData = async () => {
      try {
        const res = await Axios.get(`${API_BASE_URL}/barra/2`);
        setListaEvento(res.data);
        //console.log(listaEvento);
      } catch (err) {
        console.log(err);
      }
    };
    const interval = setInterval(() => {
      fetchData();
    }, 1000);

    return () => {
      clearInterval(interval);
    };
  }, [cat + '2']);

  const { currentUser } = useContext(AuthContext);
  if (
    currentUser === null ||
    (currentUser.rol !== "juez" && currentUser.rol !== "admin")
  ) {
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
        {
          <div className="esperaTipico">
            <figure className="cortina_izquierda"></figure>
            <figure className="cortina_derecha"></figure>
            <img src={logoTipico} alt="logo" className="logoespereinaTipico" />
            <h1 className="tituloTipico" contenteditable data-heading="Traje Típico">
              Traje Típico
            </h1>
            {listaEvento.map((evento, eventoIndex) => {
              if (evento.EVENTO_ID === 1 && evento.EVENTO_ESTADO === "si") {
                return (
                  <div class="btn-dorado" id="btn-crg">
                    <Link to="/TrajeTipico">
                      <button className="golden-btn">Iniciar Votación</button>
                    </Link>
                  </div>
                );
              } else {
                return null; // O puedes devolver un componente vacío (<></>)
              }
            })}
          </div>
        }
      </>
    );
  }
};
export default CRG_Tipico;
