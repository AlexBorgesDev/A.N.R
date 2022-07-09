import 'package:A.N.R/constants/providers.dart';
import 'package:A.N.R/models/book_item.dart';
import 'package:A.N.R/services/scans/cronos_services.dart';
import 'package:A.N.R/services/scans/manga_host_services.dart';
import 'package:A.N.R/services/scans/mark_services.dart';
import 'package:A.N.R/services/scans/neox_services.dart';
import 'package:A.N.R/services/scans/prisma_services.dart';
import 'package:A.N.R/services/scans/random_services.dart';
import 'package:A.N.R/services/scans/reaper_services.dart';

Future<List<BookItem>> search(String value, Providers provider) async {
  List<BookItem> results = [];

  if (provider == Providers.NEOX) {
    results = await NeoxServices.search(value);
  } else if (provider == Providers.RANDOM) {
    results = await RandomServices.search(value);
  } else if (provider == Providers.MARK) {
    results = await MarkServices.search(value);
  } else if (provider == Providers.CRONOS) {
    results = await CronosServices.search(value);
  } else if (provider == Providers.PRISMA) {
    results = await PrismaServices.search(value);
  } else if (provider == Providers.REAPER) {
    results = await ReaperServices.search(value);
  } else if (provider == Providers.MANGA_HOST) {
    results = await MangaHostServices.search(value);
  }

  return results;
}
