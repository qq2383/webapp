import 'package:flutter/material.dart';

import '../webapp.dart';

class WebAppWidget extends StatefulWidget {
  const WebAppWidget(this.url, {super.key});

  final String url;

  @override
  State<WebAppWidget> createState() => _WebAppState();
}

class _WebAppState extends State<WebAppWidget> {
  final _controller = WebappController();

  @override
  void initState() {
    super.initState();
    _controller.setHome(widget.url);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    PreferredSizeWidget? bottom;
    if (webappConfig.bottom != null) {
      bottom = webappConfig.bottom!(_controller);
    }

    return Scaffold(
      appBar: !webappConfig.titleHide
          ? WebappAppbar(controller: _controller, bottom: bottom, toolbarHeight: webappConfig.toolbarHeight,)
          : null,
      body: Center(
        child: WebappWebview(controller: _controller, url: widget.url),
      ),
      bottomNavigationBar: webappConfig.isApp()
          ? webappConfig.navigation(_controller, null)
          : const SizedBox.shrink(),
    );
  }
}
