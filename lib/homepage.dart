import 'package:flutter/material.dart';
import 'package:todolist/todos_collection/todo.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

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
                HomeScreenUncompletedTodos(),
                Text('this is completed')
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HomeScreenUncompletedTodos extends StatefulWidget {
  @override
  _HomeScreenUncompletedTodosState createState() =>
      _HomeScreenUncompletedTodosState();
}

class _HomeScreenUncompletedTodosState
    extends State<HomeScreenUncompletedTodos> {
  Future<Object> allTodos;

  getAllTodosAndCompleted() {
    allTodos = HandleApiPartForTodos.getAllTodos();
  }

  @override
  void initState() {
    getAllTodosAndCompleted();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // for (var i in UncompletedTodos.allUncompletedTodos) {
    //   print(UncompletedTodos.allUncompletedTodos);
    //   print(i.todo);
    // }

    return FutureBuilder(
        future: allTodos,
        builder: (context, snapshot) {
          print(snapshot.data);
          print(snapshot.connectionState);
          if (snapshot.connectionState == ConnectionState.none ||
              snapshot.connectionState == ConnectionState.waiting) {
            return spinkit;
          } else if (snapshot.connectionState == ConnectionState.done) {
            if (UncompletedTodos.allUncompletedTodos.isEmpty) {
              return Center(child: Text('No Any Todos.'));
            } else {
              return ListView.separated(
                itemCount: UncompletedTodos.allUncompletedTodos.length,
                itemBuilder: (context, index) {
                  return Container(
                      height: 50,
                      width: double.infinity,
                      child: Align(
                        alignment: Alignment(-0.75, 0),
                        child: Text((index + 1).toString() +
                            '. ' +
                            UncompletedTodos.allUncompletedTodos[index].todo),
                      ));
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

class ATodo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
