import 'package:flutter/services.dart';

class SLNotification {
  String title;
  String content;
  String iconPath;
  String? channelId;
  String? channelName;

  SLNotification(
      {required this.title,
      required this.content,
      required this.iconPath,
      this.channelId,
      this.channelName}) {
    channelId ??= "simple_local_notifications_channel";
    channelName ??= "simple_local_notifications";
  }

  Future<Map<String, dynamic>> toMap() async {
    return {
      "title": title,
      "content": content,
      "channelId": channelId,
      "channelName": channelName,
      "iconData": (await rootBundle.load(iconPath)).buffer.asUint8List(),
    };
  }
}
