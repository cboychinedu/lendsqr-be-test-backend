// Importing the necessary modules 
const express = require("express"); 
const jwt = require("jsonwebtoken"); 
const { db } = require("../database"); 
const bcrypt = require("bcrypt"); 


// Creating the router object 
const router = express.Router(); 

// Creating the first api route 
router.get("/", (req, res) => {
    // Rendering static data for now 
    return res.send("<h2> Hello from Nodejs </h2>")
})

// Creating the route for registering users 
router.post("/register", async (req, res) => {
    // Getting the user email 
    // Setting the sql statement and check if the user 
    // witht the specified email address already exists on the 
    // database 
    let email = req.body["email"]; 
    let sql_statement = "SELECT firstname, lastname FROM users WHERE email=?"; 
    db.get(sql_statement, [email], async (error, data) => {

        // if there is there is an error 
        if (error) {
            console.log(error)
            // Building the error message 
            let errorMessage = JSON.stringify({
                "status": "error", 
                "message": "Error connecting to the database"
            }); 

            // Sending the message 
            return res.send(errorMessage); 
        } 

        // Else 
        else if (data === undefined) {
            // Getting the request body 
            data = req.body; 

            // Hashing the password 
            let salt = await bcrypt.genSalt(5); 
            let hashedPassword = await bcrypt.hash(data["password"], salt); 

            // Getting the whole data 
            data = [
                data["firstname"], data["lastname"], 
                data["age"], data["email"], hashedPassword,
                data["account_balance"]
            ]; 

            // Inserting into the table 
            let sql_statement = "INSERT INTO users(firstname, lastname, age, email, password, account_balance) VALUES (?, ?, ?, ?, ?, ?)";

            // Running the sql statement 
            db.run(sql_statement, data, (error) => {
                // if there is an error in connection 
                if (error) {
                    // Build the error message 
                    let errorMessage = {
                        "status": "Error", 
                        "message": "Error adding a row", 
                    }; 

                    // Sending the error message 
                    return res.send(errorMessage); 
                }

                // Else on successful connection 
                else {
                    // Execute the block of code below 
                    let successMessage = {
                        "status": "Success", 
                        "message": "1 row added", 
                    }; 

                    // Sending the success message 
                    return res.send(successMessage); 
                }
            })
        }

        // Checking if the data is not empty 
        else if (data != undefined) {
            // If the data exists.  
            let errorMessage = {
                "status": "error", 
                "message": "User already exists", 
                "data": [data]
            }

            // Return the error message
            return res.send(errorMessage);
        }

         
    })
    
})

// Exporting the router 
module.exports = router; 