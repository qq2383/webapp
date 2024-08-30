import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_win_floating/webview.dart';
import 'package:webview_win_floating/webview_win_floating.dart';
import 'package:window_manager/window_manager.dart';

import 'webapp_delegate.dart';
import 'config.dart';

class WebappValue {
  WebappValue();

  String title = '';
  bool fullScreen = false;
  bool max = false;
}

class WebappController extends ValueNotifier<WebappValue> {
  WebappController() : super(WebappValue()) {
    title = _title;
    if (webappConfig.isWindows()) {
      _controller = _WinWebviewController();
    } else if (webappConfig.isApp()) {
      _controller = _AppWebviewController();
    }
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
    String? title = await _controller?.getTitle();
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

  WebappWebviewFactory? _controller;
  WebappWebviewFactory? get webvieController => _controller;

  WinWebViewController get windows => _controller as WinWebViewController;
  WebViewController get app => _controller as WebViewController;

  String? _home;
  void setHome(String url) {
    _home = url;
  }

  void loadUrl(String url) {
    _controller?.loadUrl(url);
  }

  void back() {
    _controller?.goBack();
  }

  void home() {
    loadUrl(_home!);
  }

  void refresh() {
    _controller?.reload();
  }

  Future<String?>? getTitle() {
    return _controller?.getTitle();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}

abstract class WebappWebviewFactory {
  Future<void> clearCache();
  Future<void> clearCookies();
  Future<void> clearLocalStorage();
  Future<String?> currentUrl();
  Future<void> dispose();
  Future<String?> getTitle();
  Future<void> goBack();
  Future<void> goForward();
  Future<void> loadHtmlString(String html);
  Future<void> loadUrl(String url);
  Future<void> loadRequest(Uri uri,
      {LoadRequestMethod method = LoadRequestMethod.get,
      Map<String, String> headers = const <String, String>{},
      Uint8List? body});
  Future<void> loadRequest_(String url,
      {LoadRequestMethod method = LoadRequestMethod.get,
      Map<String, String> headers = const <String, String>{},
      Uint8List? body});
  Future<void> openDevTools();
  Future<void> reload();
  Future<void> removeJavaScriptChannel(String name);
  Future<void> runJavaScript(String javaScriptString);
  Future<Object> runJavaScriptReturningResult(String javaScriptString);
  Future<void> setBackgroundColor(Color color);
  void setFullScreen(bool bEnable);
  Future<void> setJavaScriptMode(JavaScriptMode javaScriptMode);
  Future<void> setWebappNavigationDelegate(WebappNavigationDelegate delegate);
  Future<void> setUserAgent(String? userAgent);
}

class _WinWebviewController extends WinWebViewController
    implements WebappWebviewFactory {
  @override
  Future<void> loadUrl(String url) async {
    loadRequest_(url);
  }

  @override
  Future<void> setWebappNavigationDelegate(
      WebappNavigationDelegate delegate) async {
    setNavigationDelegate(WinNavigationDelegate(
      onNavigationRequest: delegate.onNavigationRequest != null
          ? (navigationRequest) =>
              delegate.onNavigationRequest!(this, navigationRequest)
          : null,
      onPageTitleChanged: delegate.onPageTitleChanged != null
          ? (title) {
              delegate.onPageTitleChanged!(this, title);
            }
          : null,
      onPageStarted: delegate.onPageStarted != null
          ? (url) {
              delegate.onPageStarted!(this, url);
            }
          : null,
      onPageFinished: delegate.onPageFinished != null
          ? (url) {
              delegate.onPageFinished!(this, url);
            }
          : null,
      onFullScreenChanged: delegate.onFullScreenChanged != null
          ? (isFullScreen) {
              delegate.onFullScreenChanged!(this, isFullScreen);
            }
          : null,
      onHistoryChanged: delegate.onHistoryChanged != null
          ? () {
              delegate.onHistoryChanged!(this);
            }
          : null,
      onProgress: delegate.onProgress != null
          ? (progress) {
              delegate.onProgress!(this, progress);
            }
          : null,
      onWebResourceError: delegate.onWebResourceError != null
          ? (error) {
              delegate.onWebResourceError!(this, error);
            }
          : null,
    ));
  }
}

class _AppWebviewController extends WebViewController
    implements WebappWebviewFactory {
  @override
  Future<void> clearCookies() async {}

  @override
  Future<void> dispose() async {}

  @override
  Future<void> loadRequest_(String url,
      {LoadRequestMethod method = LoadRequestMethod.get,
      Map<String, String> headers = const <String, String>{},
      Uint8List? body}) async {
    super.loadRequest(Uri.parse(url),
        method: method, headers: headers, body: body);
  }

  @override
  Future<void> loadUrl(String url) async {
    loadRequest_(url);
  }

  @override
  Future<void> openDevTools() async {}

  @override
  void setFullScreen(bool bEnable) {}

  @override
  Future<void> setWebappNavigationDelegate(
      WebappNavigationDelegate delegate) async {
    setNavigationDelegate(NavigationDelegate(
      onNavigationRequest: delegate.onNavigationRequest != null
          ? (navigationRequest) =>
              delegate.onNavigationRequest!(this, navigationRequest)
          : null,
      onPageStarted: delegate.onPageStarted != null
          ? (url) {
              delegate.onPageStarted!(this, url);
            }
          : null,
      onPageFinished: delegate.onPageFinished != null
          ? (url) {
              delegate.onPageFinished!(this, url);
            }
          : null,
      onProgress: delegate.onProgress != null
          ? (progress) {
              delegate.onProgress!(this, progress);
            }
          : null,
      onWebResourceError: delegate.onWebResourceError != null
          ? (error) {
              delegate.onWebResourceError!(this, error);
            }
          : null,
      onUrlChange: delegate.onUrlChange != null
          ? (change) {
              delegate.onUrlChange!(this, change);
            }
          : null,
      onHttpAuthRequest: delegate.onHttpAuthRequest != null
          ? (request) {
              delegate.onHttpAuthRequest!(this, request);
            }
          : null,
      onHttpError: delegate.onHttpError != null
          ? (error) {
              delegate.onHttpError!(this, error);
            }
          : null,
    ));
  }
}
