// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'download_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$DownloadStore on DownloadStoreBase, Store {
  final _$downloadingAtom = Atom(name: 'DownloadStoreBase.downloading');

  @override
  ObservableMap<String, String> get downloading {
    _$downloadingAtom.reportRead();
    return super.downloading;
  }

  @override
  set downloading(ObservableMap<String, String> value) {
    _$downloadingAtom.reportWrite(value, super.downloading, () {
      super.downloading = value;
    });
  }

  final _$downloadedAtom = Atom(name: 'DownloadStoreBase.downloaded');

  @override
  ObservableList<Chapter> get downloaded {
    _$downloadedAtom.reportRead();
    return super.downloaded;
  }

  @override
  set downloaded(ObservableList<Chapter> value) {
    _$downloadedAtom.reportWrite(value, super.downloaded, () {
      super.downloaded = value;
    });
  }

  final _$DownloadStoreBaseActionController =
      ActionController(name: 'DownloadStoreBase');

  @override
  void add(Chapter chapter) {
    final _$actionInfo = _$DownloadStoreBaseActionController.startAction(
        name: 'DownloadStoreBase.add');
    try {
      return super.add(chapter);
    } finally {
      _$DownloadStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic addDownloading(String bookId, String? cap) {
    final _$actionInfo = _$DownloadStoreBaseActionController.startAction(
        name: 'DownloadStoreBase.addDownloading');
    try {
      return super.addDownloading(bookId, cap);
    } finally {
      _$DownloadStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic removeDownloading(String bookId) {
    final _$actionInfo = _$DownloadStoreBaseActionController.startAction(
        name: 'DownloadStoreBase.removeDownloading');
    try {
      return super.removeDownloading(bookId);
    } finally {
      _$DownloadStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
downloading: ${downloading},
downloaded: ${downloaded}
    ''';
  }
}
