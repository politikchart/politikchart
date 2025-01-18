import 'package:web/web.dart';

void setBrowserUrl({
  required String url,
}) {
  window.history.pushState(null, 'home', '/#$url');
}

String? getBrowserUrl() {
  final hash = window.location.hash;
  if (hash.isEmpty) {
    return null;
  }

  return hash.substring(1);
}
