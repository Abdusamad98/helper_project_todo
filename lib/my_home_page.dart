import 'package:flutter/material.dart';
import 'package:helper_project_todo/db/cached_todo.dart';
import 'package:helper_project_todo/my_repository.dart';
import 'package:intl/intl.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DateTime dateTime = DateTime.now();
  List<CachedTodo> cachedTodos = [];

  Future<void> _init() async {
    cachedTodos = await MyRepository.getAllCachedTodos();
    setState(() {});
  }

  @override
  initState() {
    _init();
    super.initState();
  }

  Future<DateTime> getSelectedDate() async {
    var selectedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2020),
        lastDate: DateTime(2025));

    if (selectedDate != null) {
      return selectedDate;
    } else {
      return dateTime;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Helper project For Todo"),
      ),
      body: Column(
        children: [
          TextButton(
              onPressed: () async {
                var date = await getSelectedDate();
                setState(() {
                  dateTime = date;
                });
              },
              child: Text(DateFormat.yMMMMEEEEd().format(DateTime.now()))),
          TextButton(
              onPressed: () async {
                var toDo = CachedTodo(
                  dateTime: "2022-07-28 21:50:32.557848",
                  todoTitle: "Learning Shvjb",
                  categoryId: 1,
                  urgentLevel: 4,
                  isDone: 0,
                  todoDescription: "todoDescription",
                );
                var savedTodo =
                    await MyRepository.insertCachedTodo(cachedTodo: toDo);
                _init();
                print(savedTodo);
              },
              child: Text("Save To Cache:")),
          Expanded(
              child: ListView(
            children: List.generate(
                cachedTodos.length,
                (index) => Text(cachedTodos[index].todoTitle +
                    "ID ${cachedTodos[index].id}")),
          ))
        ],
      ),
    );
  }
}
