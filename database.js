// Importing the necessary modules 
const path = require("path"); 
const sqlite3 = require("sqlite3").verbose(); 
const winston = require("winston"); 

// Getting the base path "rootpath" 
let root_path = path.join(__dirname); 

// Setting the token password 
const tokenPassword = process.env.token_pass || "54346512#9^&$#%#@_*+=</<.)_+^$#!!";

// Creating a function for getting the date
const dateTimeStamp = () => {
    // Execute this block of code to get the dateTimeStampValues
    let dateTimeStampValues = Date();
    let params = {};
    let timeStampValues, timeStampValuesArray, year, month, monthDay, day, hour, minutes, seconds;

    // Splitting by the "GMT" string and extracting the time stamp values
    // And remove unwanted space
    dateTimeStampValues = dateTimeStampValues.split("GMT");
    dateTimeStampValues = dateTimeStampValues[0].trim();

    // Splitting the dateTimeStampValues into simpler date formats
    dateTimeStampValues = dateTimeStampValues.split(" ");
    params.monthDay = dateTimeStampValues[0];
    params.month = dateTimeStampValues[1];
    params.day = dateTimeStampValues[2];
    params.year = dateTimeStampValues[3];

    // Splitting the dateTimeStampValues into simpler time formats
    timeStampValues = dateTimeStampValues[dateTimeStampValues.length -1];
    timeStampValuesArray = timeStampValues.split(":");
    params.hour = timeStampValuesArray[0];
    params.minutes = timeStampValuesArray[1];
    params.seconds = timeStampValuesArray[2];

    // Creating a time object, then return it
    return params;
}

// Creating the winston logger object for logging 
const logger = winston.createLogger({
    format: winston.format.json(), 
    defaultMeta: { service: "lendsqr" }, 
    transports: [
        new winston.transports.File({ filename: "./logs/errorLog.log", level: "error"}), 
        new winston.transports.File({ filename: "./logs/GeneralLog.log", level: "info"}), 
        new winston.transports.File({ filename: "./logs/successfulTransactions.log", level: "info"}), 
    ]
}); 

// Creating the logging middleware 
const loggingRequest = (req, res, next) => {
  // logging the request by getting all the necessary data needed for logging
  let rawHeaders = req.rawHeaders;
  let ip_address = req.client._peername.address;
  let addressFamily = req.client._peername.family;
  let addressPort = req.client._peername.port;
  let url = req.originalUrl;
  let requestMethod = req.method;

  // Working on the request time, to make it more simplified
  // Getting the request time, and split further into year, month, day,
  // hour, mins, secs.
  let requestTime = String(req._startTime);
  let params = dateTimeStamp();

  // Getting the User-Agent
  rawHeaders = Number(rawHeaders.indexOf("User-Agent"));
  rawHeaders = rawHeaders +  1;
  let userAgent = req.rawHeaders[rawHeaders];

  // Logging
  logger.log({
    level: 'info',
    message: `${requestTime + ', ' + params.year + ', ' + params.month + ', ' + params.day + ', ' +
                params.monthDay + ', ' + params.hour + ', ' + params.minutes + ', ' + params.seconds + ', ' +
                requestMethod + ', ' + ip_address + ':' + addressPort + ' , ' + url + ' , ' +
                addressFamily + ' , ' + userAgent + ' , ' + rawHeaders}`,
  });


  // Move on to the next middleware
  next();
}

// Creating an error logger for logging the error encountered on connection 
// to the sqlite database 
const errorLogger = (errorMessage, req, res) => {
    // Getting the request errors 
    let rawHeaders = req.rawHeaders; 
    let ip_address = req.client._peername.address; 
    let requestMethod = req.method; 
    let url = req.originalUrl; 
    let userAgent = req.rawHeaders[rawHeaders]; 
    let firstname = `Firstname: ${req.body.firstname}` || ""; 
    let lastname = `Lastname: ${req.body.lastname}` || ""; 
    let email = `Email: ${req.body.email}` || ""; 
    let account_balance = `Account Balance: ${req.body.account_balance}` || ""; 
    let amount = `Amount: ${req.body.amount}` || ""; 
    let sender_email = `SenderEmail: ${req.body.sender_email}` || ""; 
    let destination_email = `Destination Email: ${req.body.destination_email}` || ""; 
    let status = `Status: ${req.body.status}`; 

    // Working on the request time, to make it more simplified
    // Getting the request time, and split further into year, month, day,
    // hour, mins, secs.
    let requestTime = String(req._startTime);
    let params = dateTimeStamp();

    // Logging the error message 
    logger.log({
        level: "error", 
        message: `${
            requestTime + ', ' + params.year + ',' + params.month + ', ' + params.day + ',' + 
            params.monthDay + ', ' + params.hour + ', ' + params.minutes + ', ' + params.second + ', ' + 
            requestMethod + ', ' + ip_address + ', ' + url + ', ' + userAgent + ', ' + firstname + ', ' +
            lastname + ', ' + email + ', ' + account_balance + ', ' + amount + ', ' + sender_email + ', ' + 
            destination_email + ', ' + status + ', ' + errorMessage
                
        }`
    }); 
}

// Creating a logger for logging the successful transaction 
const successfulTransaction = (req, res) => {
    // Getting the request errors 
    let rawHeaders = req.rawHeaders; 
    let ip_address = req.client._peername.address; 
    let requestMethod = req.method; 
    let url = req.originalUrl; 
    let userAgent = req.rawHeaders[rawHeaders]; 
    let firstname = `Firstname: ${req.body.firstname}` || ""; 
    let lastname = `Lastname: ${req.body.lastname}` || ""; 
    let email = `Email: ${req.body.email}` || ""; 
    let account_balance = `Account Balance: ${req.body.account_balance}` || ""; 
    let amount = `Amount: ${req.body.amount}` || ""; 
    let sender_email = `SenderEmail: ${req.body.sender_email}` || ""; 
    let destination_email = `Destination Email: ${req.body.destination_email}` || ""; 
    let status = `Status: ${req.body.status}`; 

    // Working on the request time, to make it more simplified
    // Getting the request time, and split further into year, month, day,
    // hour, mins, secs.
    let requestTime = String(req._startTime);
    let params = dateTimeStamp();

    // Logging the error message 
    logger.log({
        level: "info", 
        message: `${
            requestTime + ', ' + params.year + ',' + params.month + ', ' + params.day + ',' + 
            params.monthDay + ', ' + params.hour + ', ' + params.minutes + ', ' + params.second + ', ' + 
            requestMethod + ', ' + ip_address + ', ' + url + ', ' + userAgent + ', ' + firstname + ', ' +
            lastname + ', ' + email + ', ' + account_balance + ', ' + amount + ', ' + sender_email + ', ' + 
            destination_email + ', ' + status
                
        }`
    });
}

// Connecting to the database 
let db = new sqlite3.Database("mydb.db", (error) => {
    if (error) throw error; 

    // Else 
    console.log("Connected to the database"); 
})

// Exporting the database 
module.exports.root_path = root_path; 
module.exports.db = db; 
module.exports.tokenPassword = tokenPassword; 
module.exports.errorLogger = errorLogger; 
module.exports.loggingRequest = loggingRequest; 
module.exports.successfulTransaction = successfulTransaction; 