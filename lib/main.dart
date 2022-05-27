import 'package:A.N.R/routes.dart';
import 'package:A.N.R/styles/theme.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'A.N.R',
      themeMode: ThemeMode.dark,
      darkTheme: CustomTheme.dark,
      debugShowCheckedModeBanner: false,
      initialRoute: RoutesName.LOGIN,
      routes: Routes.routes,
    );
  }
}
