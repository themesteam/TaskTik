import 'package:flutter/material.dart';
import '../main.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({Key? key}) : super(key: key);

  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Colors.white,
      shape: CircularNotchedRectangle(),
      notchMargin: 10,
      clipBehavior: Clip.antiAlias,
      child: Container(
        height: 65,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: 55,
              width: MediaQuery.of(context).size.width / 2 - 30,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: Icon(Icons.widgets_rounded, color: Colors.blueGrey),
                    onPressed: () =>
                        {Navigator.pushNamed(context, '/categories')},
                  ),
                ],
              ),
            ),
            Container(
              height: 55,
              width: MediaQuery.of(context).size.width / 2 - 30,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                      icon: Icon(Icons.info_outline_rounded,
                          color: Colors.blueGrey),
                      onPressed: () =>
                          {Navigator.pushNamed(context, '/settings')}),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
