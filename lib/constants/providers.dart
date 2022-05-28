enum Providers { leitor, neox }

extension ProvidersExtension on Providers {
  String get value {
    switch (this) {
      case Providers.leitor:
        return 'Leitor';

      case Providers.neox:
        return 'Neox';
    }
  }
}
