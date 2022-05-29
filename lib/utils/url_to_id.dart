String urlToId(String url) {
  return url
      .replaceAll('https://animes.vision/animes/', '')
      .replaceAll('https://', '')
      .replaceAll(RegExp(r'[.#$\[\]/]'), '_');
}
