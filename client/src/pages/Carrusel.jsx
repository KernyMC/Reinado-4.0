import React, { useState, useEffect } from 'react';
import { Link, useLocation } from "react-router-dom";
import imagen1 from "../img/Candidata1.png";
import imagen2 from "../img/Candidata2.png";
import imagen3 from "../img/Candidata3.png";
import imagen4 from "../img/Candidata4.png";
import imagen5 from "../img/Candidata5.png";
import imagen6 from "../img/Candidata6.png";
import imagen7 from "../img/Candidata7.png";
import imagen8 from "../img/Candidata8.png";
import imagen9 from "../img/Candidata9.png";
import imagen10 from "../img/Candidata10.png";
import { API_BASE_URL } from './ip.js';
import Axios from 'axios';
import "./carrusel.scss";
import "./botonIniciar.scss";
import Navbar from "../components/Navbar";

function Carrusel() {
    const [index, setIndex] = useState(0);
    const [active, setActive] = useState(false);
    const [listaReinas, setListaReinas] = useState([]);
    const imagenArray = [imagen1, imagen2, imagen3, imagen4, imagen5, imagen6, imagen7, imagen8, imagen9, imagen10];
    const cat = useLocation().search;
    const location = useLocation();
    const [listaEvento, setListaEvento] = useState([]);

    //Formato de Fecha
    function fechaFormato(fecha) {
        const fechaDate = new Date(fecha);
        const formato = { day: 'numeric', month: 'long', year: 'numeric' };
        const hoyFormato = fechaDate.toLocaleDateString('es-ES', formato);
        return hoyFormato;
    }
    //Cortar URL
    const cortarParteDerecha = (cadena) => {
        let parteDerecha = "";
        let i = cadena.length - 1;
    
        while (i >= 0 && cadena[i] !== "\\") {
          parteDerecha = cadena[i] + parteDerecha;
          i--;
        }
    
        return parteDerecha;
      };

    const next = () => {
        setIndex((prevIndex) => (prevIndex + 1) % 10);
    };

    const prev = () => {
        setIndex((prevIndex) => ((prevIndex - 1 + 10) % 10));
    };

    useEffect(() => {
        const fetchData = async () => {
            try {
                const res = await Axios.get(`${API_BASE_URL}/candidatas/tt`);
                setListaReinas(res.data);
                //console.log(listaReinas);
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
    }, [cat + 'carruselCandidatas']);


    useEffect(() => {
        const interval = setInterval(() => {
            next();
        }, 10000);

        return () => {
            clearInterval(interval);
        };
    }, [index]);



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




    return (
        <>
            {/* <Navbar texto="Presentación Reinas" /> */}
            <div className="containerCarrusel">
                {listaReinas.map((reina, reinaIndex) => (
                    <div key={reinaIndex} className={`slide-container ${index === reinaIndex ? 'active' : ''}`}>
                        <div className="slide">
                            <div className="content">
                                <h3 className="circuloReferencia">{reina.CANDIDATA_ID}</h3>
                                <h3 className="carrusel-heading">{reina.CAND_NOMBRE1} {reina.CAND_APELLIDOPATERNO}</h3>
                                <b><p className="carrusel-paragraph-dep">{reina.DEPARTMENTO_NOMBRE}</p></b>
                                <p className="carrusel-paragraph"><b>Fecha de Nacimiento:</b> {fechaFormato('T'.split('T')[0])} </p>
                                <p className="carrusel-paragraph"><b>Estatura:</b> {reina.CAND_ESTATURA}</p>
                                <p className="carrusel-paragraph"><b>Idiomas:</b> {reina.CAND_IDIOMAS}</p>
                                <p className="carrusel-paragraph"><b>Color de ojos:</b> {reina.CAND_COLOROJOS}</p>
                                <p className="carrusel-paragraph"><b>Color de cabello:</b> {reina.CAND_COLORCABELLO}</p><p className='carrusel-paragraph'> </p>
                                <p className="carrusel-paragraph"><b>Hobbies:</b></p><div className="carrusel-paragraph" dangerouslySetInnerHTML={{ __html: reina.CAND_HOBBIES }}></div>
                            </div>
                            <img src={"/reinas/" + cortarParteDerecha(reina.FOTO_URL)} alt="" />
                        </div>
                        {listaEvento.map((evento, eventoIndex) => {
                            if (evento.EVENTO_ID === 1 && evento.EVENTO_ESTADO === "si") {
                                return (
                                    <div class="boton">
                                        <Link to="/TrajeTipico">
                                            <button className='btn'>Iniciar Votación</button>
                                        </Link>
                                    </div>
                                );
                            } else {
                                return null; // O puedes devolver un componente vacío (<></>)
                            }
                        })}

                    </div>
                ))}
                <div id="next" onClick={next}> ▶ </div>
                <div id="prev" onClick={prev}> ◀ </div>
            </div>
        </>
    );
}

export default Carrusel;
