// Importing the necessary modules
import "dart:async";
import "dart:convert";
import 'package:app/Routes/routes.dart';
import "package:http/http.dart" as http;
import "package:flutter/material.dart";
import "package:shared_preferences/shared_preferences.dart";

// Creating the login stateful widget
class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // Return the login state
    return HomePageState();
  }
}

Future<Map> loginUser(email, password) async {
  http.Response response = await http.post(
    Uri.parse(
        'https://mbonu-chinedum-lendsqr-be-test.herokuapp.com/api/get-funds'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      "email": email,
      "password": password,
      "status": "view_funds",
    }),
  );

  return json.decode(response.body);
}

// Creating the loginPageState widget
class HomePageState extends State<HomePage> {
  // Creating controllers for the login forms
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  // Creating a function for handing the submit function
  Future<void> handleSubmit() async {
    // Obtain the shared preferences
    SharedPreferences preferences = await SharedPreferences.getInstance();

    // Checking if the username, and password is not empty
    if (_email.text.isNotEmpty && _password.text.isNotEmpty) {
      // Getting the user username, and password
      String email = _email.text.toString();
      String password = _password.text.toString();

      // Sending the data to the server
      Map data = await loginUser(email, password);

      // Navigating the user to the home screen
      if (data["status"] == "success") {
        // Execute this block of code if the user values are correct
        preferences.setString("username", email);
        preferences.setString("password", password);

        // Navigate the user to the UserHome page
        Navigator.of(context).pushNamed(RouteManager.userHome);
      } else {
        // If the user login values are not correct
        // Create a snackbar
        const snackBar = SnackBar(content: Text("Incorrect email or password"));

        // Displaying the snackbar
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }

      // Saving the preferences
      // await prefs.setString("username", email);
      // await prefs.setString("password", password);

      // String? value = preferences.getString("password");
      // print(value);
    }

    // else
    else {
      // Creating a snack bar
      const snackBar = SnackBar(content: Text("Forms not filled!"));

      // Showing the snackbar
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  // Creating a function for handling the register function
  void handleRegister() {
    //
    print("Register Button Pressed");

    Navigator.of(context).pushNamed(RouteManager.register);
  }

  @override
  Widget build(BuildContext context) {
    // Building the login widget
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Sign In"),
        backgroundColor: const Color(0xff060606),
      ),
      backgroundColor: const Color(0xffF5F5F5),
      body: Container(
        alignment: Alignment.topLeft,
        margin: const EdgeInsets.only(top: 74.0),
        child: Column(children: <Widget>[
          // The text display container
          Container(
            margin: const EdgeInsets.only(top: 20.0, left: 30.0),
            child: Column(children: [
              Container(
                alignment: Alignment.topLeft,
                margin: const EdgeInsets.only(bottom: 5.0),
                child: const Text("Let's Sign you in.",
                    style: TextStyle(fontSize: 36.0)),
              ),
              Container(
                alignment: Alignment.topLeft,
                child: const Text("Welcome back.",
                    style: TextStyle(fontSize: 24.0)),
              ),
              Container(
                alignment: Alignment.topLeft,
                child: const Text(
                  "You've been missed!",
                  style: TextStyle(fontSize: 24.0),
                ),
              )
            ]),
          ),

          // The input field for username
          Container(
            alignment: Alignment.topLeft,
            margin: const EdgeInsets.only(top: 30.0, right: 50.0),
            width: 300.0,
            // padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16),
            child: TextField(
              controller: _email,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                icon: Icon(Icons.person),
                labelText: "Enter your email",
              ),
            ),
          ),

          // The input field for the password
          Container(
              alignment: Alignment.topLeft,
              margin: const EdgeInsets.only(top: 28.0, right: 50.0),
              width: 300.0,
              child: TextField(
                controller: _password,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Enter your password",
                    icon: Icon(Icons.lock)),
                obscureText: true,
              )),

          // Adding the dont have an account text
          Container(
              alignment: Alignment.topLeft,
              margin: const EdgeInsets.only(left: 70.0),
              padding: const EdgeInsets.only(top: 80.0),
              child: Row(
                children: <Widget>[
                  const Text("Don't have an account ?"),
                  Container(
                    margin: const EdgeInsets.only(left: 0.0),
                    child: TextButton(
                        style: TextButton.styleFrom(
                          primary: Colors.black,
                        ),
                        onPressed: handleRegister,
                        child: const Text("Register")),
                  )
                ],
              )),

          // Adding the Sign in button
          Container(
              alignment: Alignment.topLeft,
              margin: const EdgeInsets.only(top: 9.0, left: 70.0),
              child: SizedBox(
                height: 55.0,
                width: 259.0,
                child: ElevatedButton(
                  onPressed: handleSubmit,
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.black),
                  child: const Text("Sign In"),
                ),
              )),
        ]),
      ),
    );
  }
}
