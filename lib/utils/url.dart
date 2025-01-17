// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

void setBrowserUrl({
  required String url,
}) {
  html.window.history.pushState(null, 'home', '/#$url');
}

String? getBrowserUrl() {
  final hash = html.window.location.hash;
  if (hash.isEmpty) {
    return null;
  }

  return hash.substring(1);
}
