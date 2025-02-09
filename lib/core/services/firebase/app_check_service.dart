import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';

class FirebaseAppCheckService {
  // Initialize Firebase App Check
  Future<void> initializeAppCheck() async {
    // Make sure Firebase is initialized
    await Firebase.initializeApp();

    try {
      // Firebase App Check initialization with a provider (e.g., Play Integrity for Android)
      await FirebaseAppCheck.instance.activate(
      );
      print("Firebase App Check initialized successfully.");
    } catch (e) {
      print("Error initializing Firebase App Check: $e");
    }
  }

  // Get the App Check token for making secure calls
  Future<String?> getAppCheckToken() async {
    try {
      // Fetch the App Check token, which is sent along with requests to Firebase services
      String? token = await FirebaseAppCheck.instance.getToken();
      print("App Check Token: $token");
      return token;
    } catch (e) {
      print("Error getting App Check token: $e");
      return null;
    }
  }

  // Refresh the App Check token (in case it expires)
  Future<String?> refreshAppCheckToken() async {
    try {
      String? token = await FirebaseAppCheck.instance.getToken(true);
      print("Refreshed App Check Token: $token");
      return token;
    } catch (e) {
      print("Error refreshing App Check token: $e");
      return null;
    }
  }

  // Verify token validity (optional, mostly handled server-side)
  Future<bool> verifyTokenValidity(String token) async {
    try {
      // Normally, token verification happens on the server-side
      // Here you can send the token to your backend to verify its validity
      print("Verifying App Check Token: $token");
      return true;  // Token is valid, return true. Handle this logic on the server-side.
    } catch (e) {
      print("Error verifying App Check token: $e");
      return false;
    }
  }

}
