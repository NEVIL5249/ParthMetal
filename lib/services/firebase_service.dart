import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class FirebaseService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get current user
  static User? get currentUser => _auth.currentUser;

  // Sign in with phone number
  static Future<void> signInWithPhoneNumber({
    required String phoneNumber,
    required Function(String) onCodeSent,
    required Function(String) onError,
  }) async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: '+91$phoneNumber', // Assuming Indian numbers
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          onError(e.message ?? 'Verification failed');
        },
        codeSent: (String verificationId, int? resendToken) {
          onCodeSent(verificationId);
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } catch (e) {
      onError(e.toString());
    }
  }

  // Verify OTP
  static Future<UserCredential?> verifyOTP({
    required String verificationId,
    required String smsCode,
  }) async {
    try {
      print('Creating PhoneAuthCredential...');
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      print('Signing in with credential...');
      final userCredential = await _auth.signInWithCredential(credential);
      print('Sign in successful: ${userCredential.user?.uid}');
      return userCredential;
    } catch (e) {
      print('OTP verification error: ${e.toString()}');
      
      if (e.toString().contains('BILLING_NOT_ENABLED')) {
        throw Exception('Firebase Phone Authentication billing is not enabled. Please enable it in Firebase Console.');
      } else if (e.toString().contains('invalid-verification-code')) {
        throw Exception('Invalid OTP code. Please check and try again.');
      } else if (e.toString().contains('session-expired')) {
        throw Exception('OTP session expired. Please request a new OTP.');
      } else {
        throw Exception('OTP verification failed: ${e.toString()}');
      }
    }
  }

  // Save user data to Firestore
  static Future<void> saveUserData({
    required String companyName,
    required String ownerName,
    required String mobileNumber,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'companyName': companyName,
          'ownerName': ownerName,
          'mobileNumber': mobileNumber,
          'uid': user.uid,
          'createdAt': FieldValue.serverTimestamp(),
          'lastLogin': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      throw Exception('Failed to save user data: ${e.toString()}');
    }
  }

  // Update last login
  static Future<void> updateLastLogin() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).update({
          'lastLogin': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      // Silently fail for last login update
      print('Failed to update last login: $e');
    }
  }

  // Get user data
  static Future<UserModel?> getUserData() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final doc = await _firestore.collection('users').doc(user.uid).get();
        if (doc.exists) {
          return UserModel.fromMap(doc.data()!);
        }
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get user data: ${e.toString()}');
    }
  }

  // Sign out
  static Future<void> signOut() async {
    await _auth.signOut();
  }

  // Check if user is logged in
  static bool get isLoggedIn => _auth.currentUser != null;
} 