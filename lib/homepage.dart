import 'package:flutter/material.dart';
import 'package:todolist/loginpage.dart';
import 'package:todolist/todos_collection/todo.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:todolist/shared_pref_data/shared_pref_data.dart';

// global variables section
final spinkit = SpinKitRing(
  color: Colors.white,
  size: 50.0,
);

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: SafeArea(
        child: Scaffold(
          appBar: TabBar(
            indicatorColor: Colors.white,
            tabs: [
              Container(child: Center(child: Text('Todos'))),
              Container(child: Center(child: Text('Completed'))),
            ],
          ),
          body: SafeArea(
            child: TabBarView(
              children: [
                FutureBuilderForAllTodos(
                    'No any Todos', UncompletedTodos.allUncompletedTodos),
                FutureBuilderForAllTodos(
                    'No any Completed todos', CompletedTodos.allCompletedTodos)
              ],
            ),
          ),
          bottomNavigationBar: FlatButton(
            onPressed: () async {
              // logging out the user by deleting the session-cookie.
              await sharedPrefDataManager.deleteData('session-cookie');
              bool isLoggedIn = await checkIfUserIsLoggedIn(); // return false
              print('homepage.dart-' + isLoggedIn.toString());
              Navigator.pushReplacementNamed(context, '/');
            },
            child: Text('Logout'),
            color: Colors.red,
          ),
        ),
      ),
    );
  }
}

// start of future builder for the uncompleted as well as completed todos.
class FutureBuilderForAllTodos extends StatefulWidget {
  final whatToShowWhenEmpty;

  final listToWorkUpon;

  FutureBuilderForAllTodos(this.whatToShowWhenEmpty, this.listToWorkUpon);

  @override
  _FutureBuilderForAllTodosState createState() =>
      _FutureBuilderForAllTodosState();
}

class _FutureBuilderForAllTodosState extends State<FutureBuilderForAllTodos> {
  Future<Object> allTodos = HandleApiPartForTodos.getAllTodos();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: allTodos,
        builder: (context, snapshot) {
          print('future completed');
          if (snapshot.connectionState == ConnectionState.none ||
              snapshot.connectionState == ConnectionState.waiting) {
            print('inside spinkit');
            return spinkit;
          } else if (snapshot.connectionState == ConnectionState.done) {
            print('below is list to work upon');
            print(this.widget.listToWorkUpon);
            if (this.widget.listToWorkUpon.isEmpty) {
              return Center(child: Text(this.widget.whatToShowWhenEmpty));
            } else {
              return ListView.separated(
                itemCount: this.widget.listToWorkUpon.length + 1,
                itemBuilder: (context, index) {
                  // for showing the form in home tab or just an empty container (i.e not showing form in completed tab.)
                  if (index == this.widget.listToWorkUpon.length) {
                    if (this.widget.listToWorkUpon ==
                        UncompletedTodos.allUncompletedTodos) {
                      return Container(
                        width: MediaQuery.of(context).size.width / 5,
                        child: AddANewTodo(() {
                          // form to be shown in "todos tab".
                          setState(() {
                            allTodos = HandleApiPartForTodos.getAllTodos();
                          });
                        }),
                      );
                    } else {
                      return Container(); // an empty container so that means form not to be shown in "completed tab"
                    }
                  }
                  return Dismissible(
                    key: Key(this.widget.listToWorkUpon[index].id.toString()),
                    direction: DismissDirection.startToEnd,
                    background: Container(
                        color: Colors.lightGreenAccent,
                        child: Align(
                          alignment: Alignment(-0.5, 0),
                          child: Text('Mark as Completed',
                              style:
                                  TextStyle(fontSize: 17, color: Colors.black)),
                        )),
                    onDismissed: (direction) async {
                      // after the following line the todo will be marked as complete so then only setstate should happen so i used await.
                      await HandleApiPartForTodos.markATodoAsCompleted(
                          this.widget.listToWorkUpon[index].id);
                      setState(() {
                        allTodos = HandleApiPartForTodos.getAllTodos();
                      });
                    },
                    child: Container(
                        height: 50,
                        width: double.infinity,
                        child: Align(
                          alignment: Alignment(-0.75, 0),
                          child: Text((index + 1).toString() +
                              '. ' +
                              this.widget.listToWorkUpon[index].todo),
                        )),
                  );
                },
                separatorBuilder: (context, index) {
                  return Divider();
                },
              );
            }
          }
        });
  }
}

// class ATodo extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container();
//   }
// }

class AddANewTodo extends StatefulWidget {
  final rebuildTheTodosTab;

  AddANewTodo(this.rebuildTheTodosTab);
  @override
  _AddANewTodoState createState() => _AddANewTodoState();
}

class _AddANewTodoState extends State<AddANewTodo> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController addTodoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
              controller: addTodoController,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please type a todo before submitting.';
                }
                return null;
              }),
          ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState.validate()) {
                  await HandleApiPartForTodos.addATodo(
                      addTodoController.text, context);
                  this.widget.rebuildTheTodosTab();
                }
              },
              child: Text('Add'))
        ],
      ),
    );
  }
}
