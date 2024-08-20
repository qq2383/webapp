import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_win_floating/webview.dart';
import 'package:webview_win_floating/webview_win_floating.dart';
import 'package:window_manager/window_manager.dart';

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

  // late Object _controller;

  // void setController(Object controller) {
  //   _controller = controller;
  // }

  WebappWebviewController? _controller;
  WebappWebviewController? get currentController => _controller;
  set currentController(webviewController) {
    _controller = webviewController;
  }

  WinWebViewController? get windows => _controller?.win;
  WebViewController? get app => _controller?.app;
  // var _controller;
  // set controller(var controller) {
  //   _controller = controller;
  // }

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
}

class WebappNavigationDelegate {
  final NavigationRequestCallback? onNavigationRequest;
  final PageEventCallback? onPageStarted;
  final PageEventCallback? onPageFinished;
  final ProgressCallback? onProgress;
  final WebResourceErrorCallback? onWebResourceError;

  PageTitleChangedCallback? onPageTitleChanged;
  FullScreenChangedCallback? onFullScreenChanged;
  final HistoryChangedCallback? onHistoryChanged;
  void Function(UrlChange change)? onUrlChange;
  void Function(HttpAuthRequest request)? onHttpAuthRequest;
  void Function(HttpResponseError error)? onHttpError;

  WebappNavigationDelegate({
    this.onNavigationRequest,
    this.onPageStarted,
    this.onPageFinished,
    this.onProgress,
    this.onWebResourceError,
    // this.onPageTitleChanged,
    this.onFullScreenChanged,
    this.onHistoryChanged,
    this.onUrlChange,
    this.onHttpAuthRequest,
    this.onHttpError,
  });
}

class WebappUserAgent {
  static String init() {
    if (webappConfig.isWindows()) {
      return 'Mozilla/5.0 (Windows) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/127.0.0.0 Safari/537.36';
    } else if (webappConfig.isAndroid()) {
      return 'Mozilla/5.0 (Linux) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/127.0.0.0 Mobile Safari/537.36';
    } else if (webappConfig.isIos()) {
      return 'Mozilla/5.0 (iOS) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/127.0.0.0 Mobile Safari/537.36';
    } else {
      return '';
    }
  }
}

class WebappWebviewController {
  late bool? _isWindows;

  WebappWebviewController() {
    _isWindows = webappConfig.isWindows();
    if (_isWindows!) {
      _win = WinWebViewController();
    } else {
      _app = WebViewController();
    }
  }

  WinWebViewController? _win;
  WinWebViewController get win => _win!;

  WebViewController? _app;
  WebViewController get app => _app!;

  Future<void> addJavaScriptChannel(String name,
      {required JavaScriptMessageCallback callback}) async {
    if (_isWindows!) {
      _win!.addJavaScriptChannel(name, callback: callback);
    } else {
      _app!.addJavaScriptChannel(name, onMessageReceived: callback);
    }
  }

  Future<void> clearCache() async {
    if (_isWindows!) {
      _win!.clearCache();
    } else {
      _app!.clearCache();
    }
  }

  Future<void> clearCookies() async {
    if (_isWindows!) {
      _win!.clearCookies();
    }
  }

  Future<void> clearLocalStorage() async {
    if (_isWindows!) {
      _win!.clearLocalStorage();
    } else {
      _app!.clearLocalStorage();
    }
  }

  Future<String?> currentUrl() async {
    if (_isWindows!) {
      return _win!.currentUrl();
    } else {
      return _app!.currentUrl();
    }
  }

  Future<void> dispose() async {
    if (_isWindows!) {
      _win!.dispose();
    }
  }

  Future<String?> getTitle() async {
    if (_isWindows!) {
      return _win!.getTitle();
    } else {
      return _app!.getTitle();
    }
  }

  Future<void> goBack() async {
    if (_isWindows!) {
      _win!.goBack();
    } else {
      _app!.goBack();
    }
  }

  Future<void> goForward() async {
    if (_isWindows!) {
      _win!.goForward();
    } else {
      _app!.goForward();
    }
  }

  Future<void> loadHtmlString(String html) async {
    if (_isWindows!) {
      _win!.loadHtmlString(html);
    } else {
      _app!.loadHtmlString(html);
    }
  }

