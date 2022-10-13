// Importing the necessary modules
import "package:flutter/material.dart";
import '../Components/homePage.dart';

// Creating the route class
class RouteManager {
  static const String homePage = "/";

  // Setting the route configurations
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case homePage:
        return MaterialPageRoute(
          builder: (context) => HomePage(),
        );
        break;

      default:
        throw FormatException("Route not found, check route again!");
    }
  }
}
