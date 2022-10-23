import 'package:firebase_auth/firebase_auth.dart';

class AppSingleton {
  AppSingleton._internal();

  static final AppSingleton _appSingleton = AppSingleton._internal();

  factory AppSingleton() => _appSingleton;

  /// The user data.
  static User? user;
}