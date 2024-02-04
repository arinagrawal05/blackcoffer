import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Screens/enter_otp.dart';
import '../../Services/functions.dart';

enum ViewState { idle, phoneProcessing, otpProcessing }

class AuthProvider extends ChangeNotifier {
  ViewState state = ViewState.idle;

  bool _isSignedIn = false;
  bool get isSignedIn => _isSignedIn;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  User? _user;
  User? get user => _user;

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  AuthProvider() {
    checkSign();
  }

  void checkSign() async {
    final SharedPreferences s = await SharedPreferences.getInstance();
    _isSignedIn = s.getBool("isLogged") ?? false;
    notifyListeners();
  }

  Future setSignIn() async {
    final SharedPreferences s = await SharedPreferences.getInstance();
    s.setBool("isLogged", true);
    _isSignedIn = true;
    notifyListeners();
  }

  // signin
  void signInWithPhone(BuildContext context, String phoneNumber) async {
    // final themeProvider = Provider.of<ThemeProvider>(context);
    state = ViewState.phoneProcessing;
    notifyListeners();
    try {
      await _firebaseAuth.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          verificationCompleted:
              (PhoneAuthCredential phoneAuthCredential) async {
            await _firebaseAuth.signInWithCredential(phoneAuthCredential);
          },
          verificationFailed: (error) {
            throw Exception(error.message);
          },
          codeSent: (verificationId, forceResendingToken) {
            navigateslide(
                EnterOtpPage(
                  verificationId: verificationId,
                  phone: phoneNumber,
                ),
                context);
          },
          codeAutoRetrievalTimeout: (verificationId) {});
    } on FirebaseAuthException catch (e) {
      AppUtils.showSnackMessage(e.message.toString());
    }
  }

  // verify otp
  void verifyOtp({
    required BuildContext context,
    required String verificationId,
    required String userOtp,
    required Function onSuccess,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      PhoneAuthCredential creds = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: userOtp);

      User? user = (await _firebaseAuth.signInWithCredential(creds)).user;

      if (user != null) {
        _user = user;
        onSuccess();
      }
      _isLoading = false;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      AppUtils.showSnackMessage(e.message.toString());
      _isLoading = false;
      notifyListeners();
    }
  }

  Future userSignOut() async {
    SharedPreferences s = await SharedPreferences.getInstance();
    // await _firebaseAuth.signOut();
    _isSignedIn = false;
    notifyListeners();
    s.clear();
  }
}
