// Importing the necessary modules
import "package:flutter/material.dart";
import '../Components/homePage.dart';
import '../Components/register.dart';

// Creating the route class
class RouteManager {
  static const String homePage = "/";
  static const String register = "/register";

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

      default:
        throw FormatException("Route not found, check route again!");
    }
  }
}
