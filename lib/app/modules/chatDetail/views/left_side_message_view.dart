import 'package:chat_using_firebase_getx/app/data/models/message_details.dart';
import 'package:chat_using_firebase_getx/app/utils/app_colors.dart';
import 'package:chat_using_firebase_getx/app/utils/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

Widget leftSideMessageView(MessageDetails msg) {
  return Container(
    padding: EdgeInsets.all(8.w),
    child: Row(
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: Get.width / 1.5,
            minHeight: 36.h,
          ),
          child: Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: AppColors.primaryColor,
              borderRadius: BorderRadius.all(
                Radius.circular(8.w),
              ),
            ),
            child: msg.type == 'text'
                ? Text(
                    msg.content!,
                    style: bodyMedium,
                  )
                : ConstrainedBox(
                    constraints: BoxConstraints(
                      minWidth: 160.w,
                      maxWidth: 200.w,
                      maxHeight: 220.h,
                    ),
                    child: Image.network(
                      msg.content!,
                      fit: BoxFit.fill,
                    ),
                  ),
          ),
        )
      ],
    ),
  );
}
