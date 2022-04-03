import 'package:flutter/material.dart';
import 'package:tasktik/Components/BottomBar.dart';
import 'package:tasktik/main.dart';
import '../Components/BottomBar.dart';

class Categories extends StatefulWidget {
  const Categories({Key? key}) : super(key: key);

  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            title: Text('دسته بندی ها'),
            centerTitle: true,
          ),
          body: Directionality(
              textDirection: TextDirection.rtl,
              child: ListView(
                children: [
                  InkWell(
                    child: Container(
                      child: Row(children: [
                        Icon(
                          Icons.library_books_rounded,
                          color: Colors.yellow,
                        ),
                        Text(
                          "تکالیف",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        )
                      ]),
                      //margin: EdgeInsets.only(top: 20),
                      padding: EdgeInsets.all(15),
                    ),
                    onTap: () => {
                      Navigator.pushNamed(context, '/category',
                          arguments: CategoryRoute(id: 1))
                    },
                  ),
                  InkWell(
                    child: Container(
                      child: Row(children: [
                        Icon(
                          Icons.quiz_rounded,
                          color: Colors.blue,
                        ),
                        Text(
                          " امتحانات",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        )
                      ]),
                      padding: EdgeInsets.all(15),
                    ),
                    onTap: () => {
                      Navigator.pushNamed(context, '/category',
                          arguments: CategoryRoute(id: 2))
                    },
                  ),
                  InkWell(
                    child: Container(
                      child: Row(children: [
                        Icon(
                          Icons.book_rounded,
                          color: Colors.red,
                        ),
                        Text(
                          "مطالعه",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        )
                      ]),
                      padding: EdgeInsets.all(15),
                    ),
                    onTap: () => {
                      Navigator.pushNamed(context, '/category',
                          arguments: CategoryRoute(id: 3))
                    },
                  ),
                  InkWell(
                    child: Container(
                      child: Row(children: [
                        Icon(
                          Icons.read_more_rounded,
                          color: Colors.green,
                        ),
                        Text(
                          "پیش مطالعه",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        )
                      ]),
                      //margin: EdgeInsets.only(top: 20),
                      padding: EdgeInsets.all(15),
                    ),
                    onTap: () => {
                      Navigator.pushNamed(context, '/category',
                          arguments: CategoryRoute(id: 4))
                    },
                  ),
                  InkWell(
                    child: Container(
                      child: Row(children: [
                        Icon(
                          Icons.all_inbox_rounded,
                          color: Colors.brown,
                        ),
                        Text(
                          "دسته بندی نشده",
                          style: TextStyle(
                              //color: Colors.lightBlue,
                              //fontFamily: 'Tanha',
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        )
                      ]),
                      //margin: EdgeInsets.only(top: 20),
                      padding: EdgeInsets.all(15),
                    ),
                    onTap: () => {
                      Navigator.pushNamed(context, '/category',
                          arguments: CategoryRoute(id: 0))
                    },
                  ),
                ],
              )),
          bottomNavigationBar: BottomBar(),
          floatingActionButton: FloatingActionButton(
            onPressed: () => {Navigator.pushNamed(context, '/tasks')},
            child: Icon(Icons.home_filled),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
        ),
        onWillPop: () async {
          Navigator.pushNamed(context, '/tasks');
          return true;
        });
  }
}
