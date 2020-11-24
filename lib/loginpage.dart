import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:todolist/magic_number/magicnumbers.dart' as magicNumbers;
import 'package:todolist/shared_pref_data/shared_pref_data.dart';
// import 'package:requests/requests.dart';

class LoginView extends StatelessWidget {
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
                  child: Text('Login to Get Started',
                      style: TextStyle(fontSize: 30)),
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 20)),
              LoginForm(),
            ],
          ),
        ),
      ),
    );
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
      child: Form(
          key: _formKey,
          child: Column(children: <Widget>[
            Card(
              child: TextFormField(
                  controller: controllerUsername,
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
                  obscureText: true,
                  controller: controllerPassword,
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
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  color: Colors.orangeAccent,
                  child: Text('Login'),
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      print('input is valid for login page.');
                      bool wasLoginAttemptSuccessful = await loginViaApi(
                        controllerUsername.text,
                        controllerPassword.text,
                      );
                      if (wasLoginAttemptSuccessful) {
                        Navigator.pushReplacementNamed(context, 'home');
                      } else {
                        Scaffold.of(context).showSnackBar(SnackBar(
                          backgroundColor: Colors.black,
                          content: Text(
                            'Invalid username and/or password.',
                            style: TextStyle(color: Colors.white),
                          ),
                        ));
                      }
                    }
                  },
                )),
            Container(
                margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: Row(children: [
                  Padding(
                      child: Text("No Account?"), padding: EdgeInsets.all(10)),
                  FlatButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    color: Colors.orange[200],
                    child: Text('Register Here'),
                    onPressed: () {
                      print('register here is clicked');
                      Navigator.pushReplacementNamed(context, 'register');
                    },
                  ),
                ]))
          ])),
    );
  }
}

Future<bool> loginViaApi(String username, String password) async {
  http.Response response = await http.post(magicNumbers.ipAddress + 'api/login',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'username': username,
        'password': password,
        'app_name': magicNumbers.appName
      }));
  if (response.statusCode == 200) {
    // so the person should now be logged in.
    var x = json.decode(response.body);
    String cookieValue = response.headers['set-cookie'];
    // storing the session cookie value got from the backend/api so this acts as logging the user in.
    sharedPrefDataManager.storeStringData('session-cookie', cookieValue);
    print(x);
    try {
      print("this is $cookieValue");
    } catch (error) {
      print(error);
    }
    return true; // that means login attempt is successful.
  } else {
    print(jsonDecode(response.body));
    return false; // that means login attempt is unsuccessful due to invalid username and/or password.
  }
}

Future<bool> checkIfUserIsLoggedIn() async {
  http.Response res = await http
      .get(magicNumbers.ipAddress + 'api/login', headers: <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
    'Cookie': await sharedPrefDataManager.getStringData('session-cookie') ?? ''
  });
  print('yeahhhhhhh');
  var body = jsonDecode(res.body);
  print(body);

  if (body['status_code'] == 200) {
    return true;
  } else {
    return false;
  }
}
