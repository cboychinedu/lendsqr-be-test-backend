// Importing the necessary modules 
const sqlite3 = require("sqlite3").verbose(); 

// Connecting to the database 
let db = new sqlite3.Database("mydb.db", (error) => {
    // If there is an error 
    if (error) throw error; 
    
    // Else, 
    console.log("Connected to the database"); 
})

// Using the database 
// Setting the sql statement 
let sql_statement = "SELECT * FROM users WHERE email=?"; 
let email = "alansmith@gmail.com"; 

// Running the query 
db.get(sql_statement, [email], (error, data) => {
    // If there is an error 
    if (error) {
        // Execute this block of code if there is an error 
        console.log(error); 
    }

    // Else, save the query inside a list
    if (data === undefined) {
        console.log("Data not present")
    }
    

    else {
        console.log("Data present")
    }
})
