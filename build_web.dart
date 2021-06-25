import 'dart:io';

main(List<String> args) {
  Process.runSync('flutter', ['build', 'web']);
  String indexHtml = File('build/web/index.html').readAsStringSync();
  indexHtml = indexHtml.replaceAll(
    '"main.dart.js"',
    '"https://cdn.jsdelivr.net/gh/svga/lizi-site@master/build/web/main.dart.js"',
  );
  File('build/web/index.html').writeAsStringSync(indexHtml);
  String mainDartJs = File('build/web/main.dart.js').readAsStringSync();
  mainDartJs = mainDartJs.replaceAll(
    '"assets/"+a',
    '"https://cdn.jsdelivr.net/gh/svga/lizi-site@master/build/web/assets/"+a',
  );
  File('build/web/main.dart.js').writeAsStringSync(mainDartJs);
}
