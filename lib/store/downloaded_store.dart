import 'package:mobx/mobx.dart';

part 'downloaded_store.g.dart';

class DownloadedStore = DownloadedStoreBase with _$DownloadedStore;

abstract class DownloadedStoreBase with Store {
  @observable
  ObservableMap<String, dynamic> chapters = ObservableMap();

  @computed
  int get total => chapters.length;

  @action
  void add(String key) {
    chapters[key] = null;
  }

  @action
  void remove(String key) {
    chapters.remove(key);
  }

  @action
  void set(Map<String, dynamic> data) {
    chapters = ObservableMap();
    chapters.addAll(data);
  }

  @action
  void reset() {
    chapters = ObservableMap();
  }
}
