import 'package:A.N.R/styles/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class BookElement extends StatelessWidget {
  final String? tag;
  final String imageURL;
  final String? imageURL2;
  final EdgeInsetsGeometry? margin;
  final Function() onTap;
  final Function()? onLongPress;

  const BookElement({
    required this.imageURL,
    required this.onTap,
    this.onLongPress,
    this.imageURL2,
    this.margin,
    this.tag,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Container(
          color: CustomColors.surface,
          width: 112,
          height: 158.49,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Positioned.fill(
                child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl: imageURL,
                  errorWidget: imageURL2 != null
                      ? (context, url, error) {
                          return CachedNetworkImage(
                            fit: BoxFit.cover,
                            imageUrl: imageURL2!,
                          );
                        }
                      : null,
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                child: tag != null
                    ? Container(
                        margin: const EdgeInsets.all(6),
                        padding: const EdgeInsets.symmetric(
                          vertical: 2.5,
                          horizontal: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(22, 22, 30, 0.8),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        constraints: const BoxConstraints(maxWidth: 100),
                        child: FittedBox(
                          child: Text(
                            tag!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                          ),
                        ),
                      )
                    : const SizedBox(),
              ),
              Positioned.fill(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(onTap: onTap, onLongPress: onLongPress),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BookElementShimmer extends StatelessWidget {
  final EdgeInsetsGeometry? margin;

  const BookElementShimmer({this.margin, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: Shimmer.fromColors(
        baseColor: CustomColors.surface,
        highlightColor: CustomColors.surfaceTwo,
        child: Container(
          width: 112,
          height: 158.49,
          decoration: BoxDecoration(
            color: CustomColors.surface,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}
