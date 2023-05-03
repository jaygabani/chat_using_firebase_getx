import 'package:get/get.dart';

import '../modules/chatDetail/bindings/chat_detail_binding.dart';
import '../modules/chatDetail/views/chat_detail_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/signIn/bindings/sign_in_binding.dart';
import '../modules/signIn/views/sign_in_view.dart';
import '../utils/shared_pref.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static final INITIAL = (SharedPref.pref.hasData(SharedPref.spIsLogin) &&
          SharedPref.pref.hasData(SharedPref.spIsLogin) == true)
      ? Routes.HOME
      : Routes.SIGN_IN;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.SIGN_IN,
      page: () => const SignInView(),
      binding: SignInBinding(),
    ),
    GetPage(
      name: _Paths.CHAT_DETAIL,
      page: () => const ChatDetailView(),
      binding: ChatDetailBinding(),
    ),
  ];
}
