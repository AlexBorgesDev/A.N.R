import 'package:flutter/material.dart';

class SectionListTitle extends StatelessWidget {
  final String title;
  final void Function()? viewMore;

  const SectionListTitle(this.title, {this.viewMore, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleSmall),
          TextButton(
            onPressed: viewMore,
            child: Text(viewMore != null ? 'Ver mais' : ''),
          ),
        ],
      ),
    );
  }
}
