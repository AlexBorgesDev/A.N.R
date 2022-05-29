import 'package:A.N.R/constants/providers.dart';
import 'package:A.N.R/models/book_item.dart';
import 'package:A.N.R/routes.dart';
import 'package:A.N.R/screens/search_screen.dart';
import 'package:A.N.R/services/favorites.dart';
import 'package:A.N.R/services/leitor/leitor_highlights.dart';
import 'package:A.N.R/services/leitor/leitor_most_read.dart';
import 'package:A.N.R/services/leitor/leitor_most_read_week.dart';
import 'package:A.N.R/services/leitor/leitor_releases.dart';
import 'package:A.N.R/widgets/book_element_horizontal_list.dart';
import 'package:A.N.R/widgets/section_list_title.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class BrowserScreen extends StatefulWidget {
  const BrowserScreen({Key? key}) : super(key: key);

  @override
  State<BrowserScreen> createState() => _BrowserScreenState();
}

class _BrowserScreenState extends State<BrowserScreen> {
  bool _isLoading = true;

  List<BookLeitorMostRead> _mostRead = [];
  List<BookLeitorHighlights> _highlights = [];
  List<BookLeitorMostReadWeek> _mostReadWeek = [];
  List<BookLeitorReleases> _releases = [];

  Future<void> _handleGetData() async {
    final List<BookLeitorHighlights> highlights = await leitorHighlights();
    setState(() => _highlights = highlights);

    final items = await Future.wait([
      leitorMostReadWeek(),
      leitorMostRead(),
      leitorReleases(),
    ]);

    setState(() {
      _mostReadWeek = items[0] as List<BookLeitorMostReadWeek>;
      _mostRead = items[1] as List<BookLeitorMostRead>;
      _releases = items[2] as List<BookLeitorReleases>;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    _handleGetData();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    Favorites.getAll(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('A.N.R'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.of(context).pushNamed(
                RoutesName.SEARCH,
                arguments: const SearchArguments(Providers.leitor),
              );
            },
          ),
          PopupMenuButton(
            icon: const Icon(Icons.more_vert),
            itemBuilder: (context) => <PopupMenuEntry>[
              const PopupMenuItem(enabled: false, child: Text('Neox')),
              const PopupMenuItem(enabled: false, child: Text('Downloads')),
              const PopupMenuItem(child: Text('Sair')),
            ],
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _handleGetData,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CarouselSlider(
                items: _highlights.map((e) {
                  final color = int.parse('0xff${e.hexColor}');
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(color: Color(color)),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Positioned.fill(
                          child: CachedNetworkImage(
                            imageUrl: e.imageURL,
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                        Positioned(
                          top: 8,
                          left: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 4,
                              horizontal: 8,
                            ),
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(22, 22, 30, 0.8),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '${e.chapter}',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                        ),
                        Positioned.fill(
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(onTap: () {
                              Navigator.of(context).pushNamed(
                                RoutesName.BOOK,
                                arguments: BookItem(
                                  id: e.id.toString(),
                                  url: e.url,
                                  name: e.name,
                                  provider: Providers.leitor,
                                ),
                              );
                            }),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
                options: CarouselOptions(
                  height: 232,
                  autoPlay: true,
                  viewportFraction: 1,
                ),
              ),
              const SectionListTitle('Mais lidos da semana'),
              BookElementHorizontalList(
                isLoading: _isLoading,
                itemCount: _mostReadWeek.length,
                itemData: (index) {
                  final data = _mostReadWeek[index];
                  return BookElementProps(
                    imageURL2: data.imageURL,
                    imageURL: data.imageURL2,
                    onTap: () {
                      Navigator.of(context).pushNamed(
                        RoutesName.BOOK,
                        arguments: BookItem(
                          id: data.id.toString(),
                          url: data.url,
                          name: data.name,
                          provider: Providers.leitor,
                          imageURL: data.imageURL,
                          imageURL2: data.imageURL2,
                        ),
                      );
                    },
                  );
                },
              ),
              SectionListTitle('Mais lidos', viewMore: () {}),
              BookElementHorizontalList(
                isLoading: _isLoading,
                itemCount: _mostRead.length,
                itemData: (index) {
                  final data = _mostRead[index];
                  return BookElementProps(
                    imageURL2: data.imageURL,
                    imageURL: data.imageURL2,
                    onTap: () {
                      Navigator.of(context).pushNamed(
                        RoutesName.BOOK,
                        arguments: BookItem(
                          id: data.id.toString(),
                          url: data.url,
                          name: data.name,
                          provider: Providers.leitor,
                          imageURL: data.imageURL,
                          imageURL2: data.imageURL2,
                        ),
                      );
                    },
                  );
                },
              ),
              SectionListTitle('Lançamentos', viewMore: () {}),
              BookElementHorizontalList(
                isLoading: _isLoading,
                itemCount: _releases.length,
                itemData: (index) {
                  final data = _releases[index];
                  return BookElementProps(
                    imageURL2: data.imageURL,
                    imageURL: data.imageURL2,
                    onTap: () {
                      Navigator.of(context).pushNamed(
                        RoutesName.BOOK,
                        arguments: BookItem(
                          id: data.id.toString(),
                          url: data.url,
                          name: data.name,
                          provider: Providers.leitor,
                          imageURL: data.imageURL,
                          imageURL2: data.imageURL2,
                        ),
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
