import 'package:A.N.R/firebase_options.dart';
import 'package:A.N.R/routes.dart';
import 'package:A.N.R/store/favorites_store.dart';
import 'package:A.N.R/styles/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isAuthenticated = FirebaseAuth.instance.currentUser != null;

    return MultiProvider(
      providers: [Provider(create: (_) => FavoritesStore())],
      child: MaterialApp(
        title: 'A.N.R',
        themeMode: ThemeMode.dark,
        darkTheme: CustomTheme.dark,
        debugShowCheckedModeBanner: false,
        initialRoute: isAuthenticated ? RoutesName.BROWSER : RoutesName.LOGIN,
        routes: Routes.routes,
      ),
    );
  }
}
