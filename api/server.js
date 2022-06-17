const express = require("express");
const app = express();
const cors = require('cors');
var mysql = require('mysql');

app.use(cors());

var connection = mysql.createConnection({
    host: process.env.DB_HOST,
    user: process.env.DB_USER,
    password: process.env.DB_PASS,
    database: "plantshop",
});

app.get('/', (req, res, next)=> {
    connection.query('select * from items', function (error, results, fields) {
        if (error) {
            connection.destroy();
            throw error;
        } else {
            // connected!
            console.log("Query result:");
            console.log(results);
            if (error) {
                next (error);
            } else {
                res.json({items: results.map(v => Object.assign({}, v))});
            }
        }
    });
});

app.listen(8080, ()=> console.log("App is running on port 8080"));
