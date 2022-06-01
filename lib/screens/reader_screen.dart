import 'dart:convert';

import 'package:A.N.R/models/book_item.dart';
import 'package:A.N.R/models/chapter.dart';
import 'package:A.N.R/services/book_content.dart';
import 'package:A.N.R/services/historic.dart';
import 'package:A.N.R/store/historic_store.dart';
import 'package:A.N.R/styles/colors.dart';
import 'package:A.N.R/utils/html_template.dart';
import 'package:A.N.R/utils/reader_js.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ReaderScreen extends StatefulWidget {
  const ReaderScreen({Key? key}) : super(key: key);

  @override
  State<ReaderScreen> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends State<ReaderScreen> {
  final String _html = Uri.dataFromString(
    htmlTemplate,
    mimeType: 'text/html',
    encoding: Encoding.getByName('utf-8'),
  ).toString();

  late int _index;
  late BookItem _book;
  late List<Chapter> _chapters;
  late Historic _historic;

  ReaderJS? _js;

  bool _finished = false;
  bool _isLoading = true;
  bool _getNextCap = true;

  Future<void> _getContent() async {
    final Chapter chapter = _chapters[_index];

    final List<String> content = await bookContent(chapter.url);
    await _js!.insertContent(content, _index, chapter.name);

    if (_finished) await _js!.finishedChapters();

    _getNextCap = false;
  }

  Future<void> _onLoad(JavascriptMessage message) async {
    if (!_isLoading) return;
    _isLoading = false;

    await _js!.removeLoading();
  }

  void _onNext(JavascriptMessage message) {
    if (_finished || _getNextCap) return;

    _index = _index - 1;
    _finished = _index == 0;

    _getContent();
  }

  void _onRead(JavascriptMessage message) {
    final int index = int.parse(message.message);
    _historic.toggleHistoric(_chapters[index].id);
  }

  @override
  void didChangeDependencies() {
    final HistoricStore store = Provider.of<HistoricStore>(context);
    final args = ModalRoute.of(context)!.settings.arguments as ReaderArguments;

    _book = args.book;
    _index = args.index;
    _chapters = args.chapters;
    _historic = Historic(bookID: _book.id, context: context, store: store);

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WebView(
        initialUrl: _html,
        javascriptMode: JavascriptMode.unrestricted,
        backgroundColor: CustomColors.background,
        gestureNavigationEnabled: true,
        onWebViewCreated: (controller) {
          _js = ReaderJS(controller);
          _getContent();
        },
        javascriptChannels: {
          JavascriptChannel(name: 'onLoad', onMessageReceived: _onLoad),
          JavascriptChannel(name: 'onNext', onMessageReceived: _onNext),
          JavascriptChannel(name: 'onRead', onMessageReceived: _onRead),
        },
      ),
    );
  }
}

class ReaderArguments {
  final int index;
  final BookItem book;
  final List<Chapter> chapters;

  const ReaderArguments({
    required this.index,
    required this.book,
    required this.chapters,
  });
}
