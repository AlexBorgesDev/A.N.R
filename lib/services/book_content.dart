import 'package:A.N.R/services/scans/cronos_services.dart';
import 'package:A.N.R/services/scans/manga_host_services.dart';
import 'package:A.N.R/services/scans/mark_services.dart';
import 'package:A.N.R/services/scans/neox_services.dart';
import 'package:A.N.R/services/scans/prisma_services.dart';
import 'package:A.N.R/services/scans/random_services.dart';
import 'package:A.N.R/services/scans/reaper_services.dart';

Future<List<String>> bookContent(String url) async {
  if (url.contains('neoxscans')) {
    return NeoxServices.getContent(url);
  } else if (url.contains('randomscan')) {
    return RandomServices.getContent(url);
  } else if (url.contains('markscans')) {
    return MarkServices.getContent(url);
  } else if (url.contains('cronosscan')) {
    return await CronosServices.getContent(url);
  } else if (url.contains('prismascans')) {
    return await PrismaServices.getContent(url);
  } else if (url.contains('reaperscans')) {
    return await ReaperServices.getContent(url);
  } else if (url.contains('mangahosted') || url.contains('mangahost4')) {
    return MangaHostServices.getContent(url);
  }

  return [];
}
