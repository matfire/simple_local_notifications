import 'package:flutter/services.dart';

enum SLNotificationPriority { min, low, defaultPriority, high }

class SLNotification {
  String title;
  String content;
  String iconPath;
  String? channelId;
  String? channelName;
  SLNotificationPriority? priority;

  static const Map<SLNotificationPriority, int> priorityMap = {
    SLNotificationPriority.min: 1,
    SLNotificationPriority.low: 2,
    SLNotificationPriority.defaultPriority: 3,
    SLNotificationPriority.high: 4,
  };

  SLNotification({
    required this.title,
    required this.content,
    required this.iconPath,
    this.channelId = "simple_local_notifications_channel",
    this.channelName = "simple_local_notifications",
    this.priority = SLNotificationPriority.defaultPriority,
  });

  Future<Map<String, dynamic>> toMap() async {
    return {
      "title": title,
      "content": content,
      "channelId": channelId,
      "channelName": channelName,
      "iconData": (await rootBundle.load(iconPath)).buffer.asUint8List(),
      "priority": priorityMap[priority],
    };
  }
}
