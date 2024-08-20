/*
import 'package:flutter_test/flutter_test.dart';
import 'package:webapp/webapp.dart';
import 'package:webapp/webapp_platform_interface.dart';
import 'package:webapp/webapp_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockWebappPlatform
    with MockPlatformInterfaceMixin
    implements WebappPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final WebappPlatform initialPlatform = WebappPlatform.instance;

  test('$MethodChannelWebapp is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelWebapp>());
  });

  test('getPlatformVersion', () async {
    Webapp webappPlugin = Webapp();
    MockWebappPlatform fakePlatform = MockWebappPlatform();
    WebappPlatform.instance = fakePlatform;

    expect(await webappPlugin.getPlatformVersion(), '42');
  });
}

 */
