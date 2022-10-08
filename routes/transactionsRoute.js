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
    // Getting the email, and password
    let email = req.body.email;
    let password = req.body.password;
    let new_funds = req.body.amount;

    // Verifying if the user exists on the database
    let sql_statement = "SELECT firstname, lastname, password, email, account_balance FROM users WHERE email=?";
    db.get(sql_statement, [email], async (error, data) => {
        // If there is an error
        if (error) {
            // Build the error messsage
            let errorMessage = {
                "status": "error",
                "message": "Error connecting to the database"
            };

            // Sending the error message
            return res.send(errorMessage);
        }

        // Else if the data is undefined
        else if (data === undefined) {
            // This means that the user is not registered
            let errorMessage = {
                "status": "error",
                "message": "User not found"
            }

            // Return the error message
            return res.send(errorMessage);
        }

        // Else if the data is not empty
        else if (data != undefined) {
            // If the user exists on the server, hash the password and
            // verify the user
            let hashedPassword = data["password"];
            let passwordCondition = await bcrypt.compare(password, hashedPassword);

            // Checking if the condition resolved to true or false 
            if (passwordCondition) {
                // If the password condition is true, execute the block of 
                // code below 
                // Get the total sum of the accountbalance and the fund amount 
                let accountTotal = fundAccountFunction(data["account_balance"], new_funds)

                // Create an sql statement to update the funds for the 
                // specified account
                let updatedData = [accountTotal, email] 
                sql_statement = "UPDATE users SET account_balance=? WHERE email=?";
                db.run(sql_statement, updatedData, (error) => {
                    // If there is an error 
                    if (error) {
                        // Log the error 
                        console.log(error); 
                    }

                    // else 
                    else {
                        // Create a success message 
                        let successMessage = {
                            "status": "success", 
                            "message": "Funds updated"
                        }

                        // Sending back the success message 
                        return res.send(successMessage); 
                    }
                }) 
            }

            // Else if the condition was false 
            else {
                // If the condition resulted to false 
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

// Creating a route for transferring funds to another account
router.post("/transfer-funds", (req, res) => {
    // Getting the data for destination and sender 
    let destination = {
        "emailAddress": req.body.destination_email,
        "amountentering": req.body.amount
    }

    let sender = {
        "emailAddress": req.body.sender_email,
        "amountleaving": req.body.amount, 
        "password": req.body.sender_password, 
    }

    // Checking if the sender-user exists on the database 
    let sql_statement = "SELECT firstname, lastname, password, account_balance FROM users WHERE email=?"; 
    db.get(sql_statement, [sender["emailAddress"]], async(error, data) => {
        // If there is an error 
        if (error) {
            // Building the error message 
            let errorMessage = {
                "status": "error", 
                "message": "Error connecting to the database", 
            }; 

            // Sending the error message 
            return res.send(errorMessage); 
        }

        // Else if the data is undefined 
        else if (data === undefined) {
            // This means that the user is not registered, build 
            // a response message 
            let errorMessage = {
                "status": "error", 
                "message": "User not found"
            }; 

            // Sending the error message 
            return res.send(errorMessage); 
        }

        // Else if the data is not empty 
        else if (data != undefined) {
            // If the user exists on the server, hash the password and 
            // verify 
            let hashedPassword = data["password"]; 
            let passwordCondition = await bcrypt.compare(sender["password"], hashedPassword); 

            // Checking if the condition resolves to true, or false 
            if (passwordCondition) {
                // If the password is correct 
                // Deduct the amount leaving from the sender account 
                // Add the amount to the receiver account 


                
            }
            
        }
    })



})

// Creating a route for withdrawing funds from an account
router.post("/withdraw-funds", (req, res) => {
    //
    return res.send("<h2> Withdraw funds from account </h2>")
})


// Exporting the route
module.exports = router;
