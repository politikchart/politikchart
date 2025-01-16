// ignore: avoid_web_libraries_in_flutter
import 'dart:js' as js;

void openLink(String url, {bool newTab = true}) {
  js.context.callMethod('open', ['https://github.com/politikchart/politikchart', newTab ? '_blank' : '_self']);
}
