import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import 'webapp_controller.dart';

class WebappDelegate {
  void Function(WebappController controller, WebUri? url)? onLoadStart;
  void Function(WebappController controller, WebUri? url)? onLoadStop;
  void Function(WebappController controller, int progress)?
      onProgressChanged;
  void Function(WebappController controller)? onEnterFullscreen;
  void Function(WebappController controller)? onExitFullscreen;
  void Function(WebappController controller, String? title)?
      onTitleChanged;
  void Function(WebappController controller, WebResourceRequest request,
      WebResourceResponse errorResponse)? onReceivedHttpError;
  void Function(WebappController controller,
      DownloadStartRequest downloadStartRequest)? onDownloadStartRequest;

  WebappDelegate(
      {this.onLoadStart,
      this.onLoadStop,
      this.onProgressChanged,
      this.onEnterFullscreen,
      this.onExitFullscreen,
      this.onTitleChanged,
      this.onReceivedHttpError,
      this.onDownloadStartRequest});
}
