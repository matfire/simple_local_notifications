package com.matteogassend.simple_local_notifications

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.os.Build
import android.util.Log
import androidx.annotation.NonNull
import androidx.annotation.RequiresApi
import androidx.core.app.NotificationCompat
import androidx.core.graphics.drawable.IconCompat
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result


/** SimpleLocalNotificationsPlugin */
class SimpleLocalNotificationsPlugin: FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel
  private lateinit var context: Context
  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "com.matteogassend/simple_local_notifications")
    context = flutterPluginBinding.applicationContext
    channel.setMethodCallHandler(this)
  }

  @RequiresApi(Build.VERSION_CODES.O)
  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    when(call.method) {
      "getPlatformVersion" -> result.success("Android ${Build.VERSION.RELEASE}")
      "sendNotification" -> sendNotification(call, result)
      "createNotificationChannel" -> createNotificationChannel(call, result)
      else -> result.notImplemented()
    }
  }

  @RequiresApi(Build.VERSION_CODES.O)
  private fun createNotificationChannel(call: MethodCall, result: Result): NotificationChannel? {
    val notificationService: NotificationManager =
      context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
    if (notificationService.getNotificationChannel(call.argument<String>("channelId")!!) != null) {
      result.error("channel_already_exists", "the channel you wanted to create already exists", null)
      return null
    }
    val notificationChannel = NotificationChannel(
      call.argument("channelId")!!,
      call.argument<String>("channelName")!!,
      call.argument("priority") ?: NotificationManager.IMPORTANCE_DEFAULT
    )
    notificationService.createNotificationChannel(notificationChannel)
    return notificationChannel
  }

  @RequiresApi(Build.VERSION_CODES.N)
  private fun sendNotification(call: MethodCall, result: Result) {
    val intent = Intent(context, SimpleLocalNotificationsPlugin::class.java)
    val contentIntent = PendingIntent.getActivity(context, 0, intent, PendingIntent.FLAG_IMMUTABLE)
    val notificationService: NotificationManager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
    val b = NotificationCompat.Builder(context, call.argument<String>("channelId")!!)
    b.setAutoCancel(true).setDefaults(Notification.DEFAULT_ALL)
      .setWhen(System.currentTimeMillis())
      .setPriority(call.argument<Int>("priority") ?: NotificationManager.IMPORTANCE_DEFAULT)
      .setContentTitle(call.argument<String>("title")!!)
      .setContentText(call.argument<String>("content")!!)
      .setSmallIcon(IconCompat.createWithData(call.argument<ByteArray>("iconData")!!, 0, call.argument<ByteArray>("iconData")!!.size))
      .setContentIntent(contentIntent).setContentInfo("info")
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
      if (!notificationService.areNotificationsEnabled()) {
        result.error("permissions_not_granted", "check that you're authorized to send notifications", null)
        return
      }
      Log.i("notification_send", "send notification to channel ${call.argument<String>("channelId")!!}")
      val previousNotificationChannel = notificationService.getNotificationChannel(call.argument<String>("channelId")!!)
      if (previousNotificationChannel != null && previousNotificationChannel.importance != call.argument<Int>("priority")) {
        result.error("channel_priority_differs", "you tried to send a notification with a different importance than the channel was setup to use", null);
        return
      }
      val notifiCationChannel = NotificationChannel(call.argument<String>("channelId")!!, call.argument<String>("channelName")!!, call.argument<Int>("priority") ?: NotificationManager.IMPORTANCE_DEFAULT)
      notificationService.createNotificationChannel(notifiCationChannel)
      b.setChannelId(notifiCationChannel.id)
    }

    notificationService.notify(1, b.build())
    result.success(true)
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }
}
