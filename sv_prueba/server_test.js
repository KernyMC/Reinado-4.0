const express = require('express');
const mysql = require('mysql');
const bodyParser = require('body-parser');

const app = express();
const port = 8801;

app.use(bodyParser.json());

const db = mysql.createConnection({
    host: 'localhost',
    user: 'root',
    password: 'password',
    database: 'reinas_db'
});

db.connect(err => {
    if (err) {
        console.error('Error connecting to the database:', err);
        return;
    }
    console.log('Connected to the database');
});

app.post('/enviarVotoPublico', (req, res) => {
    const { USUARIO_ID, CANDIDATA_ID, EVENTO_ID } = req.body;

    if (!USUARIO_ID || !CANDIDATA_ID || !EVENTO_ID) {
        return res.status(400).send('Missing parameters');
    }

    const query = 'INSERT INTO votos_publicos (usuario_id, candidata_id, evento_id) VALUES (?, ?, ?)';
    db.query(query, [USUARIO_ID, CANDIDATA_ID, EVENTO_ID], (err, result) => {
        if (err) {
            console.error('Error inserting vote:', err);
            return res.status(500).send('Error inserting vote');
        }
        res.send('Vote submitted successfully');
    });
});

app.listen(port, () => {
    console.log(`Server running on port ${port}`);
});
