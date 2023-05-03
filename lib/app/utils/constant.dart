import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:loading_indicator/loading_indicator.dart';

class Constant {
  static final GoogleSignIn googleSignIn = GoogleSignIn(
    scopes: ['openid'],
  );

  static showCustomSnackbar(Color color, String msg, [int duration = 1]) {
    Get.showSnackbar(GetSnackBar(
      backgroundColor: color,
      duration: Duration(seconds: duration),
      message: msg,
    ));
  }

  // loader setup start
  static final List<Color> _kDefaultRainbowColors = [
    const Color(0xFFF5484A),
    const Color(0xFF4D813D),
    const Color(0xFFD95A2E),
    const Color(0xFFE4E4E5),
    const Color(0xFFAC2525),
    const Color(0xFF4E4E4E),
    const Color(0xFF30110D),
  ];

  static showLoader() {
    Get.dialog(
      Center(
        child: SizedBox(
          width: 64.w,
          height: 64.h,
          child: LoadingIndicator(
            indicatorType: Indicator.ballGridPulse,
            colors: _kDefaultRainbowColors,
            strokeWidth: 4.0,
          ),
        ),
      ),
    );
  }

  static dismissLoader() {
    if (Get.isDialogOpen!) {
      Get.back();
    }
  }
// end loader setup
}
