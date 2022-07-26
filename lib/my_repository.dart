import 'package:helper_project_todo/db/cached_todo.dart';
import 'package:helper_project_todo/db/local_database.dart';

class MyRepository {
  static final MyRepository _instance = MyRepository._();

  factory MyRepository() {
    return _instance;
  }

  MyRepository._();

//----- Local cache Categories ---------
  static Future<CachedTodo> insertCachedTodo(
      {required CachedTodo cachedTodo}) async {
    var isEqual = LocalDatabase.getInstance==LocalDatabase();
    print(isEqual);
    return await LocalDatabase.insertCachedTodo(cachedTodo);
  }

  static Future<List<CachedTodo>> getAllCachedTodos() async {
    return await LocalDatabase.getAllCachedTodos();
  }

//----- Local cache Todos ---------




}
