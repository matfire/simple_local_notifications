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

  Future<void> createNotificationChannel(
      {required String channelId,
      required String channelName,
      SLNotificationPriority priority =
          SLNotificationPriority.defaultPriority}) {
    return SimpleLocalNotificationsPlatform.instance.createNotificationChannel(
        channelId: channelId, channelName: channelName, priority: priority);
  }
}
