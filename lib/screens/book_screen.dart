import 'package:flutter/material.dart';

class BookScreen extends StatefulWidget {
  const BookScreen({Key? key}) : super(key: key);

  @override
  State<BookScreen> createState() => _BookScreenState();
}

class _BookScreenState extends State<BookScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}

class BookArguments {
  final String? id;
  final String url;
  final String name;
  final String imageURL;
  final String? imageURL2;

  const BookArguments({
    required this.url,
    required this.name,
    required this.imageURL,
    this.imageURL2,
    this.id,
  });
}
