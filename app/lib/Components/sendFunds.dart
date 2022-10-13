// Importing the necessary modules
import "dart:convert";
import "package:app/Routes/routes.dart";
import "package:http/http.dart" as http;
import "package:flutter/material.dart";

// Creating the search user staateful widget
class SendFunds extends StatefulWidget {
  const SendFunds({super.key});

  @override
  State<SendFunds> createState() => _SendFundsState();
}

// Creaging the
class _SendFundsState extends State<SendFunds> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Send Money"),
        backgroundColor: const Color(0xff060606),
      ),
    );
  }
}
