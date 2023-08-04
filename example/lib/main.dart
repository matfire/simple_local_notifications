import 'package:flutter/material.dart';
import 'dart:async';

import 'package:permission_handler/permission_handler.dart';
import 'package:simple_local_notifications/models/notification.dart';
import 'package:simple_local_notifications/simple_local_notifications.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _simpleLocalNotificationsPlugin = SimpleLocalNotifications();

  @override
  void initState() {
    super.initState();
    initApplication();
  }

  Future<void> initApplication() async {
    try {
      await _simpleLocalNotificationsPlugin.createNotificationChannel(
          channelId: "simple_local_notifications_channel_priority",
          channelName: "simple_local_notifications_priority",
          priority: SLNotificationPriority.high);
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            children: [
              TextButton(
                onPressed: () async {
                  await Permission.notification.request();
                  await _simpleLocalNotificationsPlugin
                      .sendNotification(SLNotification(
                    title: "Hello world",
                    content: "from a flutter plugin",
                    iconPath: "assets/icons/icon.png",
                  ));
                },
                child: const Text("Send notification"),
              ),
              TextButton(
                onPressed: () async {
                  await Permission.notification.request();
                  await _simpleLocalNotificationsPlugin
                      .sendNotification(SLNotification(
                    title: "Hello world",
                    content: "from a flutter plugin",
                    iconPath: "assets/icons/icon.png",
                    channelId: "simple_local_notifications_channel_priority",
                    channelName: "simple_local_notifications_priority",
                    priority: SLNotificationPriority.high,
                  ));
                },
                child: const Text("Send HIGH notification"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
