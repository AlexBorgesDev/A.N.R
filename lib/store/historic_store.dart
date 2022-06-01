import 'package:mobx/mobx.dart';

part 'historic_store.g.dart';

class HistoricStore = HistoricStoreBase with _$HistoricStore;

abstract class HistoricStoreBase with Store {
  @observable
  ObservableMap<String, ObservableList<String>> historic = ObservableMap();

  @action
  void set(Map<String, ObservableList<String>> data) {
    historic.addAll(data);
  }

  @action
  void add(String bookID, String id) {
    ObservableList<String>? book = historic[bookID];

    if (book == null) {
      historic[bookID] = ObservableList();

      book = historic[bookID];
      book!.add(id);
    } else {
      book.add(id);
    }
  }

  @action
  void remove(String bookID, String id) => historic[bookID]?.remove(id);
}
