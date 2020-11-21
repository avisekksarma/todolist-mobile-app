import 'package:flutter/material.dart';
import 'package:todolist/initialpage.dart';
import 'package:todolist/loginpage.dart';
import 'package:todolist/registerpage.dart';


Route<dynamic> handleRoutes(RouteSettings settings){
  switch(settings.name){
    case '/':
      return MaterialPageRoute(
        builder: (context) => Loading()
      );
    case 'login':
      return MaterialPageRoute(
        builder: (context) => LoginView()
      );
    case 'register':
      return MaterialPageRoute(
        builder: (context) => RegisterView()
      );
    default:
      return MaterialPageRoute(
        builder: (context) => Loading()
      );
  }
}
