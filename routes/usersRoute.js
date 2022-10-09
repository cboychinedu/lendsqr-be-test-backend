// Importing the necessary modules 
const path = require("path"); 
const express = require("express"); 
const jwt = require("jsonwebtoken"); 
const { 
    db, 
    errorLogger, 
    loggingRequest, 
    successfulTransaction,
    root_path
} = require("../database"); 
const bcrypt = require("bcrypt"); 


// Creating the router object 
const router = express.Router(); 

// Creating the first api route 
router.get("/", (req, res) => {
    // Getting the full path to the home url 
    let full_path = path.join(root_path, 'static', 'templates', 'home.ejs')

    // Rendering static data for now 
    return res.render(full_path); 

})

// Creating the route for registering users 
router.post("/register", loggingRequest, async (req, res) => {
    // Getting the user email 
    // Setting the sql statement and check if the user 
    // witht the specified email address already exists on the 
    // database 
    let email = req.body["email"]; 
    let sql_statement = "SELECT firstname, lastname FROM users WHERE email=?"; 
    db.get(sql_statement, [email], async (error, data) => {

        // if there is there is an error 
        if (error) {
            // Logging the error 
            errorLogger(error, req, res); 

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
            let account_balance = data["account_balance"] || 0.00; 
            // Getting the whole data 
            data = [
                data["firstname"], data["lastname"], 
                data["age"], data["email"], hashedPassword,
                account_balance
            ]; 

            // Inserting into the table 
            let sql_statement = "INSERT INTO users(firstname, lastname, age, email, password, account_balance) VALUES (?, ?, ?, ?, ?, ?)";

            // Running the sql statement 
            db.run(sql_statement, data, (error) => {
                // if there is an error in connection 
                if (error) {
                    // Log the error 
                    errorLogger(error, req, res); 

                    // Build the error message 
                    let errorMessage = {
                        "status": "Error", 
                        "message": "Error adding user", 
                    }; 

                    // Sending the error message 
                    return res.send(errorMessage); 
                }

                // Else on successful connection 
                else {
                    // Execute the block of code below 
                    let successMessage = {
                        "status": "Success", 
                        "message": "User added", 
                    }; 

                    // Logging the successful transaction
                    successfulTransaction(req, res); 

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

            // Logging the error 
            errorLogger(errorMessage["message"], req, res); 

            // Return the error message
            return res.send(errorMessage);
        }

         
    })
    
})

// Exporting the router 
module.exports = router; 