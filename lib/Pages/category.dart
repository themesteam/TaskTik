import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../Components/BottomBar.dart';
import '../Models/ToDo.dart';
import '../main.dart';

class Category extends StatefulWidget {
  const Category({Key? key}) : super(key: key);

  @override
  _CategoryState createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  void changeCompleated(int id) async {
    final database = openDatabase(
      join(await getDatabasesPath(), 'tasktik.db'),
    );
    final db = await database;
    var editedTodo = toDos.where((element) => element.id == id).first;
    setState(() {
      editedTodo.isCompleted = !editedTodo.isCompleted;
    });
    await db.update(
      'todos',
      editedTodo.toMap(),
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  void changeImportant(int id) async {
    final database = openDatabase(
      join(await getDatabasesPath(), 'tasktik.db'),
    );
    final db = await database;
    var editedTodo = toDos.where((element) => element.id == id).first;
    setState(() {
      editedTodo.isImportant = !editedTodo.isImportant;
    });
    await db.update(
      'todos',
      editedTodo.toMap(),
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> _showMyDialog(BuildContext context, int id) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'حذف',
            textAlign: TextAlign.right,
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text(
                  'این مورد حذف بشه؟',
                  textAlign: TextAlign.right,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'آره',
                style: TextStyle(color: Color.fromARGB(255, 252, 163, 17)),
              ),
              onPressed: () async {
                final database = openDatabase(
                  join(await getDatabasesPath(), 'tasktik.db'),
                );
                final db = await database;
                print(id);
                await db.delete(
                  'todos',
                  where: 'id = ?',
                  whereArgs: [id],
                );
                setState(() {
                  toDos
                      .remove(toDos.where((element) => element.id == id).first);
                });
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                'نه',
                style: TextStyle(color: Color.fromARGB(255, 252, 163, 17)),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final RouteArgs =
        ModalRoute.of(context)!.settings.arguments as CategoryRoute;
    List<Todo> categoryTodos =
        toDos.where((element) => element.categoryId == RouteArgs.id).toList();
    String title = "همه کار ها";
    switch (RouteArgs.id) {
      case 0:
        title = "دسته بندی نشده";
        break;
      case 1:
        title = "تکالیف";
        break;
      case 2:
        title = "امتحانات";
        break;
      case 3:
        title = "مطالعه";
        break;
      case 4:
        title = "پیش مطالعه";
        break;
      default:
    }
    return WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            actions: [
              IconButton(
                icon: Icon(Icons.add_task),
                onPressed: () {
                  Navigator.pushNamed(context, '/addtask',
                      arguments:
                          TasksRoute(id: null, categoryid: RouteArgs.id));
                },
              )
            ],
            title: Text(title),
            centerTitle: true,
          ),
          body: toDos.length != 0
              ? ListView.builder(
                  itemCount: categoryTodos.length,
                  itemBuilder: (BuildContext context, int index) {
                    var item = categoryTodos[index];
                    return GestureDetector(
                        onTap: () => Navigator.pushNamed(context, '/addtask',
                            arguments: TasksRoute(
                                id: item.id, categoryid: item.categoryId)),
                        onLongPress: () => _showMyDialog(context, item.id),
                        child: Container(
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30))),
                          margin: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                          padding: const EdgeInsets.fromLTRB(5, 10, 5, 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  IconButton(
                                    splashColor: Colors.transparent,
                                    onPressed: () => changeCompleated(item.id),
                                    icon: Icon(item.isCompleted
                                        ? Icons.check_circle
                                        : Icons.circle_outlined),
                                    color: toDos[index].isCompleted
                                        ? Colors.green
                                        : Colors.blueGrey,
                                  ),
                                  Text(item.title),
                                ],
                              ),
                              IconButton(
                                splashColor: Colors.transparent,
                                onPressed: () => changeImportant(item.id),
                                icon: Icon(toDos[index].isImportant
                                    ? Icons.star_rounded
                                    : Icons.star_outline_outlined),
                                color: toDos[index].isImportant
                                    ? Colors.yellow
                                    : Colors.blueGrey,
                              ),
                            ],
                          ),
                        ));
                  })
              : Center(
                  child: Text("!خبری نیست"),
                ),
          bottomNavigationBar: BottomBar(),
          floatingActionButton: FloatingActionButton(
            onPressed: () => Navigator.pushNamed(context, '/tasks'),
            child: Icon(Icons.home_filled),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
        ),
        onWillPop: () async {
          Navigator.pushNamed(context, '/categories');
          return true;
        });
  }
}
