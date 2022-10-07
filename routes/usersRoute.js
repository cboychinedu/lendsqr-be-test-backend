// Importing the necessary modules 
const express = require("express"); 
const jwt = require("jsonwebtoken"); 
const { db } = require("../database"); 


// Creating the router object 
const router = express.Router(); 

// Creating the first api route 
router.get("/", (req, res) => {
    // Rendering static data for now 
    return res.send("<h2> Hello from Nodejs </h2>")
})

// Creating the route for registering users 
router.post("/register", (req, res) => {
    // Getting the data 
    data = req.body; 
    data = [data["firstname"], data["lastname"], data["age"], data["email"], data["password"], data["account_balance"]]

    // Inserting into the table 
    let sql_statement = "INSERT INTO users(firstname, lastname, age, email, password, account_balance) VALUES (?, ?, ?, ?, ?, ?)"; 
    db.run(sql_statement, data, (error) => {
        if (error) {
            console.log(error); 
            // Return the error 
            let errorMessage = JSON.stringify({
                "status": "error", 
                "message": "Error adding row", 
            })
            return res.send(errorMessage)
        }

        // Else 
        let successMessage = JSON.stringify({
            "status": "success", 
            "message": "1 row added"
        })

        return res.send(successMessage); 
    })
})

// Exporting the router 
module.exports = router; 