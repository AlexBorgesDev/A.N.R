class Chapter {
  final String id;
  final String url;
  final String name;
  final double? position;

  const Chapter({
    required this.id,
    required this.url,
    required this.name,
    this.position,
  });

  Map<String, Object?> get toMap {
    return {
      'id': id,
      'url': url,
      'name': name,
      'position': position,
    };
  }
}

class ChapterDownload {
  final String id;
  final String url;
  final String name;
  final String bookId;
  final String taskId;
  final bool downloaded;

  const ChapterDownload({
    required this.id,
    required this.url,
    required this.name,
    required this.bookId,
    required this.taskId,
    this.downloaded = false,
  });

  Map<String, Object> get toMap {
    return {
      'id': id,
      'url': url,
      'name': name,
      'bookId': bookId,
      'taskId': taskId,
      'downloaded': downloaded,
    };
  }
}
