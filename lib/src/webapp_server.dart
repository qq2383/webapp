import 'dart:io';

import 'package:flutter/services.dart';
import 'package:mime/mime.dart';

import 'webapp_config.dart';

class WebappHttpserver {
  static WebappHttpserver start() {
    final https = WebappHttpserver();
    https.init();
    return https;
  }

  void stop() {
    _server.close();
  }

  late HttpServer _server;

  Future<void> init() async {
    _server =
        await HttpServer.bind(InternetAddress.anyIPv4, webappConfig.httpPort);
    webappConfig.httpPort = _server.port;

    _server.listen((request) {
      var router = webappConfig.httpRouter;
      router.route(request);

      send(request.response, router);
    });
  }

  Future<void> send(HttpResponse response, WebappRouter router) async {
    if (router.path == null) {
      response.close();
      return;
    }

    String? mime = lookupMimeType(router.path!);
    if (mime != null) {
      response.headers.add('Content-Type', '$mime, charset=utf-8');
    }

    Uint8List? data = await loadFile(router.path!);
    if (data != null) {
      var buffer = data.buffer;
      response.add(buffer.asUint8List());
    }
    response.close();
  }

  Future<Uint8List?> loadFile(String path) async {
    try {
      ByteData data = await rootBundle.load('${webappConfig.webRoot}$path');
      return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    } catch (_) {}
    return null;
  }
}

abstract interface class WebappRouter {
  String? path;

  void route(HttpRequest request);
}

class WebappDefRouter implements WebappRouter {
  WebappDefRouter();

  @override
  void route(HttpRequest request) {
    String path0 = request.uri.path;
    if (path0.endsWith('/')) {
      path0 += webappConfig.index;
    }
    path = path0;
  }

  @override
  String? path;

}
