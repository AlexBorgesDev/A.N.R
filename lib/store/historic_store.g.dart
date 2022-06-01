// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'historic_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$HistoricStore on HistoricStoreBase, Store {
  final _$historicAtom = Atom(name: 'HistoricStoreBase.historic');

  @override
  ObservableMap<String, ObservableList<String>> get historic {
    _$historicAtom.reportRead();
    return super.historic;
  }

  @override
  set historic(ObservableMap<String, ObservableList<String>> value) {
    _$historicAtom.reportWrite(value, super.historic, () {
      super.historic = value;
    });
  }

  final _$HistoricStoreBaseActionController =
      ActionController(name: 'HistoricStoreBase');

  @override
  void set(Map<String, ObservableList<String>> data) {
    final _$actionInfo = _$HistoricStoreBaseActionController.startAction(
        name: 'HistoricStoreBase.set');
    try {
      return super.set(data);
    } finally {
      _$HistoricStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void add(String bookID, String id) {
    final _$actionInfo = _$HistoricStoreBaseActionController.startAction(
        name: 'HistoricStoreBase.add');
    try {
      return super.add(bookID, id);
    } finally {
      _$HistoricStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void remove(String bookID, String id) {
    final _$actionInfo = _$HistoricStoreBaseActionController.startAction(
        name: 'HistoricStoreBase.remove');
    try {
      return super.remove(bookID, id);
    } finally {
      _$HistoricStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
historic: ${historic}
    ''';
  }
}
