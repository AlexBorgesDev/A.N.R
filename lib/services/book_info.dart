import 'package:A.N.R/models/book.dart';
import 'package:A.N.R/services/scans/cronos_services.dart';
import 'package:A.N.R/services/scans/manga_host_services.dart';
import 'package:A.N.R/services/scans/mark_services.dart';
import 'package:A.N.R/services/scans/neox_services.dart';
import 'package:A.N.R/services/scans/prisma_services.dart';
import 'package:A.N.R/services/scans/random_services.dart';
import 'package:A.N.R/services/scans/reaper_services.dart';

Future<Book?> bookInfo(String url, String name) async {
  if (url.contains('neoxscans')) {
    return await NeoxServices.bookInfo(url, name);
  } else if (url.contains('randomscan')) {
    return await RandomServices.bookInfo(url, name);
  } else if (url.contains('markscans')) {
    return await MarkServices.bookInfo(url, name);
  } else if (url.contains('cronosscan')) {
    return await CronosServices.bookInfo(url, name);
  } else if (url.contains('prismascans')) {
    return await PrismaServices.bookInfo(url, name);
  } else if (url.contains('reaperscans')) {
    return await ReaperServices.bookInfo(url, name);
  } else if (url.contains('mangahosted') || url.contains('mangahost4')) {
    return await MangaHostServices.bookInfo(url, name);
  }

  return null;
}
