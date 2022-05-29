import 'package:A.N.R/models/book_favorite.dart';
import 'package:mobx/mobx.dart';

part 'favorites_store.g.dart';

class FavoritesStore = FavoritesStoreBase with _$FavoritesStore;

abstract class FavoritesStoreBase with Store {
  @observable
  ObservableMap<String, BookFavorite> favorites = ObservableMap();

  @computed
  List<BookFavorite> get items => favorites.values.toList();

  @action
  void set(Map<String, BookFavorite> data) => favorites.addAll(data);

  @action
  void add(BookFavorite book) {
    favorites.update(book.id, (_) => book, ifAbsent: () => book);
  }

  @action
  void remove(String id) => favorites.remove(id);
}
