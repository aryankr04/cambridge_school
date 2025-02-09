import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  // Initialize Firebase Messaging and request notification permission
  Future<void> initialize() async {
    // Request notification permissions for iOS
    await _firebaseMessaging.requestPermission();

    // Get the FCM token for this device
    String? token = await _firebaseMessaging.getToken();
    print("FCM Token: $token");

    // Listen to foreground notifications
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Received foreground message: ${message.notification?.title}');
      // Handle foreground notification
      _handleNotification(message);
    });

    // Listen to background and terminated notifications
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Notification caused app to open: ${message.notification?.title}');
      // Handle background notification
      _handleNotification(message);
    });

    // Listen for when the app is in the background or terminated
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  // Background message handler (when the app is closed or in background)
  static Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    print('Background message received: ${message.notification?.title}');
    // Handle background notification
    // This function must be static
    _handleNotification(message);
  }

  // Handle the notification data or payload
  static void _handleNotification(RemoteMessage message) {
    if (message.notification != null) {
      // Show a local notification, navigate to a specific screen, etc.
      print('Title: ${message.notification?.title}');
      print('Body: ${message.notification?.body}');
    }

    // Handle custom data from notification payload
    if (message.data.isNotEmpty) {
      print('Data: ${message.data}');
    }
  }

  // Subscribe to a topic for push notifications
  Future<void> subscribeToTopic(String topic) async {
    await _firebaseMessaging.subscribeToTopic(topic);
    print('Subscribed to topic: $topic');
  }

  // Unsubscribe from a topic for push notifications
  Future<void> unsubscribeFromTopic(String topic) async {
    await _firebaseMessaging.unsubscribeFromTopic(topic);
    print('Unsubscribed from topic: $topic');
  }

  // Send a push notification (example of how you'd send a message from your backend)
  Future<void> sendPushNotification(String token, String title, String body) async {
    try {
      // This would typically be done from your backend to send a push notification
      // Example payload (JSON) for sending a notification via Firebase Cloud Messaging
      Map<String, dynamic> payload = {
        "to": token,  // or use topic "to": "/topics/your_topic"
        "notification": {
          "title": title,
          "body": body,
        },
      };

      // Send the notification via your server using Firebase Admin SDK or other backend method
      // Your backend would send the request to FCM API here
      // Example using HTTP POST request (use your own API to send to Firebase)
      // await http.post('https://fcm.googleapis.com/fcm/send', body: json.encode(payload));
    } catch (e) {
      print('Error sending push notification: $e');
    }
  }

  // Check if FCM token is valid (usually done in the backend)
  Future<void> checkTokenValidity(String token) async {
    try {
      // Example of checking FCM token validity via Firebase's API in the backend
      // This would be done using Firebase Admin SDK or an HTTP request in your server-side code
      print('Token validity checked for: $token');
    } catch (e) {
      print('Error checking token validity: $e');
    }
  }

  // Delete FCM token (e.g., when user logs out)
  Future<void> deleteToken() async {
    try {
      await _firebaseMessaging.deleteToken();
      print('FCM Token deleted');
    } catch (e) {
      print('Error deleting FCM Token: $e');
    }
  }
}
