// ignore: constant_identifier_names
enum Providers { NEOX, RANDOM, MARK, MANGA_HOST }

extension ProvidersExtension on Providers {
  String get value {
    switch (this) {
      case Providers.NEOX:
        return 'Neox';

      case Providers.RANDOM:
        return 'Random';

      case Providers.MARK:
        return 'Mark';

      case Providers.MANGA_HOST:
        return 'Manga Host';

      // case Providers.WAR_QUEEN:
      //   return 'War Queen';
    }
  }
}
