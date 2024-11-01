
class JavaScriptHandler {
  static final Map handles = {};

  static void add(String name, JavaScriptCallback callback) {
    handles[name] = callback;
  }
}

typedef JavaScriptCallback = dynamic Function(dynamic data);