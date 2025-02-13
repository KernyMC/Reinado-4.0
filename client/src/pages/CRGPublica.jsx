import { useContext, useEffect, useState } from "react";
import React from "react";
import { Link, useLocation } from "react-router-dom";
import { AuthContext } from "../context/authContext.js";
import "./CRG_Publica.scss";
import logoPublica from "../img/logoespereina.png";
import { API_BASE_URL } from "./ip.js";
import Axios from "axios";

const CRG_Publica = () => {
  const [listaEvento, setListaEvento] = useState([]);
  const cat = useLocation().search;
  const catDependency = cat + "2";

  useEffect(() => {
    const fetchData = async () => {
      try {
        const res = await Axios.get(`${API_BASE_URL}/barra/2`);
        setListaEvento(res.data);
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
  }, [catDependency]);

  const { currentUser } = useContext(AuthContext);

  if (!currentUser || currentUser.rol !== "usuario") {
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
        <div className="esperaPublica">
          <figure className="cortina_izquierda"></figure>
          <figure className="cortina_derecha"></figure>
          <img src={logoPublica} alt="logo" className="logoespereinaPublica" />
          <h1 className="tituloPublica" data-heading="Votación Pública">
            Votación Pública
          </h1>
          {listaEvento.map((evento) => {
            // Ajuste: verificamos "si" en lugar de "activo"
            if (evento.EVENTO_ID === 4 && evento.EVENTO_ESTADO === "si") {
              return (
                <div className="btn-dorado" id="btn-crg" key={evento.EVENTO_ID}>
                  <Link to="/VotacionPublica">
                    <button className="golden-btn">INICIAR VOTACIÓN</button>
                  </Link>
                </div>
              );
            } else {
              return null;
            }
          })}
        </div>
      </>
    );
  }
};

export default CRG_Publica;