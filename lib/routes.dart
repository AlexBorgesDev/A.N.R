// ignore_for_file: constant_identifier_names

import 'package:A.N.R/screens/book_screen.dart';
import 'package:A.N.R/screens/browser_screen.dart';
import 'package:A.N.R/screens/login_screen.dart';
import 'package:A.N.R/screens/search_screen.dart';
import 'package:flutter/material.dart';

class RoutesName {
  static const LOGIN = '/login';
  static const BROWSER = '/browser';

  static const BOOK = '/book';
  static const READER = '/reader';
  static const SEARCH = '/search';
  static const FAVORITEs = '/favorites';
}

class Routes {
  static Map<String, Widget Function(BuildContext)> get routes {
    return {
      RoutesName.LOGIN: (_) => const LoginScreen(),
      RoutesName.BROWSER: (_) => const BrowserScreen(),
      RoutesName.SEARCH: (_) => const SearchScreen(),
      RoutesName.BOOK: (_) => const BookScreen(),
    };
  }
}
