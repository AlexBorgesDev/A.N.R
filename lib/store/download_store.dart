import 'package:A.N.R/models/chapter.dart';
import 'package:mobx/mobx.dart';

part 'download_store.g.dart';

class DownloadStore = DownloadStoreBase with _$DownloadStore;

abstract class DownloadStoreBase with Store {
  @observable
  ObservableMap<String, String> downloading = ObservableMap();

  @observable
  ObservableList<Chapter> downloaded = ObservableList();

  @action
  void add(Chapter chapter) => downloaded.add(chapter);

  @action
  addDownloading(String bookId, String? cap) {
    final String capType = cap ?? 'all';

    downloading.update(
      bookId,
      (value) => '$value,$capType',
      ifAbsent: () => capType,
    );
  }

  @action
  removeDownloading(String bookId) => downloading.remove(bookId);
}
