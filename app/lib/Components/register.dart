// Importing the necessary modules
import 'dart:convert';
import "package:app/Routes/routes.dart";
import "package:http/http.dart" as http;
import "package:flutter/material.dart";

// Creating the register stateful widget
class Register extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // Return the register state
    return RegisterPageState();
  }
}

// Creating a map for registering users
Future<Map> registerUsers(
    firstname, lastname, age, email, password, startingBalance) async {
  http.Response response = await http.post(
      Uri.parse(
          "https://mbonu-chinedum-lendsqr-be-test.herokuapp.com/register"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "firstname": firstname,
        "lastname": lastname,
        "age": age,
        "email": email,
        "password": password,
        "account_balance": startingBalance,
        "status": "create_account"
      }));

  // Returning the data
  return json.decode(response.body);
}

// Creating the RegisterPageState widget
class RegisterPageState extends State<Register> {
  // Creating controllers for the register forms
  final TextEditingController _firstname = TextEditingController();
  final TextEditingController _lastname = TextEditingController();
  final TextEditingController _age = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _startBalance = TextEditingController();

  // Creating a function for handling the submit
  Future<void> handleSubmit() async {
    // Display
    print("Submit button pressed");

    // Getting the data
    if (_firstname.text.isNotEmpty &&
        _lastname.text.isNotEmpty &&
        _age.text.isNotEmpty &&
        _email.text.isNotEmpty &&
        _password.text.isNotEmpty &&
        _startBalance.text.isNotEmpty) {
      // Execute this block of code below
      String firstname = _firstname.text.toString();
      String lastname = _lastname.text.toString();
      String age = _age.text.toString();
      String email = _email.text.toString();
      String password = _password.text.toString();
      String startBalance = _startBalance.text.toString();

      // Sending the data to the server
      Map response = await registerUsers(
          firstname, lastname, age, email, password, startBalance);

      // Checking the status message
      if (response["status"] == "error") {
        // Creating a snack bar
        const snackBar = SnackBar(content: Text("User already exists"));

        // Showing the snackbar
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(snackBar);

        // Navigating the user to the sign page
        // ignore: use_build_context_synchronously
        Navigator.of(context).pushNamed(RouteManager.homePage);
      }

      // Else
      else if (response["status"] == "success") {
        // Creating a snack bar
        const snackBar = SnackBar(content: Text("User Registered!"));

        // Showing the snackbar
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(snackBar);

        // Navigating the user to the sign page
        // ignore: use_build_context_synchronously
        Navigator.of(context).pushNamed(RouteManager.homePage);
      }
    }

    // const snackBar = SnackBar(content: Text("Submit button pressed"));

    // ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  // Creating a function for handling the signin function
  void handleSignin() {
    // Execute this function when the signin button was clicked
    Navigator.of(context).pushNamed(RouteManager.homePage);
  }

  // Rendering the main code
  @override
  Widget build(BuildContext context) {
    // Building the register page widget
    return Scaffold(
        appBar: AppBar(
          title: const Text("Register"),
          automaticallyImplyLeading: false,
          backgroundColor: const Color(0xff060606),
        ),
        backgroundColor: const Color(0xffF5F5F5),
        body: Container(
            alignment: Alignment.topLeft,
            margin: const EdgeInsets.only(top: 20.0),
            child: Column(children: [
              Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(bottom: 5.0),
                  child: const Text("Create an",
                      style: TextStyle(
                          fontSize: 40.0, fontWeight: FontWeight.w100))),
              Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(top: 5.0),
                  child: const Text("Account",
                      style: TextStyle(
                          fontSize: 40.0, fontWeight: FontWeight.w100))),

              // The input field for the firstname
              Container(
                  alignment: Alignment.topLeft,
                  margin: const EdgeInsets.only(top: 20.0, right: 10.0),
                  width: 320.0,
                  child: TextField(
                      controller: _firstname,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          icon: Icon(Icons.person),
                          labelText: "Firstname"))),

              Container(
                  alignment: Alignment.topLeft,
                  margin: const EdgeInsets.only(top: 20.0, right: 10.0),
                  width: 320.0,
                  child: TextField(
                      controller: _lastname,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          icon: Icon(Icons.person),
                          labelText: "Lastname"))),

              // The input field for the age
              Container(
                  alignment: Alignment.topLeft,
                  margin: const EdgeInsets.only(top: 20.0, right: 10.0),
                  width: 320.0,
                  child: TextField(
                      controller: _age,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        icon: Icon(Icons.person_pin),
                        labelText: "Age",
                      ))),

              // The input field for the email address
              Container(
                  alignment: Alignment.topLeft,
                  margin: const EdgeInsets.only(top: 20.0, right: 10.0),
                  width: 320.0,
                  child: TextField(
                      controller: _email,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        icon: Icon(Icons.email),
                        labelText: "E-mail",
                      ))),

              // The input field for the password
              Container(
                  alignment: Alignment.topLeft,
                  margin: const EdgeInsets.only(top: 20.0, right: 10.0),
                  width: 320.0,
                  child: TextField(
                    controller: _password,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      icon: Icon(Icons.password),
                      labelText: "Password",
                    ),
                    obscureText: true,
                  )),

              // The input field for the start balance
              Container(
                  alignment: Alignment.topLeft,
                  margin: const EdgeInsets.only(top: 20.0, right: 10.0),
                  width: 320.0,
                  child: TextField(
                    controller: _startBalance,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      icon: Icon(Icons.monetization_on),
                      labelText: "Starting Balance",
                    ),
                  )),

              // Adding have an account, login text
              Container(
                alignment: Alignment.topLeft,
                margin: const EdgeInsets.only(left: 70.0),
                padding: const EdgeInsets.only(top: 30.0),
                child: Row(children: <Widget>[
                  const Text("Have an account ?"),
                  Container(
                      margin: const EdgeInsets.only(left: 0.0),
                      child: TextButton(
                        style: TextButton.styleFrom(
                          primary: Colors.black,
                        ),
                        onPressed: handleSignin,
                        child: const Text("SignIn"),
                      )),
                ]),
              ),

              // Adding the Register button
              Container(
                  alignment: Alignment.topLeft,
                  margin: const EdgeInsets.only(top: 2.0, left: 70.0),
                  child: SizedBox(
                      height: 55.0,
                      width: 265.0,
                      child: ElevatedButton(
                          onPressed: handleSubmit,
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black),
                          child: const Text("Register"))))
            ])));
  }
}
