import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:todolist/magic_number/magicnumbers.dart' as magicNumbers;
import 'package:todolist/shared_pref_data/shared_pref_data.dart';

class UncompletedTodos {
  int id;
  String todo;
  bool completed = false;

  UncompletedTodos(this.id, this.todo);

  static List allUncompletedTodos = [];
}

class CompletedTodos {
  int id;
  String todo;
  bool completed = true;

  CompletedTodos(this.id, this.todo);

  static List allCompletedTodos = [];
}

abstract class HandleApiPartForTodos {
  // use this method only if user is logged in that is like She is in homepage.
  static Future<Object> getAllTodos() async {
    UncompletedTodos.allUncompletedTodos = [];
    CompletedTodos.allCompletedTodos = [];
    http.Response res =
        await http.get(magicNumbers.ipAddress + 'api/todos', headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'Cookie': await sharedPrefDataManager.getStringData('session-cookie') ??
          '' // shared_pref_data_of_session_cookie exists then probably that man is logged in but check by sending cookie in server side makes it certain
    });

    var responseBody = jsonDecode(res.body);
    print(responseBody.runtimeType);
    print(responseBody['todos']);
    for (var todo in responseBody['todos']) {
      if (!todo['completed']) {
        print('line 1-${todo["todo"]}');

        UncompletedTodos.allUncompletedTodos
            .add(UncompletedTodos(todo['id'], todo['todo']));
      } else {
        CompletedTodos.allCompletedTodos
            .add(CompletedTodos(todo['id'], todo['todo']));
      }
    }
    return 'completed';
  }
}
