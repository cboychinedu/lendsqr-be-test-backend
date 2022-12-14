// Creating a function for calculating the amount of money
// left after receiving a func amount
let fundAccountFunction = (accountBalance, fundAmount) => {
    // Converting the string values into floating point values
    accountBalance = Number.parseFloat(accountBalance) || 0.00;
    fundAmount = Number.parseFloat(fundAmount) || 0.00;

    // Creating the new account balance
    let newAccountBalance = accountBalance + fundAmount;

    // Converting the result back to a string 
    newAccountBalance = String(newAccountBalance); 

    // Returning the new account balance
    return newAccountBalance;
}

// Creating a function for calculating the amount of money
// letf after money has left the account
let withdrawAccountFunction = (accountBalance, fundWithdrawn) => {
    // Converting the string values into floating point values
    accountBalance = Number.parseFloat(accountBalance) || 0.00;
    fundWithdrawn = Number.parseFloat(fundWithdrawn) || 0.00; 

    // Getting the result
    if (accountBalance <= fundWithdrawn || accountBalance <= 100 ) {
        return {
            "status": "error",
            "message": "Insufficient funds"
        }
    }

    else {
        // Getting the new account balance, and convert it back 
        // into a string 
        let newAccountBalance = accountBalance - fundWithdrawn;
        newAccountBalance = String(newAccountBalance); 

        // Returning the results 
        return {
            "status": "success",
            "newAccountBalance": newAccountBalance,
            "message": "Successful transaction",
        }
    }
}

// Exporting both functions
module.exports.fundAccountFunction = fundAccountFunction;
module.exports.withdrawAccountFunction = withdrawAccountFunction;
