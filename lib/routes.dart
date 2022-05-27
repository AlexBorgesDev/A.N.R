// ignore_for_file: constant_identifier_names

import 'package:A.N.R/screens/login_screen.dart';
import 'package:flutter/material.dart';

class RoutesName {
  static const LOGIN = '/login';
  static const BROWSER = '/browser';
  static const READER = '/reader';
}

class Routes {
  static Map<String, Widget Function(BuildContext)> get routes {
    return {
      RoutesName.LOGIN: (_) => const LoginScreen(),
    };
  }
}
