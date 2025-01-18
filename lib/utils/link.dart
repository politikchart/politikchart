import 'package:web/web.dart';

void openLink(String url, {bool newTab = true}) {
  window.open(url, newTab ? '_blank' : '_self');
}
