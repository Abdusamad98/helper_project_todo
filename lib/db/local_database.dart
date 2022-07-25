import 'package:helper_project_todo/db/cached_todo.dart';
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
    CREATE TABLE $tableName (
    ${CachedTodoFields.id} $idType,
    ${CachedTodoFields.categoryId} $intType,
    ${CachedTodoFields.dateTime} $textType,
    ${CachedTodoFields.isDone} $intType,
    ${CachedTodoFields.todoDescription} $textType,
    ${CachedTodoFields.todoTitle} $textType,
    ${CachedTodoFields.urgentLevel} $intType
    )
    ''');
  }

  LocalDatabase._init();

  //-------------------------------------------Cached Todos Table------------------------------------

  static Future<CachedTodo> insertCachedTodo(CachedTodo cachedTodo) async {
    final db = await getInstance.database;
    final id = await db.insert(tableName, cachedTodo.toJson());
    return cachedTodo.copyWith(id: id);
  }

  static Future<List<CachedTodo>> getAllCachedTodos() async {
    final db = await getInstance.database;
    const orderBy = '${CachedTodoFields.todoTitle} DESC';
    final result = await db.query(tableName, orderBy: orderBy);
    return result.map((json) => CachedTodo.fromJson(json)).toList();
  }
}
