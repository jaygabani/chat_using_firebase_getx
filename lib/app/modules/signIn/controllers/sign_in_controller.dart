import 'package:chat_using_firebase_getx/app/data/models/user_details.dart';
import 'package:chat_using_firebase_getx/app/routes/app_pages.dart';
import 'package:chat_using_firebase_getx/app/utils/constant.dart';
import 'package:chat_using_firebase_getx/app/utils/shared_pref.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class SignInController extends GetxController {
  //TODO: Implement SignInController

  final db = FirebaseFirestore.instance;

  void signIn() async {
    try {
      var user = await Constant.googleSignIn.signIn();
      if (user != null) {
        Constant.showLoader();
        // insert login details in the authentication's users in firebase
        final fireAuthentication = await user.authentication;
        final fireCredentials = GoogleAuthProvider.credential(
          idToken: fireAuthentication.idToken,
          accessToken: fireAuthentication.accessToken,
        );
        await FirebaseAuth.instance.signInWithCredential(fireCredentials);
        //

        // store user data in storage
        SharedPref.pref.write(SharedPref.spEmail, user.email);
        SharedPref.pref.write(SharedPref.spDisplayName, user.displayName);
        SharedPref.pref.write(SharedPref.spUserID, user.id);
        SharedPref.pref.write(SharedPref.spProfilePhoto, user.photoUrl);
        SharedPref.pref.write(SharedPref.spIsLogin, true);

        // get user details from chat
        var userChat = await db
            .collection("users")
            .withConverter(
              fromFirestore: UserDetails.fromFirestore,
              toFirestore: (UserDetails userDetails, options) =>
                  userDetails.toFirestore(),
            )
            .where("id", isEqualTo: user.id)
            .get();

        if (userChat.docs.isEmpty) {
          var data = UserDetails(
            id: user.id,
            displayName: user.displayName,
            email: user.email,
            profilePhoto: user.photoUrl,
            timestamp: Timestamp.now().millisecondsSinceEpoch,
          );

          // chat is empty then add data on firebase
          await db
              .collection("users")
              .withConverter(
                fromFirestore: UserDetails.fromFirestore,
                toFirestore: (UserDetails userDetails, options) =>
                    userDetails.toFirestore(),
              )
              .add(data);
        }
        SharedPref.pref.write(SharedPref.spIsLogin, true);
        Constant.dismissLoader();
        Get.offAndToNamed(Routes.HOME);
      }
    } catch (e) {
      Constant.dismissLoader();
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        if (kDebugMode) {
          print('User logged out');
        }
      } else {
        if (kDebugMode) {
          print('User logged in');
        }
      }
    });
  }
}
