import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:todolist/magic_number/magicnumbers.dart' as magicNumbers;
import 'package:todolist/shared_pref_data/shared_pref_data.dart';

class RegisterView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('The Todolist App'),
          centerTitle: true,
        ),
        body: Center(
          child: Container(
            width: MediaQuery.of(context).size.width / 1.2,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                    child: Text('Register Now', style: TextStyle(fontSize: 30)),
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 20)),
                RegisterForm(),
              ],
            ),
          ),
        ));
  }
}

class RegisterForm extends StatefulWidget {
  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Form(
          key: _formKey,
          child: Column(children: <Widget>[
            Card(
              child: TextFormField(
                  controller: usernameController,
                  decoration: InputDecoration(hintText: 'Username'),
                  textAlign: TextAlign.center,
                  validator: (text) {
                    if (text.isEmpty) {
                      return 'Please enter your username.';
                    }
                    return null;
                  }),
            ),
            Card(
              child: TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(hintText: 'Email'),
                  textAlign: TextAlign.center,
                  validator: (text) {
                    if (text.isEmpty) {
                      return 'Please enter your email.';
                    }
                    return null;
                  }),
            ),
            Card(
              child: TextFormField(
                  obscureText: true,
                  controller: passwordController,
                  decoration: InputDecoration(hintText: 'Password'),
                  textAlign: TextAlign.center,
                  validator: (text) {
                    if (text.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  }),
            ),
            Padding(
                padding: EdgeInsets.all(10),
                child: RaisedButton(
                  color: Colors.orangeAccent,
                  child: Text('Register'),
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      print('input is valid.');
                      registerViaApi(usernameController.text,
                          emailController.text, passwordController.text,
                          context: context);
                    }
                  },
                )),
            Container(
                margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: Row(children: [
                  Padding(
                      child: Text("Already have an Account?"),
                      padding: EdgeInsets.all(10)),
                  FlatButton(
                    color: Colors.orange[200],
                    child: Text('Login'),
                    onPressed: () {
                      print('register here is clicked');
                      Navigator.pushReplacementNamed(context, 'login');
                    },
                  )
                ]))
          ])),
    );
  }
}

Future<bool> registerViaApi(String username, String email, String password,
    {BuildContext context}) async {
  http.Response response =
      await http.post(magicNumbers.ipAddress + 'api/register',
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode({
            'username': username,
            'password': password,
            'email': email,
            'app_name': magicNumbers.appName
          }));

  var body = jsonDecode(response.body);
  if (response.statusCode == 200) {
    Scaffold.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.black,
        content: Text(body['success'] + 'Now,go to login page.',
            style: TextStyle(color: Colors.white))));
    return true; // that means register attempt is successful.
  } else {
    Scaffold.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.black,
        content: Text(body['error'], style: TextStyle(color: Colors.white))));
    return false; // that means login attempt is unsuccessful due to invalid username and/or password.
  }
}
