import 'package:chat_using_firebase_getx/app/data/models/message.dart';
import 'package:chat_using_firebase_getx/app/data/models/user_details.dart';
import 'package:chat_using_firebase_getx/app/routes/app_pages.dart';
import 'package:chat_using_firebase_getx/app/utils/constant.dart';
import 'package:chat_using_firebase_getx/app/utils/shared_pref.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  //TODO: Implement HomeController

  final db = FirebaseFirestore.instance;
  RxList<UserDetails> chatUsers = RxList<UserDetails>();

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
    Constant.showLoader();
    getAllUserList();
  }

  void getAllUserList() async {
    var userChat = await db
        .collection("users")
        .withConverter(
          fromFirestore: UserDetails.fromFirestore,
          toFirestore: (UserDetails userDetails, options) =>
              userDetails.toFirestore(),
        )
        .where("id", isNotEqualTo: SharedPref.pref.read(SharedPref.spUserID))
        .get();
    chatUsers.clear();
    for (var details in userChat.docs) {
      chatUsers.add(details.data());
    }
    Constant.dismissLoader();
  }

  checkChatIsCreated(UserDetails userDetails) async {
    Constant.showLoader();
    // Get users data
    var fromMessage = await db
        .collection("message")
        .withConverter(
          fromFirestore: Message.fromFirestore,
          toFirestore: (Message msgDetails, options) =>
              msgDetails.toFirestore(),
        )
        .where("fromID", isEqualTo: SharedPref.pref.read(SharedPref.spUserID))
        .where("toID", isEqualTo: userDetails.id)
        .get();

    var toMessage = await db
        .collection("message")
        .withConverter(
          fromFirestore: Message.fromFirestore,
          toFirestore: (Message msgDetails, options) =>
              msgDetails.toFirestore(),
        )
        .where("fromID", isEqualTo: userDetails.id)
        .where("toID", isEqualTo: SharedPref.pref.read(SharedPref.spUserID))
        .get();

    if (fromMessage.docs.isEmpty && toMessage.docs.isEmpty) {
      // Before both are not chatted then create the chat between them.

      var chatSetup = Message(
        fromID: SharedPref.pref.read(SharedPref.spUserID),
        toID: userDetails.id,
        fromName: SharedPref.pref.read(SharedPref.spDisplayName),
        toName: userDetails.displayName,
        fromProfilePhoto: SharedPref.pref.read(SharedPref.spProfilePhoto),
        toProfilePhoto: userDetails.profilePhoto,
        msg: '',
        sendTime: Timestamp.now().millisecondsSinceEpoch,
      );

      db
          .collection("message")
          .withConverter(
            fromFirestore: Message.fromFirestore,
            toFirestore: (Message msgDetails, options) =>
                msgDetails.toFirestore(),
          )
          .add(chatSetup)
          .then(
        (value) {
          Constant.dismissLoader();
          Get.toNamed(Routes.CHAT_DETAIL, arguments: {
            'documentID': value.id,
            'toID': userDetails.id,
            'toName': userDetails.displayName,
            'toProfilePhoto': userDetails.profilePhoto,
          });
        },
      );
      //
    } else {
      //
      Constant.dismissLoader();
      if (fromMessage.docs.isNotEmpty) {
        Get.toNamed(Routes.CHAT_DETAIL, arguments: {
          'documentID': fromMessage.docs.first.id,
          'toID': userDetails.id,
          'toName': userDetails.displayName,
          'toProfilePhoto': userDetails.profilePhoto,
        });
      } else if (toMessage.docs.isNotEmpty) {
        Get.toNamed(Routes.CHAT_DETAIL, arguments: {
          'documentID': toMessage.docs.first.id,
          'toID': userDetails.id,
          'toName': userDetails.displayName,
          'toProfilePhoto': userDetails.profilePhoto,
        });
      }
      //
    }
  }

  void signOut() {
    Constant.googleSignIn.signOut().then((value) {
      SharedPref.pref.write(SharedPref.spIsLogin, false);
      SharedPref.pref.erase();
      Get.offNamedUntil(Routes.SIGN_IN, (route) => false);
    });
  }
}
