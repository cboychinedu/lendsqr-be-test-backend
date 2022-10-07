// Importing the necessary modules 
const sqlite3 = require("sqlite3").verbose(); 

let db = new sqlite3.Database("mydatabase.db", (error) => {
    if (error) {console.log(error.message); }

    console.log("Connected to the database"); 
})

// db.serialize(() => {
//     // Creating a table 
//     db.run("create table users ( firstname TEXT, lastname TEXT, age INT, email TEXT, password TEXT)")
  
// })

// Creating a table 
db.run("create table users (firstname TEXT, lastname TEXT, age TEXT, email TEXT, password TEXT, account_balance TEXT)")
db.close(); 


 

