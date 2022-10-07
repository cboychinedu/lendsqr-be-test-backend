// Importing the necessary modules 
const sqlite3 = require("sqlite3").verbose(); 

// Connecting to the database 
let db = new sqlite3.Database("mydb.db", (error) => {
    if (error) throw error; 

    // Else 
    console.log("Connected to the database"); 
})

// Exporting the database 
module.exports.db = db; 