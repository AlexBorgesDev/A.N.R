import 'package:A.N.R/widgets/book_element.dart';
import 'package:flutter/material.dart';

class BookElementHorizontalList extends StatelessWidget {
  final EdgeInsetsGeometry? margin;

  final double height;
  final bool isLoading;

  final int itemCount;
  final BookElementProps Function(int) itemData;

  final int loadingItemCount;

  const BookElementHorizontalList({
    required this.itemCount,
    required this.itemData,
    this.loadingItemCount = 4,
    this.isLoading = false,
    this.height = 158.49,
    this.margin,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? const EdgeInsets.only(bottom: 8),
      height: height,
      child: isLoading
          ? ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: loadingItemCount,
              itemBuilder: (_, index) => const BookElementShimmer(
                margin: EdgeInsets.symmetric(horizontal: 4),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: itemCount,
              itemBuilder: (_, index) {
                final BookElementProps data = itemData(index);
                return BookElement(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  tag: data.tag,
                  imageURL: data.imageURL,
                  onLongPress: data.onLongPress,
                  onTap: data.onTap,
                );
              },
            ),
    );
  }
}

class BookElementProps {
  final String? tag;
  final String imageURL;
  final Function() onTap;
  final Function()? onLongPress;

  const BookElementProps({
    required this.imageURL,
    required this.onTap,
    this.onLongPress,
    this.tag,
  });
}
