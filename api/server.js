const express = require("express");
const app = express();
const cors = require('cors');
var mysql = require('mysql');

app.use(cors());

var con = mysql.createConnection({
  host: process.env.DB_HOST,
  user: process.env.DB_USER,
  password: process.env.DB_PASS,
  database: "plantshop"
});

app.get('/', (req, res)=> {
  con.query("SELECT * FROM items", function (err, result, fields) {
    if (err) throw err;
    res.json({items: result.map(v => Object.assign({}, v))});
  });
});

app.listen(8080, ()=> console.log("App is running on port 8080"));
