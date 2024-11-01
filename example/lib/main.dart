import 'package:flutter/material.dart';
import 'package:webapp/webapp.dart';

void main() {
  webappConfig.init();
  webappConfig.title = '';
  webappConfig.appIcon = 'assets/web/logo.png';
  webappConfig.httpStart();

  JavaScriptHandler.add('version', (data) {
    return {'version': '0.0.3'};
  });

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
    String url = 'http://localhost:${webappConfig.httpPort}/';
        // 'https://www.meiyd11.tv/';
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(),
      home: WebappPage(url),
    );
  }
}
