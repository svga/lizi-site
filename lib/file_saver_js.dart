import 'dart:convert';
import 'dart:typed_data';
// ignore: avoid_web_libraries_in_flutter
import 'dart:js';

class FileSaver {
  static saveFile(Uint8List data, String filename) {
    context.callMethod('saveFile', [base64.encode(data), filename]);
  }
}
