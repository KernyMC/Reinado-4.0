import { useContext, useEffect, useState } from "react";
import React from "react";
import { Link, useLocation } from "react-router-dom";
import { AuthContext } from "../context/authContext.js";
import "./CRG_Barra.scss";
import logoBarra from "../img/logoespereina.png";
import { API_BASE_URL } from './ip.js';
import Axios from 'axios';


const CRG_Barra = () => {

  const [listaEvento, setListaEvento] = useState([]);
  const cat = useLocation().search;

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
          <div className="esperaBarra" style={{ width: '100%', height: '100vh' }}>
            <figure className="cortina_izquierda"></figure>
            <figure className="cortina_derecha"></figure>
            <img src={logoBarra} alt="logo" className="logoespereinaBarra" />
            <h1 className="tituloBarra" contenteditable data-heading="Preguntas">
              Preguntas
            </h1>
            {listaEvento.map((evento, eventoIndex) => {
              if (evento.EVENTO_ID === 3 && evento.EVENTO_ESTADO === "si" ) {
                return (
                  <div className="btn-dorado" id="btn-crg">
                    <Link to="/Preguntas">
                      <button className="golden-btn" >INICIAR VOTACIÓN</button>
                    </Link>
                  </div>
                );
              } else {
                return null;
              }
            })}
          </div>
        }
      </>
    );
  }
};
export default CRG_Barra;
