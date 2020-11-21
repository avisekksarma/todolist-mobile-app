import 'dart:convert';

import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
import 'package:requests/requests.dart';


class LoginView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('The Todolist App'),
          centerTitle: true,
        ),
        body: Padding(
          padding: EdgeInsets.fromLTRB(50, 50, 50, 0),
          child: Column(children: [
            Container(
              child: Text('Login to Get Started', style: TextStyle(fontSize: 30)),
              margin:EdgeInsets.fromLTRB(0, 0, 0, 20)
            ),
            LoginForm(),
          ]),
        ));
  }
}

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {

  final _formKey = GlobalKey<FormState>();
  final controllerUsername = TextEditingController();
  final controllerPassword = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    controllerUsername.dispose();
    controllerPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {


    return Container(
      height: 300,
      child: Form(
          key: _formKey,
          child: Column(children: <Widget>[
            Card(
              child: TextFormField(
                controller: controllerUsername,
                decoration: InputDecoration(
                  hintText:'Username'
                ),
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
                obscureText: true,
                controller: controllerPassword,
                decoration: InputDecoration(
                  hintText:'Password'
                ),
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
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                  color:Colors.orangeAccent,
                  child: Text('Login'),
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      print('input is valid for login page.');
                      loginViaApi(controllerUsername.text,controllerPassword.text);
                    }
                  },
                )),
            Container(
              margin:EdgeInsets.fromLTRB(0,10,0,0),
              child: Row(
                children: [
                  Padding(
                    child: Text("Don't have an Account?"),
                    padding:EdgeInsets.all(10)
                  ),
                  FlatButton(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                    color:Colors.orange[200],
                    child:Text('Register Here'),
                    onPressed: (){
                      print('register here is clicked');
                      Navigator.pushReplacementNamed(context, 'register');
                    },
                  )
                ])
            )
          ])),
    );
  }
}

Future<void> loginViaApi(String username,String password) async{
  http.Response response = await http.post(
    'http://192.168.1.66:5000/api/login',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode({
      'username':username,
      'password':password,
      'app_name':'avisektodo'
    })
  );
  if(response.statusCode == 200){
    var x = json.decode(response.body);
    print(x);
    try{
      print("this is ${x['token']}");
    }catch(error){
      print(error);
    }
  }else{
    print(jsonDecode(response.body));
  }
  
}
