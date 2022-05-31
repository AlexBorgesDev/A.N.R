import 'dart:convert';

import 'package:A.N.R/models/chapter.dart';
import 'package:A.N.R/services/leitor/leitor_get_chapter_content.dart';
import 'package:A.N.R/styles/colors.dart';
import 'package:A.N.R/utils/render_html.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ReaderScreen extends StatefulWidget {
  const ReaderScreen({Key? key}) : super(key: key);

  @override
  State<ReaderScreen> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends State<ReaderScreen> {
  late Chapter _chapter;

  String _html = '';
  bool _loading = true;

  @override
  void didChangeDependencies() {
    _chapter = ModalRoute.of(context)!.settings.arguments as Chapter;

    leitorGetChapterContent(_chapter.idRelease)
        .then((images) => setState(() {
              final bookHTML = RenderHTML.render(
                'Capítulo ${_chapter.number}',
                images,
              );

              final String html = Uri.dataFromString(
                bookHTML,
                mimeType: 'text/html',
                encoding: Encoding.getByName('utf-8'),
              ).toString();

              setState(() {
                _html = html;
                _loading = false;
              });
            }))
        .catchError((e) {
      final messenger = ScaffoldMessenger.of(context);

      messenger.clearSnackBars();
      messenger.showSnackBar(
        const SnackBar(
          content: Text('Algo deu errado ao obter o conteúdo do capitulo.'),
        ),
      );

      Navigator.of(context).pop();
    });

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : WebView(
              initialUrl: _html,
              javascriptMode: JavascriptMode.unrestricted,
              backgroundColor: CustomColors.background,
              gestureNavigationEnabled: true,
            ),
    );
  }
}
