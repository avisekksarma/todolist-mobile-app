import 'package:flutter/material.dart';
import 'package:todolist/router.dart';

void main() {
  runApp(MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.orange,
        buttonColor:Colors.orange,
        primarySwatch: Colors.orange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      
      initialRoute: 'login',
      onGenerateRoute : handleRoutes
      ));
}

