import 'package:flutter/material.dart';
import 'package:lizi_site/editor.dart';

import 'home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lizi - 可快速落地的粒子动画解决方案',
      theme: ThemeData(
        primaryColor: Color(0xff0352a4),
        primarySwatch: Colors.blue,
      ),
      routes: {
        '/editor': (context) => MyEditorPage(),
      },
      home: MyHomePage(),
    );
  }
}
