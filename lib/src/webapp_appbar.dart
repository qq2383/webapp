import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

import 'webapp_controller.dart';
import 'webapp_config.dart';
import 'webapp_sysbar.dart';

class _PreferredSize extends Size {
  _PreferredSize(this.toolbarHeight, this.bottomHeight)
      : super.fromHeight((toolbarHeight ?? kToolbarHeight) + (bottomHeight ?? 0));

  final double? toolbarHeight;
  final double? bottomHeight;
}

class WebappAppbar extends StatefulWidget implements PreferredSizeWidget {
  WebappAppbar(
      {super.key, required this.controller, this.bottom, this.toolbarHeight})
      : preferredSize =
            _PreferredSize(toolbarHeight, bottom?.preferredSize.height);

  final WebappController controller;
  final PreferredSizeWidget? bottom;
  final double? toolbarHeight;

  @override
  final Size preferredSize;

  @override
  State<StatefulWidget> createState() => _WebappAppbar();
}

class _WebappAppbar extends State<WebappAppbar> {
  late WebappController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _controller,
      builder: (context, value, child) {
        webappConfig.appbarTextSize ??= Theme.of(context).textTheme.titleLarge?.fontSize;
        if (webappConfig.isDesktop()) {
          return DesktopBar(
            controller: _controller,
            value: value,
            bottom: widget.bottom,
          );
        } else if (webappConfig.isApp()) {
          return AppBar(
            backgroundColor: webappConfig.appbarBackground,
            toolbarHeight: widget.toolbarHeight,
            title: webappConfig.appTitle(_controller, value),
            bottom: widget.bottom,
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

class DesktopBar extends StatefulWidget {
  final WebappController controller;
  final WebappValue value;
  final PreferredSizeWidget? bottom;

  const DesktopBar(
      {super.key, required this.controller, required this.value, this.bottom});

  @override
  State<StatefulWidget> createState() {
    return _DesktopBarState();
  }
}

class _DesktopBarState extends State<DesktopBar> with WindowListener {
  late WebappController _controller;
  late WebappValue _value;

  @override
  void initState() {
    super.initState();
    windowManager.addListener(this);
    _controller = widget.controller;
    _value = widget.value;
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }

  @override
  void onWindowUnmaximize() {
    _controller.max = false;
  }

  @override
  Future<void> onWindowMaximize() async {
    _controller.max = true;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: webappConfig.appbarBackground,
        child: Offstage(
          offstage: _value.fullScreen,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // const SizedBox(width: NavigationToolbar.kMiddleSpacing),
                  Expanded(
                    child: DragToMoveArea(
                      child: Container(
                        padding: const EdgeInsets.only(
                            left: NavigationToolbar.kMiddleSpacing),
                        child: webappConfig.windowsTitle(_controller, _value),
                      ),
                    ),
                  ),
                  webappConfig.sysTitleHide
                      ? WebappSysBar(max: _value.max)
                      : const SizedBox.shrink(),
                  const SizedBox(width: NavigationToolbar.kMiddleSpacing)
                ],
              ),
              const SizedBox(width: NavigationToolbar.kMiddleSpacing),
              widget.bottom != null ? widget.bottom! : const SizedBox.shrink(),
              // widget.bottom != null ? widget.bottom! : const SizedBox.shrink(),
            ],
          ),
        ) // bottom: webappConfig,
        );
  }
}
