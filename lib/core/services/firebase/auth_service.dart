import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Sign in with email and password.
  Future<User?> signInWithEmailPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return userCredential.user;
    } catch (e) {
      print('Sign In Error: $e');
      return null;
    }
  }

  /// Register with email and password.
  Future<User?> registerWithEmailPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return userCredential.user;
    } catch (e) {
      print('Registration Error: $e');
      return null;
    }
  }

  /// Sends OTP to the user's phone number.
  Future<void> sendOtp(String phoneNumber, Function(String, int?) codeSent) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        print("Verification Failed: ${e.message}");
      },
      codeSent: (String verificationId, int? resendToken) {
        codeSent(verificationId, resendToken);
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  /// Verify OTP and Login (Enhanced)
  Future<String?> verifyOtpAndLogin({ //Return the phone number
    required String verificationId,
    required String otp,
  }) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: otp);
      UserCredential userCredential = await _auth.signInWithCredential(credential);
      return userCredential.user?.phoneNumber; // Return the phone number after successful login.
    } catch (e) {
      print("Error: $e");
      return null; // Or throw the error if you prefer.
    }
  }

  /// Verify OTP and Register User
  Future<String?> verifyOtpAndRegister({ //Return the phone number
    required String verificationId,
    required String otp,
  }) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: otp);
      UserCredential userCredential = await _auth.signInWithCredential(credential);

      return userCredential.user?.phoneNumber; // Return the phone number after successful registration.
    } catch (e) {
      print("Error: $e");
      return null; // Or throw the error if you prefer.
    }
  }


  /// Sign in anonymously.
  Future<User?> signInAnonymously() async {
    try {
      UserCredential userCredential = await _auth.signInAnonymously();
      return userCredential.user;
    } catch (e) {
      print('Anonymous Sign-In Error: $e');
      return null;
    }
  }

  /// Update user profile (e.g., name, photo URL).
  Future<void> updateUserProfile({String? displayName, String? photoURL}) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await user.updateProfile(displayName: displayName, photoURL: photoURL);
        await user.reload(); // Refresh user data
        print('User profile updated: ${user.displayName}'); //Use current value
      }
    } catch (e) {
      print('Profile Update Error: $e');
    }
  }

  /// Update user email address.
  Future<void> updateEmail(String email) async {
    try {
      await _auth.currentUser!.updateEmail(email);
    } catch (e) {
      print('Update Email Error: $e');
      rethrow;
    }
  }

  /// Update user password.
  Future<void> updatePassword(String password) async {
    try {
      await _auth.currentUser!.updatePassword(password);
    } catch (e) {
      print('Update Password Error: $e');
      rethrow;
    }
  }

  /// Link multiple auth providers to a single account.
  Future<void> linkAuthProvider(AuthCredential credential) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        UserCredential userCredential = await user.linkWithCredential(credential);
        print('Account linked with new provider: ${userCredential.user?.providerData}');
      }
    } catch (e) {
      print('Link Auth Provider Error: $e');
    }
  }

  /// Sign out.
  Future<void> signOut() async {
    await _auth.signOut();
  }

  /// Get current user.
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  /// Reset password by email.
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      print('Password reset email sent.');
    } catch (e) {
      print('Reset Password Error: $e');
    }
  }

  /// Verify email.
  Future<void> verifyEmail() async {
    try {
      User? user = _auth.currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
        print('Verification email sent.');
      }
    } catch (e) {
      print('Verify Email Error: $e');
    }
  }

  /// Listen to authentication state changes.
  Stream<User?> get authStateChanges => _auth.authStateChanges();
}