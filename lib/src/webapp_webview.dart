import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_win_floating/webview_win_floating.dart';

import '../webapp.dart';

class WebappWebview extends StatefulWidget {
  const WebappWebview({super.key, required this.controller, this.url});

  final String? url;
  final WebappController controller;

  @override
  State<StatefulWidget> createState() => _WebappWebview();
}

class _WebappWebview extends State<WebappWebview> {
  final webviewController = WebappWebviewController();
  late WebappController _controller;

  @override
  void initState() {
    super.initState();

    _controller = widget.controller;
    _controller.currentController = webviewController;

    _controller.setHome(widget.url ?? '');

    webviewController.setJavaScriptMode(JavaScriptMode.unrestricted);

    webappConfig.navigationDelegate.onFullScreenChanged ??= (fill) {
      _controller.setFullScreen(fill);
    };
    webappConfig.navigationDelegate.onPageTitleChanged ??= (title) {
      _controller.resetTitle(title);
    };
    webappConfig.navigationDelegate.onUrlChange ??= (change) {
      _controller.resetTitle_();
    };
    webviewController.setNavigationDelegate(webappConfig.navigationDelegate);

    if (webappConfig.userAgent != null) {
      webviewController.setUserAgent(webappConfig.userAgent);
    }

    if (widget.url == null) {
      _controller.home();
    } else {
      _controller.loadUrl(widget.url!);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant WebappWebview oldWidget) {
    super.didUpdateWidget(oldWidget);
    _controller.currentController = webviewController;
  }

  @override
  Widget build(BuildContext context) {
    if (webappConfig.isWindows()) {
      return WinWebViewWidget(
        controller: webviewController.win,
      );
    } else if (webappConfig.isAndroid() || webappConfig.isIos()) {
      return WebViewWidget(controller: webviewController.app);
    }
    return const Text('The devices are not supported!');
  }
}
