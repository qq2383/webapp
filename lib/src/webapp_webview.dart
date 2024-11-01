import 'dart:collection';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';

import 'webapp_javascript.dart';
import 'webapp_config.dart';
import 'webapp_controller.dart';

class WebappWebview extends StatefulWidget {
  const WebappWebview({super.key, required this.controller, required this.url});

  final WebappController controller;
  final String url;

  @override
  State<WebappWebview> createState() => _WebappWebviewState();
}

class _WebappWebviewState extends State<WebappWebview>
    with WidgetsBindingObserver {
  InAppWebViewController? _webViewController;

  InAppWebViewSettings settings = InAppWebViewSettings(
      // isInspectable: kDebugMode,
      mediaPlaybackRequiresUserGesture: false,
      allowsInlineMediaPlayback: true,
      iframeAllow: "camera; microphone",
      supportMultipleWindows: true,
      iframeAllowFullscreen: true);

  PullToRefreshController? pullToRefreshController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    pullToRefreshController = kIsWeb ||
            ![TargetPlatform.iOS, TargetPlatform.android]
                .contains(defaultTargetPlatform)
        ? null
        : PullToRefreshController(
            settings: PullToRefreshSettings(
              color: Colors.blue,
            ),
            onRefresh: () async {
              if (defaultTargetPlatform == TargetPlatform.android) {
                _webViewController?.reload();
              } else if (defaultTargetPlatform == TargetPlatform.iOS) {
                _webViewController?.loadUrl(
                    urlRequest:
                        URLRequest(url: await _webViewController?.getUrl()));
              }
            },
          );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  bool isAndroid() {
    return !kIsWeb && defaultTargetPlatform == TargetPlatform.android;
  }

  bool isWindows() {
    return !kIsWeb && defaultTargetPlatform == TargetPlatform.windows;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_webViewController != null && (isAndroid() || isWindows())) {
      if (state == AppLifecycleState.paused) {
        pauseAll();
      } else {
        resumeAll();
      }
    }
  }

  void pauseAll() {
    if (isAndroid() || isWindows()) {
      _webViewController?.pause();
    }
    pauseTimers();
  }

  void resumeAll() {
    if (isAndroid() || isWindows()) {
      _webViewController?.resume();
    }
    resumeTimers();
  }

  void pause() {
    if (isAndroid() || isWindows()) {
      _webViewController?.pause();
    }
  }

  void resume() {
    if (isAndroid() || isWindows()) {
      _webViewController?.resume();
    }
  }

  void pauseTimers() {
    if (!isWindows()) {
      _webViewController?.pauseTimers();
    }
  }

  void resumeTimers() {
    if (!isWindows()) {
      _webViewController?.resumeTimers();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: InAppWebView(
          webViewEnvironment: webappConfig.webViewEnvironment,
          initialUrlRequest: URLRequest(url: WebUri(widget.url)),
          initialSettings: settings,
          initialUserScripts: UnmodifiableListView<UserScript>([
            UserScript(source: """
            (function() {                  
              function Webapp() {
                
              }
              Webapp.prototype.postMessage = function(name, args, callee) {
                  var data = JSON.stringify(args);
                  window.flutter_inappwebview.callHandler('_webapp', name, data)
                    .then(function(data) {
                      if (callee) {
                        callee(data);
                      }
                    });
              };
              window.webapp = new Webapp();  
            })();            
          """, injectionTime: UserScriptInjectionTime.AT_DOCUMENT_START)
          ]),
          pullToRefreshController: pullToRefreshController,
          onWebViewCreated: (controller) async {
            _webViewController = controller;
            widget.controller.webViewController = _webViewController;

            controller.addJavaScriptHandler(
                handlerName: '_webapp',
                callback: (args) {
                  dynamic result;
                  if (args.length == 2) {
                    var name = args[0];
                    if (JavaScriptHandler.handles.containsKey(name)) {
                      var method = JavaScriptHandler.handles[name];
                      var data = jsonDecode(args[1]);
                      result = jsonEncode(method(data));
                    }
                  }
                  // return data to the JavaScript side!
                  return result;
                });
          },
          onLoadStart: (controller, uri) {
            if (webappConfig.delegate.onLoadStart != null) {
              webappConfig.delegate.onLoadStart!(widget.controller, uri);
            }
          },
          onLoadStop: (controller, uri) {
            if (webappConfig.delegate.onLoadStop != null) {
              webappConfig.delegate.onLoadStop!(widget.controller, uri);
            }
          },
          onProgressChanged: (controller, progress) {
            if (webappConfig.delegate.onProgressChanged != null) {
              webappConfig.delegate.onProgressChanged!(
                  widget.controller, progress);
            }
          },
          onEnterFullscreen: (controller) {
            if (webappConfig.delegate.onEnterFullscreen != null) {
              webappConfig.delegate.onEnterFullscreen!(widget.controller);
            }
          },
          onExitFullscreen: (controller) {
            if (webappConfig.delegate.onExitFullscreen != null) {
              webappConfig.delegate.onExitFullscreen!(widget.controller);
            }
          },
          onTitleChanged: (controller, title) {
            if (webappConfig.delegate.onTitleChanged != null) {
              webappConfig.delegate.onTitleChanged!(widget.controller, title);
            }
          },
          onReceivedHttpError: (controller, request, errorResponse) {
            if (webappConfig.delegate.onReceivedHttpError != null) {
              webappConfig.delegate.onReceivedHttpError!(
                  widget.controller, request, errorResponse);
            }
          },
          onDownloadStartRequest: (controller, request) {
            if (webappConfig.delegate.onDownloadStartRequest != null) {
              webappConfig.delegate.onDownloadStartRequest!(
                  widget.controller, request);
            }
          },
          shouldOverrideUrlLoading: (controller, navigationAction) async {
            var uri = navigationAction.request.url!;

            if (![
              "http",
              "https",
              "file",
              "chrome",
              "data",
              "javascript",
              "about"
            ].contains(uri.scheme)) {
              if (await canLaunchUrl(uri)) {
                // Launch the App
                await launchUrl(
                  uri,
                );
                // and cancel the request
                return NavigationActionPolicy.CANCEL;
              }
            }

            return NavigationActionPolicy.ALLOW;
          },
          onPermissionRequest: (controller, request) async {
            return PermissionResponse(
                resources: request.resources,
                action: PermissionResponseAction.GRANT);
          },
          onConsoleMessage: (controller, message) {
            if (webappConfig.delegate.onConsoleMessage != null) {
              webappConfig.delegate.onConsoleMessage!(
                  widget.controller, message);
            }
          }),
    );
  }
}
