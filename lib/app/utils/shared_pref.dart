import 'package:get_storage/get_storage.dart';

class SharedPref {
  // Store the data of user information etc.
  static final pref = GetStorage();

  static const String spIsLogin = 'spIsLogin';
  static const String spDisplayName = 'spDisplayName';
  static const String spUserID = 'spUserID';
  static const String spProfilePhoto = 'spProfilePhoto';
  static const String spEmail = 'spEmail';
}
