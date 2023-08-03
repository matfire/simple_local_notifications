import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'simple_local_notifications_platform_interface.dart';

/// An implementation of [SimpleLocalNotificationsPlatform] that uses method channels.
class MethodChannelSimpleLocalNotifications extends SimpleLocalNotificationsPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('simple_local_notifications');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
