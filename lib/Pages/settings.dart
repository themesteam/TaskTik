import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../Components/BottomBar.dart';

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('درباره ما'),
        centerTitle: true,
      ),
      body: Container(
          margin: EdgeInsets.all(15),
          alignment: Alignment.topRight,
          child: Column(
            children: [
              Text(
                'سلام!\n  تسک تیک یه برنامه اوپن سورس و رایگانه که به شما کمک میکنه به روش بولت ژورنال کارای تحصیلی تون رو انجام بدید. هنوز برنامه خفنی نیستیم ولی با کمک شما میشیم. شما میتونید پیشنهادات و مشکلاتی رو که توی برنامه دیدید به ایمیل پایین ارسال کنید. لینک گیت هابمون ورو  هم براتون همون پایین گذاشتیم!روی آیکون هاشون کلیک کنید کپی میشن! \nموفق باشید.',
                textAlign: TextAlign.justify,
                style: TextStyle(fontWeight: FontWeight.bold),
                textDirection: TextDirection.rtl,
              ),
              Row(
                children: [
                  IconButton(
                      onPressed: () {
                        Clipboard.setData(
                            ClipboardData(text: "mailto:info@themesteam.ir"));
                      },
                      icon: Icon(Icons.mail_rounded)),
                  Text(
                    "mailto:info@themesteam.ir",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )
                ],
              ),
              Row(
                children: [
                  IconButton(
                      onPressed: () {
                        Clipboard.setData(ClipboardData(
                            text: "https://github.com/themesteam/TaskTik"));
                      },
                      icon: Icon(Icons.code_rounded)),
                  Text(
                    "https://github.com/themesteam/TaskTik",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )
                ],
              )
            ],
          )),
      bottomNavigationBar: BottomBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {Navigator.pushNamed(context, '/tasks')},
        child: Icon(Icons.home_filled),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
