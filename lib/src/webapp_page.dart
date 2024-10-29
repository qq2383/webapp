import 'package:flutter/material.dart';

import 'webapp_appbar.dart';
import 'webapp_config.dart';
import 'webapp_controller.dart';
import 'webapp_webview.dart';

class WebappPage extends StatefulWidget {
  final String url;

  const WebappPage(String this.url, {super.key}) ;
  

  @override
  State<StatefulWidget> createState() => _WebappPageState();

}

class _WebappPageState extends State<WebappPage> {
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