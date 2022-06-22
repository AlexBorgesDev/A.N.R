// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'downloaded_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$DownloadedStore on DownloadedStoreBase, Store {
  Computed<int>? _$totalComputed;

  @override
  int get total => (_$totalComputed ??=
          Computed<int>(() => super.total, name: 'DownloadedStoreBase.total'))
      .value;

  final _$chaptersAtom = Atom(name: 'DownloadedStoreBase.chapters');

  @override
  ObservableMap<String, dynamic> get chapters {
    _$chaptersAtom.reportRead();
    return super.chapters;
  }

  @override
  set chapters(ObservableMap<String, dynamic> value) {
    _$chaptersAtom.reportWrite(value, super.chapters, () {
      super.chapters = value;
    });
  }

  final _$DownloadedStoreBaseActionController =
      ActionController(name: 'DownloadedStoreBase');

  @override
  void add(String key) {
    final _$actionInfo = _$DownloadedStoreBaseActionController.startAction(
        name: 'DownloadedStoreBase.add');
    try {
      return super.add(key);
    } finally {
      _$DownloadedStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void remove(String key) {
    final _$actionInfo = _$DownloadedStoreBaseActionController.startAction(
        name: 'DownloadedStoreBase.remove');
    try {
      return super.remove(key);
    } finally {
      _$DownloadedStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void set(Map<String, dynamic> data) {
    final _$actionInfo = _$DownloadedStoreBaseActionController.startAction(
        name: 'DownloadedStoreBase.set');
    try {
      return super.set(data);
    } finally {
      _$DownloadedStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void reset() {
    final _$actionInfo = _$DownloadedStoreBaseActionController.startAction(
        name: 'DownloadedStoreBase.reset');
    try {
      return super.reset();
    } finally {
      _$DownloadedStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
chapters: ${chapters},
total: ${total}
    ''';
  }
}
