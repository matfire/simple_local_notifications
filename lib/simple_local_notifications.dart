import 'package:simple_local_notifications/models/notification.dart';

import 'simple_local_notifications_platform_interface.dart';

class SimpleLocalNotifications {
  Future<String?> getPlatformVersion() {
    return SimpleLocalNotificationsPlatform.instance.getPlatformVersion();
  }

  Future<void> sendNotification(SLNotification notification) {
    return SimpleLocalNotificationsPlatform.instance
        .sendNotification(notification);
  }
}
