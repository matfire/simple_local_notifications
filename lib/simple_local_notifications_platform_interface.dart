import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'models/notification.dart';
import 'simple_local_notifications_method_channel.dart';

abstract class SimpleLocalNotificationsPlatform extends PlatformInterface {
  /// Constructs a SimpleLocalNotificationsPlatform.
  SimpleLocalNotificationsPlatform() : super(token: _token);

  static final Object _token = Object();

  static SimpleLocalNotificationsPlatform _instance =
      MethodChannelSimpleLocalNotifications();

  /// The default instance of [SimpleLocalNotificationsPlatform] to use.
  ///
  /// Defaults to [MethodChannelSimpleLocalNotifications].
  static SimpleLocalNotificationsPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [SimpleLocalNotificationsPlatform] when
  /// they register themselves.
  static set instance(SimpleLocalNotificationsPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<void> sendNotification(SLNotification notification) async {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
