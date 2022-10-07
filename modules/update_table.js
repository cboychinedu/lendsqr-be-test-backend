// Importing the necessary modules 
const sqlite3 = require("sqlite3").verbose(); 

let db = new sqlite3.Database("mydb.db", (error) => {
    if (error) {console.log(error.message); }

    console.log("Connected to the database"); 
})

// Creating the data to be updated 
let updatedData = ["200.00", "alansmith@gmail.com"]; 

// Creating the sql statement 
let sql_statement = "UPDATE users SET account_balance=? WHERE email=?"; 

// Running the database 
db.run(sql_statement, updatedData, (error) => {
    if (error) {console.log(error)}

    // 
    console.log("Row updated"); 
})

// Closing 
db.close(); 