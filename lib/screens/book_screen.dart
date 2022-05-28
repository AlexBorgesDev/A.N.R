import 'package:A.N.R/models/book_item.dart';
import 'package:A.N.R/styles/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class BookScreen extends StatefulWidget {
  const BookScreen({Key? key}) : super(key: key);

  @override
  State<BookScreen> createState() => _BookScreenState();
}

class _BookScreenState extends State<BookScreen> {
  final ScrollController _scroll = ScrollController();

  late BookItem _bookItem;

  bool _isLoading = true;
  bool _pinnedTitle = false;

  void _scrollListener() {
    final double imageHeight = (70 * MediaQuery.of(context).size.height) / 100;

    if (!_pinnedTitle && _scroll.offset >= imageHeight) {
      setState(() => _pinnedTitle = true);
    } else if (_pinnedTitle && _scroll.offset < imageHeight) {
      setState(() => _pinnedTitle = false);
    }
  }

  @override
  void didChangeDependencies() {
    _bookItem = ModalRoute.of(context)!.settings.arguments as BookItem;

    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    _scroll.addListener(_scrollListener);
  }

  @override
  void dispose() {
    super.dispose();
    _scroll.removeListener(_scrollListener);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        controller: _scroll,
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            title: _pinnedTitle ? Text(_bookItem.name) : null,
            pinned: true,
            centerTitle: false,
            expandedHeight: (74 * MediaQuery.of(context).size.height) / 100,
            backgroundColor: Colors.transparent,
            actions: [],
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.pin,
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Positioned.fill(
                    child: _bookItem.imageURL != null
                        ? CachedNetworkImage(
                            fit: BoxFit.cover,
                            imageUrl: _bookItem.imageURL ?? '',
                            errorWidget: (context, url, error) {
                              if (_bookItem.imageURL2 == null) {
                                return const SizedBox();
                              }

                              return CachedNetworkImage(
                                fit: BoxFit.cover,
                                imageUrl: _bookItem.imageURL2!,
                              );
                            },
                          )
                        : const SizedBox(),
                  ),
                  Positioned.fill(
                    top: 0,
                    bottom: -1,
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: [0, 0.5, 0.95],
                          colors: [
                            CustomColors.background,
                            Colors.transparent,
                            CustomColors.background,
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Text(
                            _bookItem.name,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        // subtitle
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
