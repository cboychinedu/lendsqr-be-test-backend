// Importing the necessary modules
const express = require("express");
const jwt = require("jsonwebtoken");
const { 
    db, 
    errorLogger, 
    loggingRequest, 
    successfulTransaction
} = require("../database");
const bcrypt = require("bcrypt");
const {
    fundAccountFunction,
    withdrawAccountFunction 
} = require('../algorithm/algorithm');

// Creating the router object
const router = express.Router();

// Creating the first route
router.post("/get-funds", loggingRequest, async (req, res) => {
    // Getting the email, and password
    let email = req.body.email;
    let password = req.body.password;

    // Verifying if the user exists on the database
    let sql_statement = "SELECT firstname, lastname, password, account_balance FROM users WHERE email=?";
    db.get(sql_statement, [email], async(error, data) => {
        // If there is an error
        if (error) {
            // Logging the error 
            errorLogger(error, req, res); 

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

            // Logging the error 
            errorLogger(errorMessage["message"], req, res); 

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

                // Logging the success message 
                successfulTransaction(req, res); 

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

                // Logging the error message 
                errorLogger(errorMessage["message"], req, res); 

                // Sending the result back to the user
                return res.send(errorMessage);
            }
        }
    })


})

// Creating route for updating the account balance
router.post("/update-funds", loggingRequest, async(req, res) => {
    // Getting the email, and password
    let email = req.body.email;
    let password = req.body.password;
    let new_funds = req.body.amount || 0.00;

    // Verifying if the user exists on the database
    let sql_statement = "SELECT firstname, lastname, password, email, account_balance FROM users WHERE email=?";
    db.get(sql_statement, [email], async (error, data) => {
        // If there is an error
        if (error) {
            // Logging the error 
            errorLogger(error, req, res); 

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

            // Logging the error message 
            errorLogger(errorMessage["message"], req, res); 

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
                let accountBalance = data["account_balance"] || "0.00"; 
                let accountTotal = fundAccountFunction(accountBalance, new_funds)

                // Create an sql statement to update the funds for the 
                // specified account
                let updatedData = [accountTotal, email] 
                sql_statement = "UPDATE users SET account_balance=? WHERE email=?";
                db.run(sql_statement, updatedData, (error) => {
                    // If there is an error 
                    if (error) {
                        // Log the error 
                        errorLogger(error, req, res); 

                        // Building the error message 
                        let errorMessage = JSON.stringify({
                            "status": "error", 
                            "message": "Error connecting to the database"
                        }); 

                        // Sending the message 
                        return res.send(errorMessage); 
                    }

                    // else 
                    else {
                        // Create a success message 
                        let successMessage = {
                            "status": "success", 
                            "message": "Funds updated", 
                            "amount": new_funds, 
                            "balance": accountTotal, 
                        }

                        // Logging the success message 
                        successfulTransaction(req, res); 

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

                // Logging the error message 
                errorLogger(errorMessage["message"], req, res); 

                // Sending the result back to the user 
                return res.send(errorMessage); 
            }
        }
    })
})

// Creating a route for transferring funds to another account
router.post("/transfer-funds", loggingRequest, async (req, res) => {
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
    db.get(sql_statement, [sender["emailAddress"]], async(error, sender_data) => {
        // If there is an error 
        if (error) {
            // Logging the error 
            errorLogger(error, req, res); 

            // Building the error message 
            let errorMessage = {
                "status": "error", 
                "message": "Error connecting to the database", 
            }; 

            // Sending the error message 
            return res.send(errorMessage); 
        }

        // Else if the data is undefined 
        else if (sender_data === undefined) {
            // This means that the user is not registered, build 
            // a response message 
            let errorMessage = {
                "status": "error", 
                "message": "User not found"
            }; 

            // Logging the error 
            errorLogger(errorMessage["message"], req, res); 

            // Sending the error message 
            return res.send(errorMessage); 
        }

        // Else if the data is not empty 
        else if (sender_data != undefined) {
            // If the user exists on the server, hash the password and 
            // verify 
            let hashedPassword = sender_data["password"]; 
            let passwordCondition = await bcrypt.compare(sender["password"], hashedPassword); 

            // Checking if the condition resolves to true, or false 
            if (passwordCondition) {
                // If the password is correct, check if the receiver email is on the database 
                let sql_statement = "SELECT firstname, lastname, account_balance FROM users WHERE email=?"; 
                db.get(sql_statement, [destination["emailAddress"]], async (error, destination_data) => {
                    // If there is an error 
                    if (error) {
                        // Building the error message 
                        let errorMessage = {
                            "status": "error", 
                            "message": "Error connecting to the database"
                        }; 

                        // Log the error 
                        errorLogger(error, req, res); 
                        errorLogger(errorMessage["message"], req, res); 

                        // Sending the error message 
                        return res.send(errorMessage); 
                    }

                    // ELse if the data is undefined 
                    else if (destination_data === undefined) {
                        // This means that the user is not registered, build a response message 
                        let errorMessage = {
                            "status": "error", 
                            "message": "Destination email not found on the server", 
                        }; 

                        // Log the error 
                        errorLogger(errorMessage["message"], req, res); 

                        // Sending the error message 
                        return res.send(errorMessage); 
                    }

                    // Else if the data is not empty 
                    else if (destination_data != undefined) {
                        // Deduct the amount leaving the sender account 
                        let deductedValues = withdrawAccountFunction(sender_data["account_balance"], sender["amountleaving"])

                        // Checking if the money deduction was correct 
                        if (deductedValues["status"] === "success") {
                            // Execute this block of code if the deduction was successful 
                            // Create an sql statement to save the deducted value into the sender account 
                            let updatedData = [deductedValues["newAccountBalance"], sender["emailAddress"]]
                            let sql_statement = "UPDATE users SET account_balance=? WHERE email=?"; 
                            db.run(sql_statement, updatedData, (error) => {
                                // If there is an error 
                                if (error) {
                                    // Building the error message 
                                    let errorMessage = {
                                        "status": "error", 
                                        "message": "Error connecting to the database", 
                                    }; 

                                    // Logging the error 
                                    errorLogger(error, req, res); 

                                    // Sending the error message 
                                    return res.send(errorMessage);  
                                }

                                // Else if the connectin was successful 
                                else {
                                    // Update the receiver account
                                    let newSenderAccountBalance = fundAccountFunction(destination_data["account_balance"], destination["amountentering"]); 

                                    // Create an sql statement to update the funds for the sender account 
                                    newSenderAccountBalance = String(newSenderAccountBalance); 
                                    let updatedData = [newSenderAccountBalance, destination["emailAddress"]]; 
                                    sql_statement = "UPDATE users SET account_balance=? WHERE email=?"; 
                                    db.run(sql_statement, updatedData, (error) => {
                                        // If there is an error 
                                        if (error) {
                                            // Building the error message 
                                            let errorMessage = {
                                                "status": "error", 
                                                "message": "Error connecting to the database", 
                                            }; 

                                            // Logging the error 
                                            errorLogger(error, req, res); 

                                            // Sending the error message 
                                            return res.send(errorMessage); 

                                        }

                                        // Else 
                                        else {
                                            // Create a success message 
                                            let successMessage = {
                                                "status": "success", 
                                                "message": "Transfer successful", 
                                                "amountSent": destination["amountentering"]
                                            }

                                            // Logging the success message 
                                            successfulTransaction(req, res); 

                                            // Sending back the success message 
                                            return res.send(successMessage); 
                                        }
                                    })
                                }
                            })
                        }

                        // Else 
                        else if (deductedValues["status"] === "error") {
                            // Logging the error 
                            errorLogger(deductedValues["message"], req, res); 

                            // Get the error message 
                            return res.send(deductedValues)
                        }
                    }
                })
                
            }
            
        }
    })

})

// Creating a route for withdrawing funds from an account
router.post("/withdraw-funds", loggingRequest, async (req, res) => {
    // Getting the emal, password, and amount to be withdrawn 
    let email = req.body.email; 
    let password = req.body.password; 
    let amount = req.body.amount || 0.00; 

    // Verifying if the user exists on the database 
    let sql_statement = "SELECT firstname, lastname, password, account_balance FROM users WHERE email=?"; 
    db.get(sql_statement, [email], async (error, data) => {
        // If there is an error 
        if (error) {
            // Logging the error 
            errorLogger(error, req, res); 

            // Build the error message 
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
            }; 

            // Logging the error 
            errorLogger(errorMessage["message"], req, res); 

            // Sending the error message 
            return res.send(errorMessage); 
        }

        // Else if the data is not empty 
        else if (data != undefined) {
            // If the user exists on the server, verify the hashed password 
            let hashedPassword = data["password"]; 
            let passwordCondition = await bcrypt.compare(password, hashedPassword); 

            // Checking if the condition resolved to true or false 
            if (passwordCondition) {
                // Deduct the amount from the account total 
                let accountBalance = data["account_balance"] || 0.00; 
                let accountTotal = withdrawAccountFunction(accountBalance, amount); 

                // Checking if the money deduction was validated
                if (accountTotal["status"] === "success") {
                    // Execute this block of code if the deduction was successful 
                    // Create an sql statement to update the funds for the specified account 
                    let newAccountBalance = String(accountTotal["newAccountBalance"]); 
                    let updatedData = [newAccountBalance, email] 
                    sql_statement = "UPDATE users SET account_balance=? WHERE email=?"; 
                    db.run(sql_statement, updatedData, (error) => {
                        // If there is an error 
                        if (error) {
                            // Log the error 
                            errorLogger(error, req, res); 

                            // Building the error message 
                            let errorMessage = JSON.stringify({
                                "status": "error", 
                                "message": "Error connecting to the database"
                            }); 

                            // Sending the message 
                            return res.send(errorMessage); 
                        }

                        // Else if there was successful updating 
                        else {
                            // Create the success message 
                            let successMessage = {
                                "status": "success", 
                                "message": "Funds Withdrawn", 
                                "Amount": amount, 
                                "Account Balance": accountTotal["newAccountBalance"]
                            }

                            // Logging the successful transaction 
                            successfulTransaction(req, res); 

                            // Sending back the success message 
                            return res.send(successMessage); 
                        }
                    })

                }

                // Else if the funds is insufficient 
                else if (accountTotal["status"] === "error") {
                    // Logging the error 
                    errorLogger(accountTotal["message"], req, res); 

                    // Get the error message 
                    return res.send(accountTotal); 
                }
            }

            // Else if the password was not correct 
            else {
                // Execute the block of code if the password given was 
                // not correct 
                // Build the error message 
                let errorMessage = {
                    "status": "error", 
                    "message": "Incorrect username or password", 
                }

                // Logging the error 
                errorLogger(errorMessage["message"], req, res); 

                // Sending the result back to the user 
                return res.send(errorMessage); 
            }
        }
    })
})


// Exporting the route
module.exports = router;
