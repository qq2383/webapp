#ifndef FLUTTER_PLUGIN_WEBAPP_PLUGIN_H_
#define FLUTTER_PLUGIN_WEBAPP_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace webapp {

class WebappPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  WebappPlugin();

  virtual ~WebappPlugin();

  // Disallow copy and assign.
  WebappPlugin(const WebappPlugin&) = delete;
  WebappPlugin& operator=(const WebappPlugin&) = delete;

  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace webapp

#endif  // FLUTTER_PLUGIN_WEBAPP_PLUGIN_H_
