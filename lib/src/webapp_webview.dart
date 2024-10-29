import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import 'webapp_config.dart';
import 'webapp_controller.dart';

class WebappWebview extends StatefulWidget {
  const WebappWebview({super.key, required this.controller, required this.url});

  final WebappController controller;
  final String url;

  @override
  State<WebappWebview> createState() => _WebappWebviewState();
}

class _WebappWebviewState extends State<WebappWebview> {
  late WebappController _controller;

  InAppWebViewSettings settings = InAppWebViewSettings(
      // isInspectable: kDebugMode,
      mediaPlaybackRequiresUserGesture: false,
      allowsInlineMediaPlayback: true,
      iframeAllow: "camera; microphone",
      iframeAllowFullscreen: true);

  PullToRefreshController? pullToRefreshController;

  @override
  void initState() {
    super.initState();

    _controller = widget.controller;

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
                _controller.webViewController?.reload();
              } else if (defaultTargetPlatform == TargetPlatform.iOS) {
                _controller.webViewController?.loadUrl(
                    urlRequest: URLRequest(
                        url: await _controller.webViewController?.getUrl()));
              }
            },
          );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: InAppWebView(
        webViewEnvironment: webappConfig.webViewEnvironment,
        initialUrlRequest: URLRequest(url: WebUri(widget.url)),
        initialSettings: settings,
        pullToRefreshController: pullToRefreshController,
        onWebViewCreated: (controller) {
          _controller.webViewController = controller;
        },
        onLoadStart: (controller, uri) {
          webappConfig.delegate!.onLoadStart!(_controller, uri);
        },
        onLoadStop: (controller, uri) {
          webappConfig.delegate!.onLoadStop!(_controller, uri);
        },
        onProgressChanged: (controller, progress) {
          webappConfig.delegate!.onProgressChanged!(_controller, progress);
        },
        onEnterFullscreen: (controller) {
          webappConfig.delegate!.onEnterFullscreen!(_controller);
        },
        onExitFullscreen: (controller) {
          webappConfig.delegate!.onExitFullscreen!(_controller);
        },
        onTitleChanged: (controller, title) {
          webappConfig.delegate!.onTitleChanged!(_controller, title);
        },
        onReceivedHttpError: (controller, request, errorResponse) {
          webappConfig.delegate!.onReceivedHttpError!(
              _controller, request, errorResponse);
        },
        onDownloadStartRequest: (controller, request) {
          webappConfig.delegate!.onDownloadStartRequest!(_controller, request);
        },
      ),
    );
  }
}
