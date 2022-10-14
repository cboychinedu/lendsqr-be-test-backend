// Importing the necessary modules
import "package:flutter/material.dart";
import '../Components/homePage.dart';
import '../Components/register.dart';
import '../Components/userHome.dart';
import '../Components/sendFunds.dart';
import '../Components/withdrawFunds.dart';

// Creating the route class
class RouteManager {
  static const String homePage = "/";
  static const String register = "/register";
  static const String userHome = "/userHome";
  static const String sendFunds = "/sendFunds";
  static const String withdrawFunds = "/withdrawFunds";

  // Setting the route configurations
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case homePage:
        return MaterialPageRoute(
          builder: (context) => HomePage(),
        );
        break;

      case register:
        return MaterialPageRoute(
          builder: (context) => Register(),
        );
        break;

      case userHome:
        return MaterialPageRoute(
          builder: (context) => UserHome(),
        );
        break;

      case sendFunds:
        return MaterialPageRoute(
          builder: (context) => SendFunds(),
        );
        break;

      case withdrawFunds:
        return MaterialPageRoute(
          builder: (context) => WithdrawFundsPage(),
        );

      default:
        throw const FormatException("Route not found, check route again!");
    }
  }
}
