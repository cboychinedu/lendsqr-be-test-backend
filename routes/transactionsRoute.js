// Importing the necessary modules 
const express = require("express"); 
const jwt = require("jsonwebtoken"); 
const { db } = require("../database"); 
const bcrypt = require("bcrypt"); 
const { 
    fundAccountFunction,
    withdrawAccountFunction } = require('../algorithm/algorithm'); 

// Creating the router object 
const router = express.Router(); 

// Creating the first route 
router.post("/get-funds", async (req, res) => {
    // Getting the email, and password 
    let email = req.body.email; 
    let password = req.body.password;  

    // Verifying if the user exists on the database 
    let sql_statement = "SELECT firstname, lastname, password, account_balance FROM users WHERE email=?"; 
    db.get(sql_statement, [email], async(error, data) => {
        // If there is an error 
        if (error) {
            // Building the error message 
            let errorMessage = {
                "status": "error", 
                "message": "Error connecting to the database"
            }; 

            // Sending the error message 
            return res.send(errorMessage); 
        }

        // Else if the data is undefined 
        else if (data === undefined) {
            // This means that the user is not registered , build 
            // a response message 
            let errorMessage = {
                "status": "error", 
                "message": "User not found"
            }

            // Sending the error message 
            return res.send(errorMessage); 
        }

        // Else if the data is not empty 
        else if (data != undefined) {
            // If the user exists on the server, hash the password and 
            // verify 
            let hashedPassword = data["password"]
            let passwordCondition = await bcrypt.compare(password, hashedPassword); 

            console.log(passwordCondition); 

            // Checking if the condition resolves to true, or false 
            if (passwordCondition) {
                // If the password is true 
                let successMessage = {
                    "status": "success", 
                    "message": "User verified", 
                    "accountBalance": data["account_balance"]
                }

                // Sending the result back to the user 
                return res.send(successMessage); 
            }

            // Else if the condition was false 
            else {
                // IF the condition resulted to false 
                let errorMessage = {
                    "status": "error", 
                    "message": "Incorrect username or password",
                }

                // Sending the result back to the user 
                return res.send(errorMessage); 
            }
        } 
    }) 
    

})

// Creating route for updating the account balance 
router.post("/update-funds", (req, res) => {
    // 
    return res.send("<h2> Route for updating/funding the account </h2>")
})

// Creating a route for transferring funds to another account 
router.post("/transfer-funds", (req, res) => {
    // 
    let destination = {
        "emailAddress": "", 
        "amountentering": ""
    } 
    let sender = {
        "emailAddress": "", 
        "amountleaving": ""
    }
    return res.send("<h2> Route for transferring funds. </h2>")
})

// Creating a route for withdrawing funds from an account 
router.post("/withdraw-funds", (req, res) => {
    // 
    return res.send("<h2> Withdraw funds from account </h2>")
})


// Exporting the route 
module.exports = router; 