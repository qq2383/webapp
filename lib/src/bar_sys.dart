import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

class SysBar extends StatefulWidget {
  const SysBar({super.key, required this.max});

  final bool max;

  @override
  State<StatefulWidget> createState() => _SysBarState();
}

class _SysBarState extends State<SysBar> {
  late bool isMax;

  @override
  void initState() {
    super.initState();
    isMax = widget.max;
  }

  Future<void> getMaxStatus() async {
    isMax = await windowManager.isMaximized();
  }

  Future<void> maxOrRestore() async {
    if (isMax) {
      await windowManager.restore();
    } else {
      await windowManager.maximize();
    }
  }

  Future<void> restore() async {
    await windowManager.restore();
  }

  Future<void> refresh() async {
    await getMaxStatus();
    setState(() {});
  }

  void close() {
    windowManager.close();
  }

  void minimize() {
    windowManager.minimize();
  }

  @override
  Widget build(BuildContext context) {
    ButtonStyle style = ButtonStyle(
        shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))));
    return FutureBuilder(
        future: getMaxStatus(),
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Row(
              children: [
                setMinimize(style),
                const SizedBox(
                  width: 6,
                ),
                setMaximize(style),
                const SizedBox(
                  width: 6,
                ),
                IconButton(
                  onPressed: close,
                  icon: const Icon(
                    Icons.close,
                  ),
                  style: style,
                  color: Colors.white,
                )
              ],
            );
          }
          return Container();
        });
  }

  Widget setMaximize(ButtonStyle style) {
    return isMax
        ? IconButton(
            onPressed: maxOrRestore,
            icon: const Icon(
              Icons.fullscreen_exit,
            ),
            style: style,
            color: Colors.white,
          )
        : IconButton(
            onPressed: maxOrRestore,
            icon: const Icon(
              Icons.fullscreen,
            ),
            style: style,
            color: Colors.white,
          );
  }

  Widget setMinimize(ButtonStyle style) {
    return IconButton(
      onPressed: minimize,
      icon: const Icon(Icons.remove),
      style: style,
      color: Colors.white,
    );
  }
}
