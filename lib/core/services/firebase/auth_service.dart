import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Sign in with email and password
  Future<User?> signInWithEmailPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print('Sign In Error: $e');
      return null;
    }
  }

  // Register with email and password
  Future<User?> registerWithEmailPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print('Registration Error: $e');
      return null;
    }
  }

  // Sign in with mobile number (Phone Authentication)
  Future<User?> signInWithMobile(String phoneNumber, Function(String) onCodeSent, Function(String) onVerificationCompleted, Function(FirebaseAuthException) onVerificationFailed) async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential phoneAuthCredential) async {
          // Automatically sign in when verification is completed
          await _auth.signInWithCredential(phoneAuthCredential);
          onVerificationCompleted('Verification completed!');
        },
        verificationFailed: (FirebaseAuthException e) {
          onVerificationFailed(e);
        },
        codeSent: (String verificationId, int? resendToken) {
          onCodeSent(verificationId);
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          print("Auto retrieval timeout for $verificationId");
        },
      );
    } catch (e) {
      print('Phone Sign In Error: $e');
      return null;
    }
    return null;
  }

  // Verify OTP and sign in after receiving verification code
  Future<User?> verifyOTP(String verificationId, String smsCode) async {
    try {
      PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      UserCredential userCredential = await _auth.signInWithCredential(phoneAuthCredential);
      return userCredential.user;
    } catch (e) {
      print('OTP Verification Error: $e');
      return null;
    }
  }

  // Sign in anonymously
  Future<User?> signInAnonymously() async {
    try {
      UserCredential userCredential = await _auth.signInAnonymously();
      return userCredential.user;
    } catch (e) {
      print('Anonymous Sign-In Error: $e');
      return null;
    }
  }

  // Update user profile (e.g., name, photo URL)
  Future<void> updateUserProfile({String? displayName, String? photoURL}) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await user.updateProfile(displayName: displayName, photoURL: photoURL);
        await user.reload();
        user = _auth.currentUser;
        print('User profile updated: ${user?.displayName}');
      }
    } catch (e) {
      print('Profile Update Error: $e');
    }
  }

  Future<void> updateEmail(String email) async {
    try {
      await _auth.currentUser!.updateEmail(email);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updatePassword(String password) async {
    try {
      await _auth.currentUser!.updatePassword(password);
    } catch (e) {
      rethrow;
    }
  }

  // Link multiple auth providers to a single account
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

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Get current user
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // Reset password by email
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      print('Password reset email sent.');
    } catch (e) {
      print('Reset Password Error: $e');
    }
  }

  // Verify email
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

  // Listen to authentication state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();
}
