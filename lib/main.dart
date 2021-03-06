import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:A.N.R/constants/ports.dart';
import 'package:A.N.R/databases/downloads_db.dart';
import 'package:A.N.R/firebase_options.dart';
import 'package:A.N.R/models/download.dart';
import 'package:A.N.R/routes.dart';
import 'package:A.N.R/services/book_content.dart';
import 'package:A.N.R/store/favorites_store.dart';
import 'package:A.N.R/store/historic_store.dart';
import 'package:A.N.R/styles/theme.dart';
import 'package:A.N.R/utils/file_mime_by_url.dart';
import 'package:A.N.R/utils/folders.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';
import 'package:workmanager/workmanager.dart';

SendPort? send() => IsolateNameServer.lookupPortByName(Ports.DOWNLOAD);

void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    final DownloadsDB db = DownloadsDB.db;
    List<Download> items = await db.notFinished;

    if (items.isEmpty) return Future.value(true);

    for (Download item in items) {
      final String bookPath = await Folders.createBook(item.bookId);

      List<String> content = item.content;

      if (content.isEmpty) {
        content = await bookContent(item.contentUrl);

        final Download updatedItem = Download(
          bookId: item.bookId,
          chapterId: item.chapterId,
          content: content,
          contentUrl: item.contentUrl,
          status: item.status,
        );

        await db.update(updatedItem);
        send()?.send(DownloadSend(
          type: DownloadSendTypes.updated,
          data: updatedItem,
        ));
      }

      final String path = await Folders.createChapter(
        bookPath: bookPath,
        chapterId: item.chapterId,
      );

      int index = 1;
      bool error = false;
      for (String url in content) {
        final String type = fileMimeByUrl(url);
        final String savePath = Directory('$path/$index.$type').path;

        try {
          await Dio().download(url, savePath);
          index++;
        } catch (_) {
          error = true;
          break;
        }
      }

      if (error) {
        await db.remove(item.id);
        await Folders.deleteChapter(
          bookPath: bookPath,
          chapterId: item.chapterId,
        );

        send()?.send(DownloadSend(type: DownloadSendTypes.error, data: item));
      } else {
        final Download downloaded = Download(
          bookId: item.bookId,
          chapterId: item.chapterId,
          content: content,
          contentUrl: item.contentUrl,
          status: DownloadStatus.finished,
        );

        await db.update(downloaded);
        send()?.send(DownloadSend(
          type: DownloadSendTypes.finished,
          data: downloaded,
        ));
      }
    }

    items = await db.notFinished;
    if (items.isEmpty) return Future.value(true);

    return Future.value(false);
  });
}

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  Workmanager().initialize(callbackDispatcher, isInDebugMode: false);

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
