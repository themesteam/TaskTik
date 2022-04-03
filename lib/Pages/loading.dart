import 'dart:core';
import '../main.dart';
import 'package:flutter/material.dart';

class Loading extends StatefulWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 3), (() {
      if (loading == true) {
        Navigator.pushNamed(context, '/tasks');
        loading = false;
      }
    }));
    return Scaffold(
      body: Center(
        child: Image(
          image: AssetImage('assets/TaskTik.png'),
          width: MediaQuery.of(context).size.width / 3,
          height: MediaQuery.of(context).size.height / 3,
        ),
      ),
    );
  }
}