  Future<void> loadUrl(String url) async {
    loadRequest_(url);
  }

  Future<void> loadRequest(Uri uri,
      {LoadRequestMethod method = LoadRequestMethod.get,
      Map<String, String> headers = const <String, String>{},
      Uint8List? body}) async {
    if (_isWindows!) {
      _win!.loadRequest(uri, method: method, headers: headers, body: body);
    } else {
      _app!.loadRequest(uri, method: method, headers: headers, body: body);
    }
  }

  Future<void> loadRequest_(String url,
      {LoadRequestMethod method = LoadRequestMethod.get,
      Map<String, String> headers = const <String, String>{},
      Uint8List? body}) async {
    if (_isWindows!) {
      _win!.loadRequest_(url, method: method, headers: headers, body: body);
    } else {
      _app!.loadRequest(Uri.parse(url),
          method: method, headers: headers, body: body);
    }
  }

  Future<void> openDevTools() async {
    if (_isWindows!) {
      _win!.openDevTools();
    }
  }

  Future<void> reload() async {
    if (_isWindows!) {
      _win!.reload();
    } else {
      _app!.reload();
    }
  }

  Future<void> removeJavaScriptChannel(String name) async {
    if (_isWindows!) {
      _win!.removeJavaScriptChannel(name);
    } else {
      _app!.removeJavaScriptChannel(name);
    }
  }

  Future<void> runJavaScript(String javaScriptString) async {
    if (_isWindows!) {
      _win!.runJavaScript(javaScriptString);
    } else {
      _app!.runJavaScript(javaScriptString);
    }
  }

  Future<Object> runJavaScriptReturningResult(String javaScriptString) {
    if (_isWindows!) {
      return _win!.runJavaScriptReturningResult(javaScriptString);
    } else {
      return _app!.runJavaScriptReturningResult(javaScriptString);
    }
  }

  Future<void> setBackgroundColor(Color color) async {
    if (_isWindows!) {
      _win!.setBackgroundColor(color);
    } else {
      _app!.setBackgroundColor(color);
    }
  }

  void setFullScreen(bool bEnable) {
    if (_isWindows!) {
      return _win!.setFullScreen(bEnable);
    }
  }

  Future<void> setJavaScriptMode(JavaScriptMode javaScriptMode) async {
    if (_isWindows!) {
      _win!.setJavaScriptMode(javaScriptMode);
    } else {
      _app!.setJavaScriptMode(javaScriptMode);
    }
  }

  Future<void> setNavigationDelegate(WebappNavigationDelegate delegate) async {
    if (_isWindows!) {
      _win!.setNavigationDelegate(WinNavigationDelegate(
        onNavigationRequest: delegate.onNavigationRequest,
        onPageTitleChanged: delegate.onPageTitleChanged,
        onPageStarted: delegate.onPageStarted,
        onPageFinished: delegate.onPageFinished,
        onFullScreenChanged: delegate.onFullScreenChanged,
        onHistoryChanged: delegate.onHistoryChanged,
        onProgress: delegate.onProgress,
        onWebResourceError: delegate.onWebResourceError,
      ));
    } else {
      _app!.setNavigationDelegate(NavigationDelegate(
        onNavigationRequest: delegate.onNavigationRequest,
        onPageStarted: delegate.onPageStarted,
        onPageFinished: delegate.onPageFinished,
        onProgress: delegate.onProgress,
        onWebResourceError: delegate.onWebResourceError,
        onUrlChange: delegate.onUrlChange,
        onHttpAuthRequest: delegate.onHttpAuthRequest,
        onHttpError: delegate.onHttpError,
      ));
    }
  }

  Future<void> setUserAgent(String? userAgent) async {
    if (_isWindows!) {
      _win!.setUserAgent(userAgent);
    } else {
      _app!.setUserAgent(userAgent);
    }
  }

  Future<void> addUserAgent(String string) async {
    if (!_isWindows!) {
      var agent = await _app?.getUserAgent();
      var agents = agent?.split(' ');
      agents?.add(string);
      var agent0 = agents?.join(' ');
      await _app!.setUserAgent(agent0);
    }
  }
}
