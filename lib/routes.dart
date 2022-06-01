// ignore_for_file: constant_identifier_names

import 'package:A.N.R/screens/home_screen.dart';
import 'package:A.N.R/screens/login_screen.dart';
import 'package:A.N.R/screens/search_screen.dart';
import 'package:flutter/material.dart';

class RoutesName {
  static const LOGIN = '/login';
  static const HOME = '/home';

  static const BOOK = '/book';
  static const READER = '/reader';
  static const SEARCH = '/search';
  static const FAVORITES = '/favorites';
}

class Routes {
  static Map<String, Widget Function(BuildContext)> get routes {
    return {
      RoutesName.LOGIN: (_) => const LoginScreen(),
      RoutesName.HOME: (_) => const HomeScreen(),
      RoutesName.SEARCH: (_) => const SearchScreen(),
    };
  }
}
