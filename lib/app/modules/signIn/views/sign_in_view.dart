import 'package:chat_using_firebase_getx/app/utils/app_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

import '../controllers/sign_in_controller.dart';

class SignInView extends GetView<SignInController> {
  const SignInView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppString.signIn),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              AppString.signInWithGoogle,
              style: Get.theme.textTheme.bodyLarge,
            ),
            SizedBox(
              height: 24.h,
            ),
            ElevatedButton(
              style: ButtonStyle(
                fixedSize: MaterialStatePropertyAll(Size(Get.width / 2, 36.h)),
              ),
              onPressed: () {
                // Perform signIn action here
                controller.signIn();
              },
              child: const Text(AppString.signIn),
            ),
          ],
        ),
      ),
    );
  }
}
