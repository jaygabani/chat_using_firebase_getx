import 'package:chat_using_firebase_getx/app/data/models/user_details.dart';
import 'package:chat_using_firebase_getx/app/utils/app_colors.dart';
import 'package:chat_using_firebase_getx/app/utils/app_string.dart';
import 'package:chat_using_firebase_getx/app/utils/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    timeDilation = 3.0;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppString.chat,
          style:
              headlineLarge.copyWith(color: AppColors.white, fontSize: 20.sp),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16.w),
            child: Center(
              child: TextButton(
                onPressed: () {
                  controller.signOut();
                },
                child: Text(
                  AppString.signOut,
                  style: bodyMedium.copyWith(color: AppColors.white),
                ),
              ),
            ),
          )
        ],
      ),
      body: RefreshIndicator(
        backgroundColor: Colors.transparent,
        onRefresh: () async {
          controller.getAllUserList();
        },
        child: Obx(
          () => (controller.chatUsers.isNotEmpty)
              ? ListView.builder(
                  itemCount: controller.chatUsers.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return usersList(
                      controller.chatUsers[index],
                    );
                  },
                )
              : Padding(
                  padding: const EdgeInsets.all(16).w,
                  child: Center(
                    child: Text(
                      AppString.noChatUserAvailable,
                      style: bodyLarge,
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  Widget usersList(UserDetails userDetails) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 16.h),
      child: GestureDetector(
        onTap: () {
          if (userDetails.id != '') {
            controller.checkChatIsCreated(userDetails);
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: <Widget>[
                Expanded(
                  child: Row(
                    children: <Widget>[
                      Hero(
                        tag: 'tag',
                        child: CircleAvatar(
                          backgroundImage:
                              NetworkImage(userDetails.profilePhoto!),
                          maxRadius: 24.r,
                        ),
                      ),
                      SizedBox(
                        width: 16.w,
                      ),
                      Expanded(
                        child: Text(
                          userDetails.displayName!,
                          style: bodyLarge,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              child: const Divider(
                height: 0.5,
                color: AppColors.dividerColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
