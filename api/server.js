const express = require("express");
const app = express();
const cors = require('cors');
var mysql = require('mysql');

app.use(cors());

var pool = mysql.createPool({
  host: process.env.DB_HOST,
  user: process.env.DB_USER,
  password: process.env.DB_PASS,
  database: "plantshop"
});

app.get('/', (req, res)=> {
  pool.getConnection(function(err, connection) {
    if (err) throw err;
    connection.query("SELECT * FROM items", function (error, result, fields) {
      connection.release();
      if (error) throw error;
      res.json({items: result.map(v => Object.assign({}, v))});
    });
  });
});

app.listen(8080, ()=> console.log("App is running on port 8080"));
