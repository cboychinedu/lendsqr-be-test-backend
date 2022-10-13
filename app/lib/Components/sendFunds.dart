// Importing the necessary modules
import "dart:convert";
import "package:app/Routes/routes.dart";
import "package:http/http.dart" as http;
import "package:flutter/material.dart";
import "package:shared_preferences/shared_preferences.dart";

// Creating the search user staateful widget
class SendFunds extends StatefulWidget {
  const SendFunds({super.key});

  @override
  State<SendFunds> createState() => _SendFundsState();
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

  // Returning the json object
  return json.decode(response.body);
}

// Creaging the
class _SendFundsState extends State<SendFunds> {
  void handleFunds() async {
    // Obtain the shared preferences
    SharedPreferences preferences = await SharedPreferences.getInstance();

    // Getting the user login username, and password
    String? emailValue = preferences.getString("username");
    String? passwordValue = preferences.getString("password");

    // Sending the user email and password to the server to get the
    // account details
    Map data = await _ViewFunds(emailValue, passwordValue);

    // Convert the account value into a string
    String _accountValue = data["accountBalance"].toString();

    // Saving the value
    setState(() {
      _accountBalance = _accountValue;
    });
  }

  @override
  void initState() {
    super.initState();
    handleFunds();
  }

  // Setting the account balance value
  String _accountBalance = "0.00";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Send Money"),
          backgroundColor: const Color(0xff060606),
        ),
        body: Container(
            alignment: Alignment.center,
            child: Column(
              children: <Widget>[
                Container(
                  alignment: Alignment.topLeft,
                  height: 200.0,
                  width: 300,
                  padding: const EdgeInsets.only(top: 20.0, left: 20.0),
                  margin:
                      const EdgeInsets.only(left: 20.0, right: 20.0, top: 30.0),
                  decoration: BoxDecoration(
                      border: Border.all(
                          width: 2,
                          color: const Color.fromARGB(255, 237, 219, 218)),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(20))),
                  child: Column(
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.only(top: 20.0, bottom: 20.0),
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
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 30.0, left: 0.0),
                  width: 300.0,
                  child: Stack(children: [
                    Container(
                        child: TextField(
                      controller: null,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Users email address",
                      ),
                    )),
                    Container(
                      alignment: Alignment.topRight,
                      padding: const EdgeInsets.only(top: 15.0, right: 10.0),
                      child: Icon(Icons.search),
                    )
                  ]),
                ),

                // User amount
                Container(
                    alignment: Alignment.topLeft,
                    margin: const EdgeInsets.only(top: 15.0, right: 199.0),
                    width: 100.0,
                    child: TextField(
                      controller: null,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Amount",
                      ),
                    )),

                // Adding the Sign in button
                Container(
                    alignment: Alignment.topLeft,
                    margin: const EdgeInsets.only(top: 10.0, left: 40.0),
                    child: SizedBox(
                      height: 50.0,
                      width: 230.0,
                      child: ElevatedButton(
                        onPressed: null,
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black),
                        child: const Text("Send Funds"),
                      ),
                    )),
              ],
            )));
  }
}
