import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tasktik/main.dart';

import '../Models/ToDo.dart';

class AddTask extends StatefulWidget {
  const AddTask({Key? key}) : super(key: key);

  @override
  _AddTaskState createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  final titleTextField = TextEditingController();
  final descriptionTextField = TextEditingController();
  final lessonTextField = TextEditingController();
  final rangeTextField = TextEditingController();

  bool isNumbric(String text) {
    try {
      int.parse(text);
    } catch (e) {
      return false;
    }
    return true;
  }

  Future<void> _showMyDialog(
      BuildContext context, String title, String description) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            title,
            textAlign: TextAlign.right,
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  description,
                  textAlign: TextAlign.right,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'باشه',
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

  Future<bool> _onWillPop(BuildContext context, int? categoryid) async {
    Navigator.pushNamed(context, '/category',
        arguments: CategoryRoute(id: categoryId));
    return true;
  }

  saveButtonPressed(BuildContext context, int? rid) async {
    final database = openDatabase(
      join(await getDatabasesPath(), 'tasktik.db'),
    );
    if (titleTextField.text.isEmpty) {
      return _showMyDialog(context, "عنوان کار", "!عنوان کار نباید خالی باشه");
    }

    final db = await database;
    List<Map<String, dynamic>> maps = await db.query('todos');
    var todo = Todo(
      id: maps.isNotEmpty ? maps[maps.length - 1]['id'] + 1 : 1,
      title: titleTextField.text,
      isCompleted: isCompleated,
      isImportant: isImortant,
      range: rangeTextField.text,
      lesson: lessonTextField.text,
      description: descriptionTextField.text,
      categoryId: categoryId,
    );
    if (rid == null) {
      await db.insert(
        'todos',
        todo.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      setState(() => toDos.add(todo));
    } else {
      todo.id = rid;
      await db.update(
        'todos',
        todo.toMap(),
        where: 'id = ?',
        whereArgs: [rid],
      );
      setState(() {
        var item = toDos.where((element) => element.id == rid).first;
        item.categoryId = categoryId;
        item.title = titleTextField.text;
        item.lesson = lessonTextField.text;
        item.range = rangeTextField.text;
        item.description = rangeTextField.text;
        item.isCompleted = isCompleated;
        item.isImportant = isImortant;
      });
    }
    setState(() {
      titleTextField.text = "";
      lessonTextField.text = "";
      rangeTextField.text = "";
      descriptionTextField.text = "";
      categoryId = 0;
      isImortant = false;
      isCompleated = false;
    });
    Navigator.pushNamed(context, '/tasks');
  }

  int categoryId = 0;
  bool isImortant = false;
  bool isCompleated = false;
  @override
  Widget build(BuildContext context) {
    final routeArgs = ModalRoute.of(context)!.settings.arguments as TasksRoute;
    if (routeArgs.categoryid != null) {
      categoryId = routeArgs.categoryid!;
    }
    if (routeArgs.id != null) {
      isCompleated = toDos
          .where(
            (element) => element.id == routeArgs.id,
          )
          .first
          .isCompleted;
      isImortant = toDos
          .where(
            (element) => element.id == routeArgs.id,
          )
          .first
          .isImportant;
      titleTextField.text = toDos
          .where(
            (element) => element.id == routeArgs.id,
          )
          .first
          .title;
      if (toDos.where((element) => element.id == routeArgs.id).first.lesson !=
          null) {
        lessonTextField.text = toDos
            .where(
              (element) => element.id == routeArgs.id,
            )
            .first
            .lesson!;
      }
      if (toDos.where((element) => element.id == routeArgs.id).first.range !=
          null) {
        rangeTextField.text = toDos
            .where(
              (element) => element.id == routeArgs.id,
            )
            .first
            .range!;
      }
      if (toDos
              .where((element) => element.id == routeArgs.id)
              .first
              .description !=
          null) {
        descriptionTextField.text = toDos
            .where(
              (element) => element.id == routeArgs.id,
            )
            .first
            .description!;
      }
    }

    return WillPopScope(
        child: Scaffold(
            appBar: AppBar(
              title: Text(routeArgs.id == null
                  ? "کار جدید"
                  : "ویرایش " +
                      toDos
                          .where((element) => element.id == routeArgs.id)
                          .first
                          .title),
              actions: [
                IconButton(
                  onPressed: () => setState(() {
                    isCompleated = !isCompleated;
                  }),
                  icon: !isCompleated
                      ? Icon(Icons.circle_outlined)
                      : Icon(Icons.check_circle),
                  color: !isCompleated ? Colors.blueGrey : Colors.greenAccent,
                ),
                IconButton(
                  onPressed: () => setState(() {
                    isImortant = !isImortant;
                  }),
                  icon: !isImortant
                      ? Icon(Icons.star_border_rounded)
                      : Icon(Icons.star_rounded),
                  color: !isImortant ? Colors.blueGrey : Colors.yellow,
                ),
              ],
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.fromLTRB(10, 10, 10, 5),
                    child: TextFormField(
                      controller: titleTextField,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30)),
                              borderSide: BorderSide()),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromARGB(255, 20, 33, 61),
                                  width: 2),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(35))),
                          labelText: 'عنوان',
                          labelStyle: TextStyle(
                              color: Color.fromARGB(255, 20, 33, 61))),
                      textDirection: TextDirection.ltr,
                      textAlign: TextAlign.right,
                      cursorColor: Color.fromARGB(255, 252, 163, 17),
                      maxLength: 50,
                      maxLines: 1,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                    child: TextFormField(
                      controller: lessonTextField,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30)),
                              borderSide: BorderSide()),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromARGB(255, 20, 33, 61),
                                  width: 2),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(35))),
                          labelText: 'درس',
                          labelStyle: TextStyle(
                              color: Color.fromARGB(255, 20, 33, 61))),
                      textDirection: TextDirection.ltr,
                      textAlign: TextAlign.right,
                      cursorColor: Color.fromARGB(255, 252, 163, 17),
                      maxLength: 50,
                      maxLines: 1,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                    child: TextFormField(
                      controller: rangeTextField,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30)),
                              borderSide: BorderSide()),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromARGB(255, 20, 33, 61),
                                  width: 2),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(35))),
                          labelText: 'محدوده',
                          labelStyle: TextStyle(
                              color: Color.fromARGB(255, 20, 33, 61))),
                      textDirection: TextDirection.ltr,
                      textAlign: TextAlign.right,
                      cursorColor: Color.fromARGB(255, 252, 163, 17),
                      maxLength: 50,
                      maxLines: 1,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                    child: TextFormField(
                      controller: descriptionTextField,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30)),
                              borderSide: BorderSide()),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromARGB(255, 20, 33, 61),
                                  width: 2),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(35))),
                          labelText: 'توضیحات',
                          labelStyle: TextStyle(
                              color: Color.fromARGB(255, 20, 33, 61))),
                      textDirection: TextDirection.ltr,
                      textAlign: TextAlign.right,
                      cursorColor: Color.fromARGB(255, 252, 163, 17),
                      maxLength: 250,
                      maxLines: 5,
                    ),
                  ),
                  Container(
                      margin: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                      child: Column(
                        children: [
                          ListTile(
                            title: Text("تکلیف"),
                            leading: Radio(
                              groupValue: categoryId,
                              fillColor: MaterialStateColor.resolveWith(
                                  (states) =>
                                      Color.fromARGB(255, 252, 163, 17)),
                              onChanged: (int? value) {
                                setState(() {
                                  categoryId = value!;
                                });
                              },
                              value: 1,
                            ),
                          ),
                          ListTile(
                            title: Text("امتحان"),
                            leading: Radio(
                              groupValue: categoryId,
                              fillColor: MaterialStateColor.resolveWith(
                                  (states) =>
                                      Color.fromARGB(255, 252, 163, 17)),
                              onChanged: (int? value) {
                                setState(() {
                                  categoryId = value!;
                                });
                              },
                              value: 2,
                            ),
                          ),
                          ListTile(
                            title: Text("مطالعه"),
                            leading: Radio(
                              groupValue: categoryId,
                              fillColor: MaterialStateColor.resolveWith(
                                  (states) =>
                                      Color.fromARGB(255, 252, 163, 17)),
                              onChanged: (int? value) {
                                setState(() {
                                  categoryId = value!;
                                });
                              },
                              value: 3,
                            ),
                          ),
                          ListTile(
                            title: Text("پیش مطالعه"),
                            leading: Radio(
                              groupValue: categoryId,
                              fillColor: MaterialStateColor.resolveWith(
                                  (states) =>
                                      Color.fromARGB(255, 252, 163, 17)),
                              onChanged: (int? value) {
                                setState(() {
                                  categoryId = value!;
                                });
                              },
                              value: 4,
                            ),
                          ),
                          ListTile(
                            title: Text("دسته بندی نشده"),
                            leading: Radio(
                              groupValue: categoryId,
                              fillColor: MaterialStateColor.resolveWith(
                                  (states) =>
                                      Color.fromARGB(255, 252, 163, 17)),
                              onChanged: (int? value) {
                                setState(() {
                                  categoryId = value!;
                                });
                              },
                              value: 0,
                            ),
                          ),
                        ],
                      )),
                  Container(
                    width: MediaQuery.of(context).size.width - 20,
                    height: (MediaQuery.of(context).size.height / 10),
                    margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: ElevatedButton(
                      child: Text(routeArgs.id == null ? "افزودن" : "ویرایش"),
                      onPressed: () => saveButtonPressed(context, routeArgs.id),
                      style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          )),
                          backgroundColor: MaterialStateProperty.all(
                              Color.fromARGB(255, 252, 163, 17))),
                    ),
                  ),
                ],
              ),
            )),
        onWillPop: () => _onWillPop(context, routeArgs.categoryid));
  }
}
