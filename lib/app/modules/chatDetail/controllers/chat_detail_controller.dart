import 'dart:io';

import 'package:chat_using_firebase_getx/app/data/models/message_details.dart';
import 'package:chat_using_firebase_getx/app/utils/app_colors.dart';
import 'package:chat_using_firebase_getx/app/utils/app_string.dart';
import 'package:chat_using_firebase_getx/app/utils/constant.dart';
import 'package:chat_using_firebase_getx/app/utils/shared_pref.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatDetailController extends GetxController {
  //TODO: Implement ChatDetailController

  RxString toProfilePhoto = ''.obs;
  RxString toName = ''.obs;
  RxString toID = ''.obs;
  String documentID = '';
  final db = FirebaseFirestore.instance;
  final sendTextController = TextEditingController();

  RxList<MessageDetails> messageList = RxList<MessageDetails>();
  // listener use for any changes in the firebase messages then we needs to update on ui.
  var listener;
  ScrollController msgScrolling = ScrollController();

  @override
  void onInit() {
    toProfilePhoto.value = Get.arguments['toProfilePhoto'];
    toName.value = Get.arguments['toName'];
    toID.value = Get.arguments['toID'];
    documentID = Get.arguments['documentID'];

    super.onInit();
  }

  sendMessage(bool isFile, [String? fileUrl]) async {
    if (!isFile && sendTextController.text.trim().isNotEmpty) {
      commonSendMessage(sendTextController.text.trim(), isFile);
      return;
    }
    if (isFile && fileUrl!.isNotEmpty) {
      commonSendMessage(fileUrl, isFile);
      return;
    }
  }

  commonSendMessage(String sendContent, bool isFile) async {
    var messgeDetails = MessageDetails(
        uID: SharedPref.pref.read(SharedPref.spUserID),
        content: sendContent,
        type: isFile ? 'file' : 'text',
        sendTime: Timestamp.now().millisecondsSinceEpoch);

    await db
        .collection("message")
        .doc(documentID)
        .collection('messageList')
        .withConverter(
          fromFirestore: MessageDetails.fromFirestore,
          toFirestore: (MessageDetails msgDetails, options) =>
              msgDetails.toFirestore(),
        )
        .add(messgeDetails)
        .then((value) {
      sendTextController.clear();
      Get.focusScope?.unfocus();
    });

    await db.collection("message").doc(documentID).update({
      "msg": isFile ? '[file]' : sendContent,
      "sendTime": Timestamp.now().millisecondsSinceEpoch,
    });
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();

    // get message from firebase
    var messages = db
        .collection("message")
        .doc(documentID)
        .collection('messageList')
        .withConverter(
          fromFirestore: MessageDetails.fromFirestore,
          toFirestore: (MessageDetails msgDetails, options) =>
              msgDetails.toFirestore(),
        )
        .orderBy('sendTime', descending: false);
    messageList.clear();

    listener = messages.snapshots().listen((event) {
      for (var element in event.docChanges) {
        switch (element.type) {
          case DocumentChangeType.added:
            if (element.doc.data() != null) {
              messageList.insert(0, element.doc.data()!);
            }
            break;
          case DocumentChangeType.modified:
            break;
          case DocumentChangeType.removed:
            break;
          default:
        }
      }
    }, onError: (e) => print('message listen error$e'));
  }

  @override
  void onClose() {
    // TODO: implement onClose

    msgScrolling.dispose();
    listener.cancel();
    super.onClose();
  }

  void filePicker() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null) {
      File file = File(result.files.single.path!);

      double sizeInMb = file.lengthSync() / (1024 * 1024);
      if (sizeInMb < 4) {
        uploadFileToFirebase(result, file);
      } else {
        Constant.showCustomSnackbar(AppColors.white, AppString.errorFileSize);
      }
    } else {
      // User canceled the picker
    }
  }

  void uploadFileToFirebase(FilePickerResult result, File file) async {
    String fileName = result.files.first.name;

    try {
      FirebaseStorage.instance
          .ref('chat')
          .child(fileName)
          .putFile(file)
          .snapshotEvents
          .listen((event) async {
        switch (event.state) {
          case TaskState.running:
            break;
          case TaskState.paused:
            break;
          case TaskState.success:
            String? getFilePath = await getFileUrl(fileName);
            sendMessage(true, getFilePath);

            break;
          default:
        }
      });
    } catch (e) {
      print(e.toString());
    }
  }

  getFileUrl(String fileName) async {
    final ref = FirebaseStorage.instance.ref('chat').child(fileName);
    String url = await ref.getDownloadURL();
    return url;
  }
}
