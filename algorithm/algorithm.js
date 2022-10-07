// Creating a function for calculating the amount of money 
// left after receiving a func amount 
let fundAccountFunction = (accountBalance, fundAmount) => {
    // Converting the string values into floating point values 
    accountBalance = Number.parseFloat(accountBalance); 
    fundAmount = Number.parseFloat(fundAmount); 

    // Creating the new account balance 
    let newAccountBalance = accountBalance + fundAmount; 

    // Returning the new account balance 
    return newAccountBalance; 
}

// Creating a function for calculating the amount of money 
// letf after money has left the account 
let withdrawAccountFunction = (accountBalance, fundWithdrawn) => {
    // Converting the string values into floating point values 
    accountBalance = Number.parseFloat(accountBalance); 
    fundWithdrawn = Number.parseFloat(fundWithdrawn); 

    // Getting the result 
    if (accountBalance <= fundWithdrawn && accountBalance <= 1000.0 ) {
        return "Insufficient funds"
    }

    else {
        let newAccountBalance = accountBalance - fundWithdrawn; 
        return newAccountBalance; 
    }
}

// Exporting both functions 
module.exports.fundAccountFunction = fundAccountFunction; 
module.exports.withdrawAccountFunction = withdrawAccountFunction; 