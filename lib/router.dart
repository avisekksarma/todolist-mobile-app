import 'package:flutter/material.dart';
import 'package:todolist/loading.dart';
import 'package:todolist/loginpage.dart';
import 'package:todolist/registerpage.dart';
import 'package:todolist/homepage.dart';

Route<dynamic> handleRoutes(RouteSettings settings) {
  switch (settings.name) {
    case '/':
      return MaterialPageRoute(builder: (context) => Loading());
    case 'login':
      return MaterialPageRoute(builder: (context) => LoginView());
    case 'register':
      return MaterialPageRoute(builder: (context) => RegisterView());
    case 'home':
      return MaterialPageRoute(builder: (context) => HomeView());
    default:
      return MaterialPageRoute(builder: (context) => Loading());
  }
}
