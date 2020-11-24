import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:todolist/shared_pref_data/shared_pref_data.dart';
import 'package:todolist/todos_collection/todo.dart';
import 'package:todolist/loginpage.dart' show checkIfUserIsLoggedIn;

class Loading extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  final spinkit = SpinKitWave(
    color: Colors.white,
    size: 40.0,
  );

  // getTodos() async {
  //   var result = await HandleApiPartForTodos.getAllTodos();
  // }

  Future<void> isLoggedIn() async {
    bool isloggedin = await checkIfUserIsLoggedIn();
    if (isloggedin) {
      // go to homepage if logged in
      Navigator.pushReplacementNamed(context, 'home');
    } else {
      // go to login page if not logged in
      Navigator.pushReplacementNamed(context, 'login');
    }
  }

  @override
  void initState() {
    isLoggedIn();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(child: spinkit),
    );
  }
}
