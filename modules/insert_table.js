// Importing the necessary modules 
const sqlite3 = require("sqlite3").verbose(); 

let db = new sqlite3.Database("mydatabase.db", (error) => {
    if (error) {console.log(error.message); }

    console.log("Connected to the database"); 
})

// Setting the data 
data = ["Alan", "Moth", "27", "alansmith@gmail.com", "123554", "0.00"]

// Inserting into the table 
let sql_statement = "INSERT INTO users(firstname, lastname, age, email, password, account_balance) VALUES (?, ?, ?, ?, ?, ?)"
db.run(sql_statement, data, (error) => {
    if (error) { console.log(error); }

    console.log("Success")
})



// db.run('INSERT INTO users(name, age) VALUES(?, ?)', ['Raiko',29], (err) => {
// 	if(err) {
// 		return console.log(err.message); 
// 	}
// 	console.log('Row was added to the table: ${this.lastID}');
// })