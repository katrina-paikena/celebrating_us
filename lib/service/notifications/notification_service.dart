abstract class NotificationService {
  Future<void> init();
  void showNotification(String title, String message);
}