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
  late WebappController _controller;

  @override
  void initState() {
    super.initState();

    _controller = widget.controller;
    _controller.setHome(widget.url ?? '');

    var webviewController = _controller.webvieController;
    webviewController?.setJavaScriptMode(JavaScriptMode.unrestricted);
    webappConfig.navigationDelegate.onFullScreenChanged ??= (_, fill) {
      _controller.setFullScreen(fill);
    };
    webappConfig.navigationDelegate.onPageTitleChanged ??= (_, title) {
      _controller.resetTitle(title);
    };
    webappConfig.navigationDelegate.onUrlChange ??= (_, change) {
      _controller.resetTitle_();
    };
    webviewController?.setWebappNavigationDelegate(webappConfig.navigationDelegate);

    if (webappConfig.userAgent != null) {
      webviewController?.setUserAgent(webappConfig.userAgent);
    }

    _controller.home();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant WebappWebview oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    if (webappConfig.isWindows()) {
      return WinWebViewWidget(
        controller: _controller.windows,
      );
    } else if (webappConfig.isAndroid() || webappConfig.isIos()) {
      return WebViewWidget(controller: _controller.app);
    }
    return const Text('The devices are not supported!');
  }
}
