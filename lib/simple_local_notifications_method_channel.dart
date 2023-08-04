import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:simple_local_notifications/models/notification.dart';
import 'simple_local_notifications_platform_interface.dart';

/// An implementation of [SimpleLocalNotificationsPlatform] that uses method channels.
class MethodChannelSimpleLocalNotifications
    extends SimpleLocalNotificationsPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel =
      const MethodChannel('com.matteogassend/simple_local_notifications');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<void> sendNotification(SLNotification notification) async {
    await methodChannel.invokeMethod(
        'sendNotification', await notification.toMap());
  }
}
