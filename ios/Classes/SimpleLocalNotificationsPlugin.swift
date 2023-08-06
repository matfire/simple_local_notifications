import Flutter
import UIKit
import UserNotifications

public class SimpleLocalNotificationsPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "com.matteogassend/simple_local_notifications", binaryMessenger: registrar.messenger())
    let instance = SimpleLocalNotificationsPlugin()

    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getPlatformVersion":
      result("iOS " + UIDevice.current.systemVersion)
    case "sendNotification":
        sendNotification(call: call, result: result)
    case "createNotificationChannel":
        result("ok")
    default:
      result(FlutterMethodNotImplemented)
    }
  }
    private func sendNotification(call: FlutterMethodCall, result: FlutterResult) {
        guard let args = call.arguments else {
            result(FlutterError(code: "invalid_arguments", message: "invalid arguments", details: {}));
            return;
        }
        let myArgs = args as? [String: Any];
        let content = UNMutableNotificationContent();
        content.title =  myArgs!["title"] as! String;
        content.body = myArgs!["content"] as! String;
        //let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
        UNUserNotificationCenter.current().add(request)
    }
}
