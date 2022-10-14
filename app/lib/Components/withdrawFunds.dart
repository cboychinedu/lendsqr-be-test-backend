// Importing the necessary modules
import "dart:async";
import "dart:convert";
import "package:app/Routes/routes.dart";
import "package:http/http.dart" as http;
import "package:flutter/material.dart";
import "package:shared_preferences/shared_preferences.dart";

// Creating the withdraw fund stateful widget
class WithdrawFundsPage extends StatefulWidget {
  const WithdrawFundsPage({super.key});

  @override
  State<WithdrawFundsPage> createState() => _WithdrawFundsPageState();
}

// Creating a function for viewing the funds
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

// Creating a function for withdrawing function from the API
Future<Map> WithdrawFunds(email, password, amount) async {
  // Performing the http post request
  http.Response response = await http.post(
    Uri.parse(
        "https://mbonu-chinedum-lendsqr-be-test.herokuapp.com/api/withdraw-funds"),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      "email": email,
      "password": password,
      "amount": amount,
      "status": "withdraw_funds",
    }),
  );

  // Returning the json object
  return json.decode(response.body);
}

//
class _WithdrawFundsPageState extends State<WithdrawFundsPage> {
  // Creating the controllers for the amount to the withdraw
  final TextEditingController _amount = TextEditingController();

  // Creating a function for navigating the users
  void BottomNavigation(value) {
    if (value == 0) {
      // Navigate the user to the menu page
      Navigator.of(context).pushNamed(RouteManager.userHome);
    } else if (value == 1) {
      // Navigate the user to the sendfunds page
      Navigator.of(context).pushNamed(RouteManager.sendFunds);
    }
  }

  // Creating a function for viewing the funds
  void viewFunds() async {
    // Obtain the share preferences
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
    setState(() => {_accountBalance = _accountValue});
  }

  @override
  void initState() {
    super.initState();
    viewFunds();
  }

  // Setting the account balance value
  String _accountBalance = "0.00";

  // Creating a function for handling the withdrawl
  Future<void> handleWithdrawl() async {
    // Obtain the shared preferences
    SharedPreferences preferences = await SharedPreferences.getInstance();

    // Getting the user login username, and password
    String? emailValue = preferences.getString("username");
    String? passwordValue = preferences.getString("password");

    // Withdrawing the funds
    if (_amount.text.isNotEmpty) {
      // Converting the amount into a string type
      String amount = _amount.text.toString();

      // Sending the data to the server
      Map data = await WithdrawFunds(emailValue, passwordValue, amount);

      // If the data was a success
      if (data["status"] == "success") {
        // Create a snackbar for a success message
        const snackBar = SnackBar(content: Text("Funds Withdrawn"));

        // Displaying the snackbar
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else if (data["status"] == "error") {
        // Create a snackbar for the error message
        const snackBar = SnackBar(content: Text("Error in transaction!"));

        // Displaying the snackbar
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
      // {status: success, message: Funds Withdrawn, Amount: 23, Account Balance: 5562}
    } else {
      // IF the form is empty
      const snackBar = SnackBar(content: Text("Form Empty"));

      // Displaying the snackbar
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Withdraw Funds"),
        backgroundColor: const Color(0xff060606),
      ),
      backgroundColor: const Color(0xffF5F5F5),
      body: Container(
          alignment: Alignment.center,
          child: Column(children: <Widget>[
            Container(
              alignment: Alignment.topLeft,
              height: 200.0,
              width: 300.0,
              padding: const EdgeInsets.only(top: 20.0, left: 20.0),
              margin: const EdgeInsets.only(left: 20.0, right: 20.0, top: 30.0),
              decoration: BoxDecoration(
                  border: Border.all(
                      width: 2,
                      color: const Color.fromARGB(255, 237, 219, 218)),
                  borderRadius: const BorderRadius.all(Radius.circular(20))),
              child: Column(children: <Widget>[
                Container(
                    margin: const EdgeInsets.only(top: 20.0, bottom: 20.0),
                    alignment: Alignment.topLeft,
                    child: const Text(
                      "Account Information",
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.normal),
                    )),
                Row(
                  children: <Widget>[
                    const Text("Account Balance: ",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Container(
                        margin: const EdgeInsets.only(left: 50.0),
                        child: Text("NGN$_accountBalance")),
                  ],
                )
              ]),
            ),
            Container(
                margin: const EdgeInsets.only(top: 30.0, left: 0.0),
                width: 300.0,
                child: Stack(
                  children: <Widget>[
                    Container(
                        child: TextField(
                            keyboardType: TextInputType.number,
                            controller: _amount,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Enter your amount",
                            ))),
                  ],
                )),
            // Adding the Sign in button
            Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.only(top: 30.0, right: 70.0),
                child: SizedBox(
                  height: 50.0,
                  width: 230.0,
                  child: ElevatedButton(
                    onPressed: handleWithdrawl,
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.black),
                    child: const Text("Withdraw Funds"),
                  ),
                )),

            // Adding the Sign in button
            Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.only(top: 10.0, right: 70.0),
                child: SizedBox(
                  height: 50.0,
                  width: 230.0,
                  child: ElevatedButton(
                    onPressed: () => {
                      Navigator.of(context).pushNamed(RouteManager.userHome)
                    },
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.black),
                    child: const Text("Back"),
                  ),
                )),
          ])),

      // Adding the bottom navigation bar
      bottomNavigationBar: BottomNavigationBar(
          onTap: (value) => BottomNavigation(value),
          backgroundColor: const Color.fromARGB(255, 44, 44, 44),
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.account_box), label: "Profile"),
            BottomNavigationBarItem(
                icon: Icon(Icons.send_sharp), label: "Send Money"),
            BottomNavigationBarItem(
                icon: Icon(Icons.settings), label: "Settings")
          ]),
    );
  }
}
