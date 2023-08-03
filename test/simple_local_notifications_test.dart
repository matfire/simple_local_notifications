import 'package:flutter_test/flutter_test.dart';
import 'package:simple_local_notifications/simple_local_notifications.dart';
import 'package:simple_local_notifications/simple_local_notifications_platform_interface.dart';
import 'package:simple_local_notifications/simple_local_notifications_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockSimpleLocalNotificationsPlatform
    with MockPlatformInterfaceMixin
    implements SimpleLocalNotificationsPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final SimpleLocalNotificationsPlatform initialPlatform = SimpleLocalNotificationsPlatform.instance;

  test('$MethodChannelSimpleLocalNotifications is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelSimpleLocalNotifications>());
  });

  test('getPlatformVersion', () async {
    SimpleLocalNotifications simpleLocalNotificationsPlugin = SimpleLocalNotifications();
    MockSimpleLocalNotificationsPlatform fakePlatform = MockSimpleLocalNotificationsPlatform();
    SimpleLocalNotificationsPlatform.instance = fakePlatform;

    expect(await simpleLocalNotificationsPlugin.getPlatformVersion(), '42');
  });
}
