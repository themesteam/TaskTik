import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tasktik/Models/ToDo.dart';
import 'package:tasktik/Pages/addTask.dart';
import 'package:tasktik/Pages/categories.dart';
import 'package:tasktik/Pages/category.dart';
import 'package:tasktik/Pages/loading.dart';
import 'package:tasktik/Pages/settings.dart';
import 'package:tasktik/Pages/tasks.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // deleteDatabase('tasktik.db');
  final database = openDatabase(join(await getDatabasesPath(), 'tasktik.db'),
      onCreate: (db, version) {
    return db.execute(
        'CREATE TABLE todos(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, isCompleted BOOLEAN,completeTime DATETIME,categoryId INTEGER,isImportant BOOLEAN,description TEXT,range TEXT,lesson TEXT);');
  }, version: 1);
  getTodos();

  runApp(MyApp());
}

Future<void> getTodos() async {
  final database = openDatabase(join(await getDatabasesPath(), 'tasktik.db'));
  var db = await database;
  final List<Map<String, dynamic>> todosMaps = await db.query('todos');
  toDos = List.generate(todosMaps.length, (index) {
    return Todo(
        id: todosMaps[index]['id'],
        title: todosMaps[index]['title'],
        isCompleted: todosMaps[index]['isCompleted'] == 1 ? true : false,
        categoryId: todosMaps[index]['categoryId'],
        isImportant: todosMaps[index]['isImportant'] == 1 ? true : false,
        lesson: todosMaps[index]['lesson'],
        range: todosMaps[index]['range'],
        description: todosMaps[index]['description']);
  });
}

List<Todo> toDos = [];

class TasksRoute {
  final int? id;
  final int? categoryid;
  TasksRoute({this.id, this.categoryid});
}

class CategoryRoute {
  final int id;
  CategoryRoute({required this.id});
}

bool loading = true;

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TaskTik',
      initialRoute: '/loading',
      routes: {
        '/settings': (context) => Settings(),
        '/categories': (context) => const Categories(),
        '/tasks': (context) => const Tasks(),
        '/addtask': (context) => const AddTask(),
        '/category': (context) => const Category(),
        '/loading': (context) => const Loading()
      },
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          appBarTheme:
              AppBarTheme(backgroundColor: Color.fromARGB(255, 20, 33, 61)),
          floatingActionButtonTheme: FloatingActionButtonThemeData(
              backgroundColor: Color.fromARGB(255, 252, 163, 17)),
          backgroundColor: Color.fromARGB(255, 229, 229, 229),
          focusColor: Color.fromARGB(255, 20, 33, 61),
          fontFamily: 'Tanha',
          primaryColor: Color.fromARGB(255, 20, 33, 61)),
    );
  }
}
