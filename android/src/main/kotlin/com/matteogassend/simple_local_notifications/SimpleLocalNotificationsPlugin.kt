package com.matteogassend.simple_local_notifications

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.os.Build
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

  @RequiresApi(Build.VERSION_CODES.M)
  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    when(call.method) {
      "getPlatformVersion" -> result.success("Android ${Build.VERSION.RELEASE}")
      "sendNotification" -> sendNotification(call, result)
      else -> result.notImplemented()
    }
  }

  @RequiresApi(Build.VERSION_CODES.M)
  private fun sendNotification(call: MethodCall, result: Result) {
    val intent = Intent(context, SimpleLocalNotificationsPlugin::class.java)
    val contentIntent = PendingIntent.getActivity(context, 0, intent, PendingIntent.FLAG_IMMUTABLE)
    val notificationService: NotificationManager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
    val b = NotificationCompat.Builder(context, call.argument<String>("channelId")!!)
    b.setAutoCancel(true).setDefaults(Notification.DEFAULT_ALL)
      .setWhen(System.currentTimeMillis())
      .setContentTitle(call.argument<String>("title")!!)
      .setContentText(call.argument<String>("content")!!)
      .setSmallIcon(IconCompat.createWithData(call.argument<ByteArray>("iconData")!!, 0, call.argument<ByteArray>("iconData")!!.size))
      .setContentIntent(contentIntent).setContentInfo("info")

    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
      if (!notificationService.areNotificationsEnabled()) {
        result.error("permissions_not_granted", "check that you're authorized to send notifications", null)
        return
      }
      val notifiCationChannel = NotificationChannel(call.argument<String>("channelId")!!, call.argument<String>("channelName")!!, NotificationManager.IMPORTANCE_DEFAULT)
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
