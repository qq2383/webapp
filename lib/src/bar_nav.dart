import 'package:flutter/material.dart';

import '../webapp.dart';

class WebappNavigationBar extends StatefulWidget {
  const WebappNavigationBar({super.key, required this.controller});

  final WebappController controller;

  @override
  State<StatefulWidget> createState() => _WebappNavigationBar();
}

class _WebappNavigationBar extends State<WebappNavigationBar> {
  late WebappController _controller;

  final Color _color = webappConfig.isDesktop() ? Colors.white : Colors.black;
  final ButtonStyle _style = ButtonStyle(
      shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))));

  @override
  void initState() {
    super.initState();
    _controller = widget.controller;
  }

  void back() {
    _controller.back();
  }

  void home() {
    _controller.home();
  }

  void refresh() {
    _controller.refresh();
  }

  void jumpTo(String url) {}

  @override
  Widget build(BuildContext context) {
    return Container(
      height: webappConfig.isDesktop()
          ? kToolbarHeight
          : kBottomNavigationBarHeight,
      // padding: const EdgeInsets.only(top: 12, bottom: 12),
      color:
          webappConfig.isApp() ? const Color(0xfff3edf6) : Colors.transparent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            onPressed: back,
            icon: const Icon(Icons.arrow_back),
            color: _color,
            style: _style,
          ),
          const SizedBox(
            width: 6,
          ),
          IconButton(
            onPressed: home,
            icon: const Icon(Icons.home),
            color: _color,
            style: _style,
          ),
          const SizedBox(
            width: 6,
          ),
          IconButton(
            onPressed: refresh,
            icon: const Icon(Icons.refresh),
            color: _color,
            style: _style,
          ),
        ],
      ),
    );
  }
}

class IconTextButton extends StatefulWidget {
  const IconTextButton(
      {super.key,
      required this.text,
      required this.icon,
      this.color,
      required this.onPressed});

  final String text;
  final Icon icon;
  final Color? color;
  final VoidCallback onPressed;

  @override
  State<StatefulWidget> createState() => _IconTextButton();
}

class _IconTextButton extends State<IconTextButton> {
  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: widget.text,
      child: Column(
        children: [
          IconButton(onPressed: widget.onPressed, icon: widget.icon),
          Text(widget.text),
        ],
      ),
    );
  }
}
