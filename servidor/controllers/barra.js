import { db } from "../db.js"
import jwt from "jsonwebtoken";

export const getCandidatas = (req, res) => {
    const sqlSelect = "SELECT  ca.CANDIDATA_ID,ca.CAND_NOMBRE1, ca.CAND_APELLIDOPATERNO,dpto.DEPARTAMENTO_SEDE,dpto.DEPARTMENTO_NOMBRE, fc.FOTO_URL FROM candidata ca join carrera car join departamento dpto join foto_candidata fc on ca.CANDIDATA_ID = fc.CANDIDATA_ID and ca.CARRERA_ID = car.CARRERA_ID and dpto.DEPARTAMENTO_ID = car.DEPARTAMENTO_ID and fc.FOTO_DESCRIPCION = 'FX';"

    db.query(sqlSelect, (err, data) => {
        if (err) return res.status(500).json(err);
        //console.log(data);
        return res.status(200).json(data);
    });
}

export const getCandidatasFotos = (req, res) => {
    const sqlSelect = "SELECT  ca.CAND_NOMBRE1, ca.CAND_APELLIDOPATERNO, dpto.DEPARTAMENTO_SEDE, fc.FOTO_URL FROM candidata ca join carrera car join departamento dpto join foto_candidata fc on ca.CANDIDATA_ID = fc.CANDIDATA_ID and ca.CARRERA_ID = car.CARRERA_ID and dpto.DEPARTAMENTO_ID = car.DEPARTAMENTO_ID;";
    db.query(sqlSelect, (err, result) => {
        if (err)
            console.log(err);
        //console.log(result);
        res.send(result)
    })
}
export const postBarras = (req, res) => {
    const token = req.cookies.access_token
    if (!token) return res.status(401).json("No autenticado!")

    jwt.verify(token, "jwtkey", (err, userInfo) => {
        if (err) return res.status(403).json("Token no es valido!");

        const q = "INSERT INTO calificacion(`EVENTO_ID`, `USUARIO_ID`, `CANDIDATA_ID`, `CALIFICACION_NOMBRE`, `CALIFICACION_PESO`, `CALIFICACION_VALOR`) VALUES (?)";
        for (var i = 0; i < 10; i++) {
            const values = [
                req.body.EVENTO_ID,
                userInfo.id,
                1 + i,
                req.body.CALIFICACION_NOMBRE,
                req.body.CALIFICACION_PESO,
                2 * Number(req.body.notas[i]), //Hay que multiplicar por 2 para que sea sobre 10
            ];
            db.query(q, [values], (err, data) => {
                if (err) return res.status(500).json(err);
            });
        }
    });
}

export const getEstadoEvento = (req, res) => {
    const sqlSelect = "SELECT EVENTO_ID,EVENTO_ESTADO FROM evento";
    db.query(sqlSelect, (err, result) => {
        if (err)
            console.log(err);
        //console.log(result);
        res.send(result)
    })
}


export const verificarEstadoEventoPublico = (req, res) => {
    const eventoId = 4; // ID del evento público
    const sqlSelect = "SELECT EVENTO_ESTADO FROM evento WHERE EVENTO_ID = ?";
    db.query(sqlSelect, [eventoId], (err, result) => {
        if (err) return res.status(500).json(err);
        res.status(200).json(result[0]);
    });
};
