import 'notification_service.dart';
import 'package:celebrating_us/app_contants.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

const String channelId = "1001";
class NotificationServiceImpl extends NotificationService {
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  @override
  Future<void> init() async {
   final initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    final initializationSettingsIOS = IOSInitializationSettings();
    final initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
      macOS: null
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String? payload) async {
          //TODO: handle notification tapped event
        });
  }

  @override
  void showNotification(String title, String message) async {
    final android = AndroidNotificationDetails(
      channelId,
      applicationName,
      channelDescription: 'Reminds you about upcoming celebrations',
      importance: Importance.high,
      priority: Priority.high,
      largeIcon: DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
      styleInformation: BigTextStyleInformation(message),
    );
    final ios = IOSNotificationDetails();
    final notificationDetails = NotificationDetails(android: android, iOS: ios);

    await flutterLocalNotificationsPlugin.show(
      message.hashCode,
      title,
      message,
      notificationDetails
    );
  }

}