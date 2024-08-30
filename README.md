# Webapp

使用 HTML/CSS 和 JavaScript 构建跨平台 App

- Windows 11
- android
- iOS

## 技术支持

请到 [这里](https://webapp.tianqilabs.com)

## Installation

Add this to your package's pubspec.yaml file:

```yaml
dependencies:
  webapp:
    git:
      url: https://github.com/qq2383/webapp.git
      ref: master
``` 

# Example

```
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
    String url = 'http://localhost:${webappConfig.httpPort}/';
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(),
      home: WebAppWidget(url),
    );
  }
}
```

## 说明

webappConfig.title ``窗口标题``

webappConfig.appIcon ``图标``

webappConfig.httpStart() ``开启 Http Server``

webappConfig.httpStop() ``关闭 Http Server``

WebAppWidget(url)   ``WebView Widget，url: 链接``

## License

> BSD-3-Clause license