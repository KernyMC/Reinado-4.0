import React, { useEffect, useState, useContext } from "react";
import { Link, useLocation } from "react-router-dom";
import { AuthContext } from "../context/authContext";
import Axios from "axios";
import { API_BASE_URL } from "./ip";

const TablaNotario = () => {

    const { currentUser, logout } = useContext(AuthContext);
    const [votaciones, setVotaciones] = useState([]);
    const [datos, setDatos] = useState([]);
    const [listaJueces, setListaJueces] = useState([]);
    const [listaReinas, setListaReinas] = useState([]);
    const [votacionTerminada, isVotacionTerminada] = useState(false);
    const [desempateTerminado, setDesempateTerminado] = useState(false);

    const cat = useLocation().search;

    useEffect(() => {
        const fetchData = async () => {
            try {
                const res = await Axios.get(`${API_BASE_URL}/candidatas`);
                setListaReinas(res.data);
                const resDesempate = await Axios.get(`${API_BASE_URL}/candidatas/verificarEmpate`);
                setDesempateTerminado(resDesempate.data.desempate);
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
    }, [cat]);

    useEffect(() => {
        const verificacion = listaReinas.every((reina) => reina.CAND_NOTA_FINAL !== 0.00);
        isVotacionTerminada(verificacion);
        console.log(verificacion);
    }, [listaReinas]);

    useEffect(() => {
        const fetchData = async () => {
            try {
                const res = await Axios.get(`${API_BASE_URL}/candidatas/jueces`);
                setListaJueces(res.data);
                //console.log(listaJueces);
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
    }, [cat]);

    useEffect(() => {
        const fetchData = async () => {
            try {
                const res = await Axios.get(`${API_BASE_URL}/candidatas/votaciones`);
                setVotaciones(res.data);
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
    }, [cat]);
    

    if (currentUser === null || (currentUser.rol !== "Notario" && currentUser.rol !== "admin")) {
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
            <div className="App">
                <main>
                    <h1 className="reina-informacion"><br></br>Tabla del Veedor</h1>
                    {listaReinas.length > 0 ? (
                        <React.Fragment>
                            {listaReinas.map((item1, index) => {
                                return (
                                    <div className="matrix">
                                        <div>
                                            <br></br>
                                            <h1>{item1.CAND_NOMBRE1} {item1.CAND_APELLIDOPATERNO}</h1>
                                        </div>
                                        <div>
                                            <section class="wrapper">

                                                <main class="row title">
                                                    <ul>
                                                        <li>Juez</li>
                                                        <li>Traje Típico</li>
                                                        <li>Traje de Gala</li>
                                                        <li>Preguntas</li>
                                                    </ul>
                                                </main>

                                                <section class="row-fadeIn-wrapper">
                                                    <article class="row fadeIn nfl">
                                                        {listaJueces.map((item2, index) => {
                                                            return (
                                                                <ul>
                                                                    <li>{item2.id} - {item2.name}</li>
                                                                    {votaciones.map((item3, index) => {
                                                                        if (item3.CANDIDATA_ID === item1.CANDIDATA_ID && item3.USUARIO_ID === item2.id) {
                                                                            return (
                                                                                <li className={item3.VOT_ESTADO === "no" ? "celda-roja" : "celda-verde"}>
                                                                                    {item3.VOT_ESTADO === "no" ? "Pendiente" : "Votado"}

                                                                                </li>
                                                                            );
                                                                        }
                                                                    })}
                                                                </ul>
                                                            );
                                                        })}
                                                    </article>
                                                </section>
                                            </section>
                                        </div>
                                    </div>
                                );
                            }
                            )}
                        </React.Fragment>
                    ) : (
                        <div>Loading...</div>
                    )
                    }
                        {votacionTerminada || desempateTerminado ? <div class="boton">                        <Link to="/reporte">
                            <button className='btn-reporte'>¡Verificar Reporte 📄!</button>
                        </Link>
                    </div> : null}
                </main>
            </div>
        );
    }
};




export default TablaNotario;