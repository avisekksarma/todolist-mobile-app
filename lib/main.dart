import 'package:flutter/material.dart';
import 'package:todolist/router.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      // theme: ThemeData(

      //   primaryColor: Colors.orange,
      //   buttonColor:Colors.orange,
      //   primarySwatch: Colors.orange,
      //   visualDensity: VisualDensity.adaptivePlatformDensity,
      // ),
      theme: ThemeData.dark(),
      initialRoute: '/',
      onGenerateRoute: handleRoutes,
    ),
  );
}
