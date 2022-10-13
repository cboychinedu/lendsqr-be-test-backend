// Importing the necessary modules
import "package:flutter/material.dart";
import "Routes/routes.dart";

// Running the main function
void main() {
  runApp(MyApp());
}

// Running the class MyApp()
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Return the material application
    return const MaterialApp(
      // Adding the route configurations
      title: "Main Application",
      initialRoute: RouteManager.homePage,
      onGenerateRoute: RouteManager.generateRoute,
    );
  }
}
