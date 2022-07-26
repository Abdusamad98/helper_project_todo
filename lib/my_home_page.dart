import 'package:flutter/material.dart';
import 'package:helper_project_todo/db/cached_todo.dart';
import 'package:helper_project_todo/db/cached_user.dart';
import 'package:helper_project_todo/db/local_database.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<CachedUser> cachedUsers = [];

  Future<void> _init() async {
    cachedUsers = await LocalDatabase.getAllCachedUsers();
    setState(() {});
  }

  @override
  void initState() {
    _init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sql User table"),
      ),
      body: Column(
        children: [
          TextButton(
            onPressed: () async {
              var userItem = CachedUser(age: 18, userName: "Ali");
              await LocalDatabase.insertCachedUser(userItem);
              await _init();
            },
            child: Text("Run Action"),
          ),
          Expanded(
              child: ListView(
                  children: List.generate(cachedUsers.length, (index) {
            var currentUserItem = cachedUsers[index];
            return ListTile(
              title: Text(currentUserItem.userName),
              subtitle: Text(currentUserItem.age.toString()),
              trailing: Text(currentUserItem.id.toString()),
              onTap: () async {
                await LocalDatabase.deleteAllCachedUsers();
                await _init();
              },
            );
          }))),
        ],
      ),
    );
  }
}
