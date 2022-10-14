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

// Creating a function for sending/transferring funds "status": "transfer_funds"
Future<Map> Transferfunds(
    senderEmail, senderPassword, amount, destinationEmail) async {
  http.Response response = await http.post(
    Uri.parse(
        'https://mbonu-chinedum-lendsqr-be-test.herokuapp.com/api/transfer-funds'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      "sender_email": senderEmail,
      "sender_password": senderPassword,
      "amount": amount,
      "destination_email": destinationEmail,
      "status": "transfer_funds",
    }),
  );

  // Returning the json object
  return json.decode(response.body);
}

// Creating the
class _SendFundsState extends State<SendFunds> {
  // Creating the controllers for the amount and the email
  final TextEditingController _destinationemailAddress =
      TextEditingController();
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

  // Creating a function for transferring the function
  Future<void> handleTransfer() async {
    // Obtain the shared preferences
    SharedPreferences preferences = await SharedPreferences.getInstance();

    // Getting the user login username, and password
    String? emailValue = preferences.getString("username");
    String? passwordValue = preferences.getString("password");

    // Transfering the funds
    if (_destinationemailAddress.text.isNotEmpty && _amount.text.isNotEmpty) {
      // Getting the destination email, and password
      String amount = _amount.text.toString();
      String destinationEmailAddress = _destinationemailAddress.text.toString();

      // Sending the data to the server
      Map data = await Transferfunds(
          emailValue, passwordValue, amount, destinationEmailAddress);

      // Checking the success message
      if (data["status"] == "success") {
        // Creating a snack bar
        const snackBar = SnackBar(content: Text("Transfer successful"));

        // Showing the snackbar
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else if (data["status"] == "error") {
        // Creating a snack bar
        const snackBar = SnackBar(content: Text("Destination email not found"));

        // Showing the snackbar
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else if (data["status"] == "error") {
        // Create a snackbar for the error message
        const snackBar = SnackBar(content: Text("Error in transaction!"));

        // Displaying the snackbar
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
      //{status: success, message: Transfer successful, amountSent: 0.4546}

    } else {
      // IF the form is empty
      const snackBar = SnackBar(content: Text("Form Empty"));

      // Displaying the snackbar
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  // Creating the handle function
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
        automaticallyImplyLeading: false,
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
                    borderRadius: const BorderRadius.all(Radius.circular(20))),
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
                    controller: _destinationemailAddress,
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
                    controller: _amount,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Amount",
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
                      onPressed: handleTransfer,
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black),
                      child: const Text("Send Funds"),
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
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black),
                      child: const Text("Back"),
                    ),
                  )),
            ],
          )),

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
