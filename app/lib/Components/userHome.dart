// Importing the necessary modules
import 'dart:convert';
import 'package:app/Components/sendFunds.dart';
import 'package:app/Routes/routes.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import "package:shared_preferences/shared_preferences.dart";

// Creating the user home stateful widget
class UserHome extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // Return the user's home state
    return UserHomeState();
  }
}

Future<Map> _ViewFunds(email, password) async {
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

// {status: success, message: User verified, accountBalance: 5655}

// Creating the user home class
class UserHomeState extends State<UserHome> {
  void handleSubmit() async {
    // Obtain the shared preferences
    SharedPreferences preferences = await SharedPreferences.getInstance();

    // Getting the user login username, and password
    String? emailValue = preferences.getString("username");
    String? passwordValue = preferences.getString("password");

    // Sending the user email and password to the server to get the
    // account details
    Map data = await _ViewFunds(emailValue, passwordValue);

    // Converting the account value into a string
    String _accountValue = data["accountBalance"].toString();

    // Saving the value
    setState(() {
      _accountBalance = _accountValue;
    });
    // _accountBalance = _accountValue;
  }

  // Navigate the user to the search route
  void SendFundsRoute() {
    // When the search user button is clicked, navigate the user to the search route
    Navigator.of(context).pushNamed(RouteManager.sendFunds);
  }

  @override
  void initState() {
    super.initState();
    handleSubmit();
  }

  // Setting the account value
  String _accountBalance = "0.00";

  // Rendering the main code
  @override
  Widget build(BuildContext context) {
    // Building the user home state
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Home"),
            automaticallyImplyLeading: false,
            backgroundColor: const Color(0xff060606),
            actions: [Icon(Icons.menu)],
          ),
          body: Container(
            alignment: Alignment.topLeft,
            child: Column(
              children: <Widget>[
                Container(
                    alignment: Alignment.topLeft,
                    height: 200.0,
                    width: 300,
                    padding: const EdgeInsets.only(top: 20.0, left: 20.0),
                    margin: const EdgeInsets.only(
                        left: 20.0, right: 20.0, top: 30.0),
                    decoration: BoxDecoration(
                        border: Border.all(
                            width: 2,
                            color: const Color.fromARGB(255, 237, 219, 218)),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20))),
                    child: Column(
                      children: [
                        Container(
                          margin:
                              const EdgeInsets.only(top: 20.0, bottom: 20.0),
                          alignment: Alignment.topLeft,
                          child: const Text(
                            "Account Information",
                            style: TextStyle(
                                fontSize: 20.0, fontWeight: FontWeight.normal),
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            const Text("Account Balance: ",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Container(
                                margin: const EdgeInsets.only(left: 50.0),
                                child: Text("NGN$_accountBalance")),
                          ],
                        ),
                      ],
                    )),

                // Customer Support
                Container(
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    alignment: Alignment.topLeft,
                    margin: const EdgeInsets.only(top: 40.0, left: 70.0),
                    child: SizedBox(
                        height: 55.0,
                        width: 259.0,
                        child: ElevatedButton(
                          onPressed: () => print("Customer Support"),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black),
                          child: const Text("Customer Support"),
                        ))),

                // Send Money
                Container(
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    alignment: Alignment.topLeft,
                    margin: const EdgeInsets.only(top: 20.0, left: 70.0),
                    child: SizedBox(
                        height: 55.0,
                        width: 259.0,
                        child: ElevatedButton(
                          onPressed: SendFundsRoute,
                          style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: const Color(0xff40B317)),
                          child: const Text("Send Money"),
                        ))),

                // Search user
                Container(
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    alignment: Alignment.topLeft,
                    margin: const EdgeInsets.only(top: 20.0, left: 70.0),
                    child: SizedBox(
                        height: 55.0,
                        width: 259.0,
                        child: ElevatedButton(
                          onPressed: () => print("Search user"),
                          style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: const Color(0xff1F5BD0)),
                          child: const Text("Search User"),
                        ))),
              ],
            ),
          ),
        ));
  }
}
