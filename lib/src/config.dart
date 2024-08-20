import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

import '../webapp.dart';

enum PlatformType {
  desktop,
  windows,
  macos,
  linux,
  app,
  ios,
  android,
  fuchsia,
  web
}

class WebappConfig {
  WebappConfig();

  String title = '';
  String? appIcon;

  // user windows
  Size? size;
  // bool minimize = true;
  // bool maximize = true;
  bool sysTitleHide = true;
  bool titleHide = false;
  double? toolbarHeight;
  Color appbarBackground = const Color(0xFF3A3B43);
  Color appbarTextColor = Colors.white;
  double? appbarTextSize;

  String? userAgent;
  void setUserAgent(String agent) {
    userAgent = agent;
  }

  WebappController? controller;
  void initController() {
    controller ??= WebappController();
  }

  WebappTitleFunction windowsTitle = webappWinTitle;
  WebappTitleFunction appTitle = webappAppTitle;
  WebappTitleFunction navigation = webappNavigation;
  WebappBottomFunction? bottom;

  String httpAddress = 'localhost';
  int httpPort = 0;
  String webRoot = 'assets/web';
  String index = 'index.html';

  WebappRouter _httpRouter = WebappDefRouter();
  WebappRouter get httpRouter => _httpRouter;
  set httpRouter(router) {
    _httpRouter = router;
  }

  WebappHttpserver? _https;
  void httpStart() {
    _https = WebappHttpserver.start();
  }

  void httpStop() {
    _https?.stop();
  }

  Future<void> _initWindows() async {
    await windowManager.ensureInitialized();

    WindowOptions windowOptions = WindowOptions(
      title: webappConfig.title,
      center: true,
      backgroundColor: Colors.transparent,
      skipTaskbar: false,
      titleBarStyle: webappConfig.sysTitleHide
          ? TitleBarStyle.hidden
          : TitleBarStyle.normal,
    );

    if (webappConfig.size != null) {
      windowManager.setSize(webappConfig.size!);
    }

    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }

  Future<void> _initAndroid() async {}

  late Set<PlatformType> ui;

  void init() {
    WidgetsFlutterBinding.ensureInitialized();
    try {
      switch (Platform.operatingSystem) {
        case 'windows':
          ui = {PlatformType.desktop, PlatformType.windows};
        case 'macos':
          ui = {PlatformType.desktop, PlatformType.macos};
        case 'linux':
          ui = {PlatformType.desktop, PlatformType.linux};
        case 'ios':
          ui = {PlatformType.app, PlatformType.ios};
        case 'fuchsia':
          ui = {PlatformType.app, PlatformType.fuchsia};
        case 'android':
          ui = {PlatformType.app, PlatformType.android};
      }
    } catch (_) {
      ui = {PlatformType.web};
    }
    if (isDesktop()) {
      _initWindows();
    } else if (isAndroid()) {
      _initAndroid();
    }
  }

  bool isDesktop() {
    return ui.contains(PlatformType.desktop);
  }

  bool isApp() {
    return ui.contains(PlatformType.app);
  }

  bool isWindows() {
    return ui.contains(PlatformType.windows);
  }

  bool isMacOs() {
    return ui.contains(PlatformType.macos);
  }

  bool isAndroid() {
    return ui.contains(PlatformType.android);
  }

  bool isIos() {
    return ui.contains(PlatformType.ios);
  }

  bool isWeb() {
    return ui.contains(PlatformType.web);
  }

  WebappNavigationDelegate _navigationDelegate = WebappNavigationDelegate();
  WebappNavigationDelegate get navigationDelegate => _navigationDelegate;
  Future<void> setWebappNavigationDelegate(
      WebappNavigationDelegate delegate) async {
    _navigationDelegate = delegate;
  }
}

final WebappConfig webappConfig = WebappConfig();

typedef WebappTitleFunction = Widget Function(
    WebappController controller, WebappValue? value);

typedef WebappBottomFunction = PreferredSize Function(
    WebappController controller);

Widget webappWinTitle(WebappController controller, WebappValue? value) {
  List<Widget> titles = [];
  if (webappConfig.appIcon != null) {
    titles.add(Image.asset(
      webappConfig.appIcon!,
      height: 24,
    ));
    titles.add(const SizedBox(
      width: 6,
    ));
  }
  titles.add(Expanded(
      child: Text(value!.title,
          style: TextStyle(
              color: webappConfig.appbarTextColor,
              fontSize: webappConfig.appbarTextSize,
              decoration: TextDecoration.none,
              overflow: TextOverflow.ellipsis))));

  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Expanded(
        child: webappConfig.sysTitleHide
            ? Row(
                children: [...titles],
              )
            : const SizedBox.shrink(),
      ),
      webappConfig.navigation(controller, value),
    ],
  );
}

Widget webappAppTitle(WebappController controller, WebappValue? value) {
  List<Widget> titles = [];
  if (webappConfig.appIcon != null) {
    titles.add(Image.asset(
      webappConfig.appIcon!,
      height: 24,
    ));
    titles.add(const SizedBox(
      width: 6,
    ));
  }
  titles.add(Expanded(
      child: Text(value!.title,
          style: TextStyle(
              color: webappConfig.appbarTextColor,
              fontSize: webappConfig.appbarTextSize,
              decoration: TextDecoration.none,
              overflow: TextOverflow.ellipsis))));
  return Row(
    children: [...titles],
  );
}

Widget webappNavigation(WebappController controller, WebappValue? value) {
  return WebappNavigationBar(
    controller: controller,
  );
}
