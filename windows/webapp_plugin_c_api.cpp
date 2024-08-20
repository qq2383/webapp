#include "include/webapp/webapp_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "webapp_plugin.h"

void WebappPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  webapp::WebappPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
