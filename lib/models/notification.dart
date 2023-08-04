class SLNotification {
  String title;
  String content;
  String? channelId;
  String? channelName;

  SLNotification(
      {required this.title,
      required this.content,
      this.channelId,
      this.channelName}) {
    channelId ??=
        DateTime.now().millisecondsSinceEpoch.remainder(100000).toString();
    channelName ??= "simple_local_notifications";
  }

  Map<String, dynamic> toMap() {
    return {
      "title": title,
      "content": content,
      "channelId": channelId,
      "channelName": channelName
    };
  }
}
