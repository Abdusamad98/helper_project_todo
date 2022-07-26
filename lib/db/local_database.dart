import 'package:helper_project_todo/db/cached_todo.dart';
import 'package:helper_project_todo/db/cached_user.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart';

class LocalDatabase {
  static final LocalDatabase getInstance = LocalDatabase._init();
  static Database? _database;

  factory LocalDatabase() {
    return getInstance;
  }

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    } else {
      _database = await _initDB("todos.db");
      return _database!;
    }
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = "INTEGER PRIMARY KEY AUTOINCREMENT";
    const textType = "TEXT NOT NULL";
    const intType = "INTEGER DEFAULT 0";

    await db.execute('''
    CREATE TABLE $todoTable (
    ${CachedTodoFields.id} $idType,
    ${CachedTodoFields.categoryId} $intType,
    ${CachedTodoFields.dateTime} $textType,
    ${CachedTodoFields.isDone} $intType,
    ${CachedTodoFields.todoDescription} $textType,
    ${CachedTodoFields.todoTitle} $textType,
    ${CachedTodoFields.urgentLevel} $intType
    )
    ''');



    await db.execute('''
    CREATE TABLE $userTable (
    ${CachedUsersFields.id} $idType,
    ${CachedUsersFields.userName} $textType,
    ${CachedUsersFields.age} $intType
    )
    ''');
  }

  LocalDatabase._init();

  //-------------------------------------------Cached Users Table------------------------------------

  static Future<CachedUser> insertCachedUser(CachedUser cachedUser) async {
    final db = await getInstance.database;
    final id = await db.insert(userTable, cachedUser.toJson());
    return cachedUser.copyWith(id: id);
  }

  static Future<List<CachedUser>> getAllCachedUsers() async {
    final db = await getInstance.database;
    const orderBy = "${CachedUsersFields.userName} ASC";
    final result = await db.query(
      userTable,
      orderBy: orderBy,
    );
    return result.map((json) => CachedUser.fromJson(json)).toList();
  }

  static Future<int> deleteCachedUserById(int id) async {
    final db = await getInstance.database;
    var t = await db
        .delete(userTable, where: "${CachedUsersFields.id}=?", whereArgs: [id]);
    if (t > 0) {
      return t;
    } else {
      return -1;
    }
  }

  static Future<int> updateCachedUser(CachedUser cachedUser) async {
    Map<String, dynamic> row = {
      CachedUsersFields.userName: cachedUser.userName,
      CachedUsersFields.age: cachedUser.age,
    };



    final db = await getInstance.database;
    return await db.update(
      userTable,
      row,
      where: '${CachedUsersFields.id} = ?',
      whereArgs: [cachedUser.id],
    );
  }

  static Future<int> deleteAllCachedUsers() async {
    final db = await getInstance.database;
    return await db.delete(userTable);
  }


  //-------------------------------------------Cached Todos Table------------------------------------

  static Future<CachedTodo> insertCachedTodo(CachedTodo cachedTodo) async {
    final db = await getInstance.database;
    final id = await db.insert(todoTable, cachedTodo.toJson());

    /// adding data to db and retrieving id from db
    return cachedTodo.copyWith(id: id);

    /// giving id to cachedTodo since it is null
  }

  static Future<List<CachedTodo>> getAllCachedTodos() async {
    final db = await getInstance.database;
    const orderBy = "${CachedTodoFields.todoTitle} ASC";

    /// order by id;
    final result = await db.query(
      todoTable,
      orderBy: orderBy,
    );
    return result.map((json) => CachedTodo.fromJson(json)).toList();
  }

  static Future<int> deleteAllCachedTodos() async {
    final db = await getInstance.database;
    return await db.delete(todoTable);
  }

  static Future<int> deleteCachedTodoById(int id) async {
    final db = await getInstance.database;
    var t = await db
        .delete(todoTable, where: "${CachedTodoFields.id}=?", whereArgs: [id]);
    if (t > 0) {
      return t;
    } else {
      return -1;
    }
  }

//isDone 0 va 1
  static Future<int> updateCachedTodoStatus(int id, int status) async {
    Map<String, dynamic> row = {
      CachedTodoFields.isDone: status,
    };

    final db = await getInstance.database;
    return db.update(
      todoTable,
      row,
      where: '${CachedTodoFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await getInstance.database;
    db.close();
  }
}
