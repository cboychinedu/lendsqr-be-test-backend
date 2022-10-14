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

//
class _WithdrawFundsPageState extends State<WithdrawFundsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Withdraw Funds"),
          backgroundColor: const Color(0xff060606),
        ),
        backgroundColor: const Color(0xffF5F5F5),
        body: Container());
  }
}
