import 'package:A.N.R/firebase_options.dart';
import 'package:A.N.R/routes.dart';
import 'package:A.N.R/store/download_store.dart';
import 'package:A.N.R/store/favorites_store.dart';
import 'package:A.N.R/store/historic_store.dart';
import 'package:A.N.R/styles/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseDatabase.instance.setPersistenceEnabled(true);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isAuthenticated = FirebaseAuth.instance.currentUser != null;

    return MultiProvider(
      providers: [
        Provider(create: (_) => FavoritesStore()),
        Provider(create: (_) => HistoricStore()),
        Provider(create: (_) => DownloadStore()),
      ],
      child: MaterialApp(
        title: 'A.N.R',
        themeMode: ThemeMode.dark,
        darkTheme: CustomTheme.dark,
        debugShowCheckedModeBanner: false,
        initialRoute: isAuthenticated ? RoutesName.HOME : RoutesName.LOGIN,
        routes: Routes.routes,
      ),
    );
  }
}
