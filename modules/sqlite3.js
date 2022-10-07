// Importing the necessary modules 
const sqlite3 = require("sqlite3").verbose(); 

let db = new sqlite3.Database("mydatabase.db", (error) => {
    if (error) {console.log(error.message); }

    console.log("Connected to the database"); 
})