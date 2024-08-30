import 'dart:async';

import 'package:webapp/src/webapp_controller.dart';
import 'package:webview_flutter/webview_flutter.dart';

typedef WebappNavigationRequestCallback = FutureOr<NavigationDecision> Function(
    WebappWebviewFactory controller, NavigationRequest navigationRequest);
typedef WebappPageTitleChangedCallback = void Function(
    WebappWebviewFactory controller, String title);
typedef WebappPageEventCallback = void Function(
    WebappWebviewFactory controller, String url);
typedef WebappProgressCallback = void Function(
    WebappWebviewFactory controller, int progress);
typedef WebappWebResourceErrorCallback = void Function(
    WebappWebviewFactory controller, WebResourceError error);
typedef WebappFullScreenChangedCallback = void Function(
    WebappWebviewFactory controller, bool isFullScreen);
typedef WebappHistoryChangedCallback = void Function(
    WebappWebviewFactory controller);
typedef WebappUrlChangeCallback = void Function(
    WebappWebviewFactory controller, UrlChange change);
typedef WebappHttpAuthRequest = void Function(
    WebappWebviewFactory controller, HttpAuthRequest request);
typedef WebappHttpError = void Function(
    WebappWebviewFactory controller, HttpResponseError error);

class WebappNavigationDelegate {
  WebappNavigationRequestCallback? onNavigationRequest;
  WebappPageEventCallback? onPageStarted;
  WebappPageEventCallback? onPageFinished;
  WebappProgressCallback? onProgress;
  WebappWebResourceErrorCallback? onWebResourceError;
  WebappPageTitleChangedCallback? onPageTitleChanged;
  WebappFullScreenChangedCallback? onFullScreenChanged;
  WebappHistoryChangedCallback? onHistoryChanged;
  WebappUrlChangeCallback? onUrlChange;
  WebappHttpAuthRequest? onHttpAuthRequest;
  WebappHttpError? onHttpError;

  WebappNavigationDelegate({
    this.onNavigationRequest,
    this.onPageStarted,
    this.onPageFinished,
    this.onProgress,
    this.onWebResourceError,
    this.onPageTitleChanged,
    this.onFullScreenChanged,
    this.onHistoryChanged,
    this.onUrlChange,
    this.onHttpAuthRequest,
    this.onHttpError,
  });
}
