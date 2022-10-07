// Importing the necessary modules 
const express = require("express"); 
const jwt = require("jsonwebtoken"); 



// Creating the router object 
const router = express.Router(); 

// Creating the first api route 
router.get("/", (req, res) => {
    // Rendering static data for now 
    return res.send("<h2> Hello from Nodejs </h2>")
})

// Exporting the router 
module.exports = router; 