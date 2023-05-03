import 'package:chat_using_firebase_getx/app/modules/chatDetail/views/left_side_message_view.dart';
import 'package:chat_using_firebase_getx/app/modules/chatDetail/views/right_side_message_view.dart';
import 'package:chat_using_firebase_getx/app/utils/app_colors.dart';
import 'package:chat_using_firebase_getx/app/utils/app_string.dart';
import 'package:chat_using_firebase_getx/app/utils/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

import '../controllers/chat_detail_controller.dart';

class ChatDetailView extends GetView<ChatDetailController> {
  const ChatDetailView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          padding: EdgeInsets.zero,
          child: Obx(
            () => Row(
              children: [
                Hero(
                  tag: 'tag',
                  child: SizedBox(
                    width: 40.w,
                    height: 40.w,
                    child: (controller.toProfilePhoto.value != '')
                        ? CircleAvatar(
                            backgroundImage:
                                NetworkImage(controller.toProfilePhoto.value),
                          )
                        : null,
                  ),
                ),
                SizedBox(
                  width: 8.w,
                ),
                Expanded(
                  child: Text(
                    controller.toName.value,
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.ellipsis,
                    style: headlineLarge.copyWith(
                        color: AppColors.white, fontSize: 20.sp),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Obx(
              () => Container(
                padding: EdgeInsets.only(bottom: 50.h),
                child: CustomScrollView(
                  controller: controller.msgScrolling,
                  reverse: true,
                  slivers: [
                    if (controller.messageList.isNotEmpty)
                      SliverPadding(
                        padding: EdgeInsets.zero,
                        sliver: SliverList(
                            delegate:
                                SliverChildBuilderDelegate((context, index) {
                          var msg = controller.messageList[index];
                          if (msg.uID == controller.toID.value) {
                            return leftSideMessageView(msg);
                          }
                          return rightSideMessageView(msg);
                        }, childCount: controller.messageList.length)),
                      ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                padding: EdgeInsets.only(left: 8.w, bottom: 8.h, top: 8.h),
                height: 48.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.background,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.grey.withOpacity(0.4),
                      spreadRadius: 1,
                      blurRadius: 1,
                      offset: const Offset(0, -1), // changes position of shadow
                    ),
                  ],
                ),
                child: Row(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        controller.filePicker();
                      },
                      child: Container(
                        height: 24.w,
                        width: 24.w,
                        decoration: BoxDecoration(
                          color: AppColors.buttonColor,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 16.w,
                    ),
                    Expanded(
                      child: TextField(
                        controller: controller.sendTextController,
                        style: bodyMedium.copyWith(color: AppColors.white),
                        decoration: InputDecoration(
                          isDense: true,
                          hintText: AppString.writeSomeMessage,
                          hintStyle:
                              bodyMedium.copyWith(color: AppColors.white),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 16.w,
                    ),
                    FloatingActionButton(
                      onPressed: () {
                        controller.sendMessage(false);
                      },
                      backgroundColor: AppColors.buttonColor,
                      elevation: 0,
                      child: Icon(
                        Icons.send,
                        color: Colors.white,
                        size: 16.w,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
