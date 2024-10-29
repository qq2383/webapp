import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:window_manager/window_manager.dart';

import 'webapp_config.dart';

class WebappValue {
  WebappValue();

  String title = '';
  bool fullScreen = false;
  bool max = false;
}

class WebappController extends ValueNotifier<WebappValue> {
  WebappController() : super(WebappValue()) {
    title = _title;
  }

  final String _title = webappConfig.title;
  String get title => value.title;
  set title(String title) {
    value.title = title;
    notifyListeners();
  }

  void resetTitle(String title) {
    if (!webappConfig.sysTitleHide) {
      windowManager.setTitle(_title == '' ? title : '$_title - $title');
      return;
    }
    if (title != '') {
      this.title = _title == '' ? title : '$_title - $title';
    }
  }

  Future<void> resetTitle_() async {
    String? title = await getTitle();
    resetTitle(title ?? '');
  }

  bool get max => value.max;
  set max(bool max) {
    value.max = max;
    notifyListeners();
  }

  bool get fullScreen => value.fullScreen;
  set fullScreen(bool fullScreen) {
    value.fullScreen = fullScreen;
    notifyListeners();
  }

  Future<void> setFullScreen(bool fill) async {
    await windowManager.setFullScreen(fill);
    if (!fill) {
      await windowManager.restore();
    }
    fullScreen = fill;
  }

  InAppWebViewController? webViewController;

  String? _home;
  void setHome(String url) {
    _home = url;
  }

  void loadUrl(String url) {
    webViewController?.loadUrl(urlRequest: URLRequest(url: WebUri(url)));
  }

  void back() {
    webViewController?.goBack();
  }

  void home() {
    loadUrl(_home!);
  }

  void refresh() {
    webViewController?.reload();
  }

  Future<String?>? getTitle() {
    return webViewController?.getTitle();
  }

  @override
  void dispose() {
    webViewController?.dispose();
    super.dispose();
  }
}

