// Importing the necessary modules 
const express = require("express"); 
const cookieParser = require("cookie-parser"); 
const bodyParser = require("body-parser"); 
const morgan = require("morgan")
const chalk = require("chalk"); 

// Building the express application 
const app = express(); 

// Setting some necessary middlewares 
app.use(cookieParser())
app.use(bodyParser())
app.use(express.json())
app.use(express.urlencoded({ extended: true }))
app.use(morgan('tiny'))

// Setting the views 
app.set("view engine", "ejs"); 
app.set("views", "./views"); 

// Setting the static ip address and port 
const PORT = process.env.PORT || 3001; 
const HOST = process.env.HOST || "localhost"; 

// Importing the required routes 
const usersRoute = require("./routes/usersRoute"); 

// Setting the route configurations 
app.use("/", usersRoute); 

// Running the nodejs API 
app.listen(PORT, HOST, () => {
    // Setting the server message 
    let serverMessage = chalk.magentaBright(`The server is running on ${HOST + ":" + PORT}`); 
    console.log(serverMessage); 
})