
import 'simple_local_notifications_platform_interface.dart';

class SimpleLocalNotifications {
  Future<String?> getPlatformVersion() {
    return SimpleLocalNotificationsPlatform.instance.getPlatformVersion();
  }
}
