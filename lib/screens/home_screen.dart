import 'package:A.N.R/models/book_item.dart';
import 'package:A.N.R/routes.dart';
import 'package:A.N.R/services/scans/manga_host_services.dart';
import 'package:A.N.R/services/scans/neox_services.dart';
import 'package:A.N.R/widgets/book_element_horizontal_list.dart';
import 'package:A.N.R/widgets/section_list_title.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = true;

  List<BookItem> _neox = [];
  List<BookItem> _mangaHost = [];

  Future<void> _handleGetDatas() async {
    final items = await Future.wait([
      NeoxServices.lastAdded,
      MangaHostServices.lastAdded,
    ]);

    setState(() {
      _neox = items[0];
      _mangaHost = items[1];
      _isLoading = false;
    });
  }

  @override
  void initState() {
    _handleGetDatas();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('A.N.R'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _handleGetDatas,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SectionListTitle('Neox - Últimos adicionados'),
              BookElementHorizontalList(
                isLoading: _isLoading,
                itemCount: _neox.length,
                itemData: (index) {
                  final BookItem book = _neox[index];
                  return BookElementData(
                    tag: book.tag,
                    imageURL: book.imageURL,
                    imageURL2: book.imageURL2,
                    onTap: () {
                      Navigator.of(context).pushNamed(
                        RoutesName.BOOK,
                        arguments: book,
                      );
                    },
                  );
                },
              ),
              const SectionListTitle('Mangá Host - Últimos adicionados'),
              BookElementHorizontalList(
                isLoading: _isLoading,
                itemCount: _mangaHost.length,
                itemData: (index) {
                  final BookItem book = _mangaHost[index];
                  return BookElementData(
                    tag: book.tag,
                    is18: book.is18,
                    headers: book.headers,
                    imageURL: book.imageURL,
                    imageURL2: book.imageURL2,
                    onTap: () {
                      Navigator.of(context).pushNamed(
                        RoutesName.BOOK,
                        arguments: book,
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
