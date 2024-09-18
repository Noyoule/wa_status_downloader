import 'dart:io';

import 'package:flutter/material.dart';
import 'package:wa_status_downloader/utils/custom_page_route.dart';
import 'package:wa_status_downloader/views/status/status_image_screen.dart';

class StatusImagesScreen extends StatelessWidget {
  const StatusImagesScreen({super.key});

  Future<List<FileSystemEntity>> getFiles() async {
    // Chemin vers le dossier des statuts
    Directory statusDir = Directory(
        '/storage/emulated/0/Android/media/com.whatsapp.w4b/WhatsApp Business/Media/.Statuses');
    if (await statusDir.exists()) {
      List<FileSystemEntity> files = [];
      for (var file in await statusDir.listSync()) {
        if (file.path.endsWith(".jpg")) {
          files.add(file);
        }
      }
      return files;
      /*for (var file in files) {
        if (file is File) {
          // Copier chaque fichier de statut dans un autre dossier
          Directory? appDocDir = await getExternalStorageDirectory();
          String newPath = '${appDocDir!.path}/${file.uri.pathSegments.last}';
          await file.copy(newPath);
        }
      }*/
    } else {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<FileSystemEntity>>(
      future: getFiles(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Scaffold(
            body: Padding(
                padding: EdgeInsets.all(10),
                child: Center(
                    child: Text(
                  'Une erreur est survenue',
                  textAlign: TextAlign.center,
                ))),
          );
        } else {
          return GridView.count(
            scrollDirection: Axis.vertical,
            crossAxisCount: 3,
            crossAxisSpacing: 3.0,
            mainAxisSpacing: 3.0,
            padding: const EdgeInsets.all(3.0),
            children: snapshot.data!
                .map((e) => InkWell(
                      onTap: () {
                        Navigator.of(context)
                            .push(customPageRoute(StatusImageScreen(
                          path: e.path,
                        )));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white70,
                            borderRadius: BorderRadius.circular(8)),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(
                              8), // Appliquer le border radius à l'image
                          child: Image.file(
                            File(e.path),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ))
                .toList(),
          );
        }
      },
    );
  }
}
