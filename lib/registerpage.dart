import 'package:flutter/material.dart';

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
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: Form(
          key: _formKey,
          child: Column(children: <Widget>[
            Card(
              child: TextFormField(
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
