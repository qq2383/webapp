import 'package:flutter/material.dart';
import 'package:webapp/webapp.dart';

void main() {
  webappConfig.init();
  webappConfig.title = '';
  webappConfig.appIcon = 'assets/web/logo.png';
  webappConfig.httpStart();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<StatefulWidget> createState() {
    return _MyApp();
  }
}

class _MyApp extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    webappConfig.httpStop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String url =
        'https://www.meiyd11.tv/'; // 'http://localhost:${webappConfig.httpPort}/';
    return MaterialApp(
      home: WebappPage(url),
    );
  }
}
