var mysql = require('mysql');

exports.handler = (event, context, callback) => {

    var connection = mysql.createConnection({
        host: process.env.DB_HOST,
        user: process.env.DB_USER,
        password: process.env.DB_PASS,
        database: "plantshop",
    });

    connection.query('select * from items', function (error, results, fields) {
        if (error) {
            connection.destroy();
            throw error;
        } else {
            // connected!
            console.log("Query result:");
            console.log(results);
            callback(error, {items: results});
            connection.end(function (err) { callback(err, results);});
        }
    });
};
