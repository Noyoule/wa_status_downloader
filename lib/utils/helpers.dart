import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:share_plus/share_plus.dart';

Future<void> shareFile(String path) async {
  try {
    await Share.shareXFiles([XFile(path)]);
  } catch (e) {
    if (kDebugMode) {
      print(e);
    }
  }
}

Future<bool> downloadFile(String path) async {
  var file = File(path);
  /*Image*/
  try {
    if (path.endsWith(".jpg")) {
      String directoryPath =
          '/storage/emulated/0/Pictures/Wa_status_downloader/';
      Directory directory = Directory(directoryPath);
      /*Create the directory if it not exist*/
      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }
      var newFile =
          await file.copy('$directoryPath/${file.uri.pathSegments.last}');
      return true;
    } else if (path.endsWith(".mp4")) {
      /*Video*/
      String directoryPath = '/storage/emulated/0/Movies/wa_status_downloader';
      Directory directory = Directory(directoryPath);
      /*Create the directory if it not exist*/
      if (!await directory.exists()) {
        directory.create();
      }
      var newFile =
          await file.copy('$directoryPath/${file.uri.pathSegments.last}');
      return true;
    } else {
      return false;
    }
  } catch (e) {
    if (kDebugMode) {
      print(e);
    }
    return false;
  }
}
