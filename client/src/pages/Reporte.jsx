import React, { useState, useEffect } from 'react';
import Axios from 'axios';
import { useLocation } from "react-router-dom";
import { API_BASE_URL } from './ip.js';
import { Document, Font, Image, Page, Text, StyleSheet, View, PDFViewer } from '@react-pdf/renderer';
import Logo from "../img/logoespereina.png";

function Reporte() {
  const hoy = new Date();
  const fechaHora = { day: 'numeric', month: 'long', year: 'numeric', hour: 'numeric', minute: 'numeric', second: 'numeric' };
  const fecha = { day: 'numeric', month: 'long', year: 'numeric' };
  const hoyFormato = hoy.toLocaleDateString('es-ES', fecha);
  const horaFormato = hoy.toLocaleDateString('es-ES', fechaHora);

  const cat = useLocation().search;
  const [listaReinas, setListaReinas] = useState([]);
  const [listaDepartamentos, setListaDepartamentos] = useState([]);
  const [votacionTerminada, isVotacionTerminada] = useState(false);

  useEffect(() => {
    const fetchData = async () => {
      try {
        const res = await Axios.get(`${API_BASE_URL}/candidatas`);
        setListaReinas(res.data);
      } catch (err) {
        console.log(err);
      }
    };
    fetchData();
  }, [cat]);

  useEffect(() => {
    const fetchData = async () => {
      try {
        const res = await Axios.get(`${API_BASE_URL}/candidatas/carruselCandidatas`);
        setListaDepartamentos(res.data);
      } catch (err) {
        console.log(err);
      }
    };
    fetchData();
  }, [cat, votacionTerminada]);

  useEffect(() => {
    // Verificamos si TODAS las candidatas tienen CAND_NOTA_FINAL != 0
    const verificacion = listaReinas.every((reina) => reina.CAND_NOTA_FINAL !== 0.00);
    isVotacionTerminada(verificacion);
    console.log("¿Votación Terminada?", verificacion);
  }, [listaReinas]);

  Font.register({
    family: 'Oswald',
    src: 'https://fonts.gstatic.com/s/oswald/v13/Y_TKV6o8WovbUd3m_X9aAA.ttf',
  });

  // Estilos PDF
  const styles = StyleSheet.create({
    page: {
      paddingTop: 35,
      paddingBottom: 65,
      paddingHorizontal: 35,
    },
    header: {
      fontSize: 12,
      marginBottom: 10,
      textAlign: 'center',
      color: 'grey',
    },
    text: {
      margin: 12,
      fontSize: 14,
      textAlign: 'justify',
      marginBottom: 2,
      marginTop: 2,
      fontFamily: 'Oswald'
    },
    bold: {
      fontFamily: 'Oswald'
    },
    section: {
      margin: 10,
      padding: 10,
      flexGrow: 1
    },
    section_ganadoras: {
      textAlign: 'center',
      justifyContent: 'center',
      padding: 10,
    },
    title: {
      fontSize: 34,
      textAlign: 'center',
      fontFamily: 'Oswald'
    },
    subtitle: {
      fontSize: 14,
      textAlign: 'center',
      fontFamily: 'Oswald'
    },
    tituloreina: {
      fontSize: 24,
      textAlign: 'center',
      fontFamily: 'Oswald'
    },
    image: {
      marginVertical: 0,
      marginHorizontal: 100
    },
    imageFoto: {
      marginVertical: 15,
      marginHorizontal: 100,
      width: 100,
      borderRadius: 10
    },
    imageGanadoras: {
      marginHorizontal: 155,
      width: 220,
    },
    contenedorColumna: {
      flexDirection: 'row',
      flexWrap: 'wrap',
      justifyContent: 'right',
      paddingLeft: 30,
    },
    columna: {
      width: '40%',
      marginBottom: 10
    },
    pageNumber: {
      position: 'absolute',
      fontSize: 12,
      bottom: 30,
      left: 0,
      right: 0,
      textAlign: 'center',
      color: 'grey',
    },
  });

  // Render PDF o mensaje de "votación no terminada"
  if (votacionTerminada) {
    return (
      <div className="carousel-item-text">
        <h1 className="App">Reportes</h1>
        <div className="reporte">
          <h1>1/2: Informe de Resultados</h1>
          <div className="reporte-contenedor">
            <PDFViewer scale={1} width="1000" height="600">
              <Document>
                <Page size="A4" style={styles.page}>
                  <View>
                    <Text style={styles.header} fixed>
                      Sistema de Votación - Reina ESPE 2024 - {horaFormato}
                    </Text>
                    <Text style={styles.text}>Sangolquí, {hoyFormato}</Text>
                    <Image style={styles.image} src={Logo} />

                    <View style={styles.section}>
                      <Text style={styles.title}>Informe de Resultados</Text>
                      <Text style={styles.subtitle}>
                        Puntajes Arrojados por el Sistema Informático
                      </Text>
                      <Text style={styles.subtitle}>
                        Hora de Corte del Sistema (GMT-05): {horaFormato}
                      </Text>
                    </View>

                    <React.Fragment>
                      {listaReinas
                        .sort((a, b) => b.CAND_NOTA_FINAL - a.CAND_NOTA_FINAL)
                        .map((reina, index) => (
                          <View
                            style={styles.contenedorColumna}
                            key={reina.CANDIDATA_ID}
                          >
                            <View style={styles.columna}>
                              {index === 0 && (
                                <Text style={styles.bold}>Reina ESPE 2024</Text>
                              )}
                              {index === 1 && (
                                <Text style={styles.bold}>Srta. Confraternidad</Text>
                              )}
                              {index === 2 && (
                                <Text style={styles.bold}>Srta. Simpatía</Text>
                              )}
                              {reina.ID_ELECCION === 1 && (
                                <Text style={styles.bold}>Candidata Amistad</Text>
                              )}
                              <Text style={styles.text}>
                                Lugar {index + 1}: {reina.CAND_NOMBRE1} {reina.CAND_APELLIDOPATERNO}
                              </Text>
                              <Text style={styles.text}>
                                Puntuación Final:
                              </Text>
                              <Text style={styles.text}>
                                {reina.CAND_NOTA_FINAL}/150
                              </Text>
                            </View>
                            <View style={styles.columna}>
                              {/* Si deseas mostrar foto extra, ajusta aquí */}
                            </View>
                          </View>
                        ))}
                    </React.Fragment>

                    <View style={styles.section}>
                      <View style={styles.contenedorColumna}>
                        <View style={styles.section}>
                          <Text style={styles.subtitle}>____________________</Text>
                          <Text style={styles.subtitle}>Veedor</Text>
                          <Text style={[styles.subtitle, styles.bold]}>
                            Dr. Marcelo Mejía Mena
                          </Text>
                          <Text style={styles.subtitle}>CI: 1803061033</Text>
                        </View>
                      </View>
                    </View>
                  </View>
                  <Text
                    style={styles.pageNumber}
                    render={({ pageNumber, totalPages }) =>
                      `Página ${pageNumber} de ${totalPages}`
                    }
                    fixed
                  />
                </Page>
              </Document>
            </PDFViewer>
          </div>

          <h1>2/2: Proclamación de Ganadoras</h1>
          <div className="reporte-contenedor">
            <PDFViewer scale={1} width="1000" height="600">
              <Document>
                <Page size="A4" style={styles.page}>
                  <View>
                    <Text style={styles.header} fixed>
                      Sistema de Votación - Reina ESPE 2024 - {horaFormato}
                    </Text>
                    <Text style={styles.text}>Sangolquí, {hoyFormato}</Text>
                    <Image style={styles.image} src={Logo} />

                    <View style={styles.section}>
                      <Text style={styles.title}>Proclamación de Ganadoras</Text>
                      <Text style={styles.subtitle}>
                        Hora de Corte del Sistema (GMT-05): {horaFormato}
                      </Text>
                    </View>

                    <React.Fragment>
                      {listaDepartamentos
                        .sort((a, b) => b.CAND_NOTA_FINAL - a.CAND_NOTA_FINAL)
                        .slice(0, 3)
                        .map((reina, index) => (
                          <View
                            style={styles.section_ganadoras}
                            key={reina.CANDIDATA_ID}
                            break={index > 1 ? "page" : undefined}
                          >
                            <View>
                              {index === 0 && (
                                <Text style={styles.title}>Reina ESPE 2024</Text>
                              )}
                              {index === 1 && (
                                <Text style={styles.title}>
                                  Srta. Confraternidad
                                </Text>
                              )}
                              {index === 2 && (
                                <Text style={styles.title}>Srta. Simpatía</Text>
                              )}
                              {reina.ID_ELECCION === 1 && (
                                <Text style={styles.bold}>Candidata Amistad</Text>
                              )}
                              <Text style={styles.title}>
                                {reina.CAND_NOMBRE1} {reina.CAND_APELLIDOPATERNO}
                              </Text>
                              <Text style={styles.subtitle}>
                                {reina.DEPARTMENTO_NOMBRE}
                              </Text>
                              <Text style={styles.tituloreina}>
                                Puntuación Final de: {reina.CAND_NOTA_FINAL}/150
                              </Text>
                            </View>
                          </View>
                        ))}
                    </React.Fragment>

                    <View style={styles.section}>
                      <View style={styles.contenedorColumna}>
                        <View style={styles.section}>
                          <Text style={styles.subtitle}>____________________</Text>
                          <Text style={styles.subtitle}>Veedor</Text>
                          <Text style={[styles.subtitle, styles.bold]}>
                            Dr. Marcelo Mejía Mena
                          </Text>
                          <Text style={styles.subtitle}>CI: 1803061033</Text>
                        </View>
                      </View>
                    </View>
                  </View>
                  <Text
                    style={styles.pageNumber}
                    render={({ pageNumber, totalPages }) =>
                      `Página ${pageNumber} de ${totalPages}`
                    }
                    fixed
                  />
                </Page>
              </Document>
            </PDFViewer>
          </div>
        </div>
      </div>
    );
  } else {
    return (
      <div className="reporte">
        <div className="reporte-contenedor">
          <PDFViewer scale={1} width="1000" height="600">
            <Document>
              <Page size="A4" style={styles.page}>
                <Text style={styles.header} fixed>
                  Sistema de Votación - Reina ESPE 2024
                </Text>
                <View style={styles.section}>
                  <Text style={styles.title}>
                    "No se puede reportar una ganadora. Las votaciones aún no
                    terminan. 
                  </Text>
                  <Image style={styles.image} src={Logo} />
                </View>
              </Page>
            </Document>
          </PDFViewer>
        </div>
      </div>
    );
  }
}

export default Reporte;
