import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:wa_status_downloader/utils/custom_page_route.dart';
import 'package:wa_status_downloader/views/status/videos/one_screen.dart';

class AllVideosScreen extends StatelessWidget {
  const AllVideosScreen({super.key});

  Future<List<Map<String, String>>> getFiles() async {
    var status = await Permission.storage.request();
    await Permission.manageExternalStorage.request();

    try {
      final Directory tempDir = await getTemporaryDirectory();
      final String tempPath = tempDir.path;

      if (await tempDir.exists()) {
        // Supprime tous les fichiers dans le répertoire temporaire
        tempDir.listSync().forEach((file) {
          if (file is File) {
            file.deleteSync();
          }
        });
      }

      // Chemin vers le dossier des statuts
      Directory statusDir = Directory(
          '/storage/emulated/0/Android/media/com.whatsapp.w4b/WhatsApp Business/Media/.Statuses');

      if (await statusDir.exists()) {
        List<Map<String, String>> files = [];

        // Parcours des fichiers du dernier au premier
        for (var file in statusDir.listSync().reversed) {
          if (file.path.endsWith(".mp4")) {
            var filePath = await VideoThumbnail.thumbnailFile(
              video: file.path,
              imageFormat: ImageFormat.PNG,
              thumbnailPath: tempPath,
              maxWidth: 128,
              quality: 100,
            );

            // Ajoute un map avec le chemin du fichier et celui de la vignette
            if (filePath != null) {
              files.add({
                'filePath': file.path,
                'thumbnailPath': filePath,
              });
            }
          }
        }
        return files; // retourne la liste des fichiers
      } else {
        return [];
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, String>>>(
      future: getFiles(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          print(snapshot.error.toString());
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
                            .push(customPageRoute(OneVideoScreen(
                          path: e['filePath']!,
                        )));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white70,
                            borderRadius: BorderRadius.circular(8)),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(
                              8), // Appliquer le border radius à l'image
                          child: Stack(children: [
                            Positioned(
                              top: 0,
                              left: 0,
                              right: 0,
                              bottom: 0,
                              child: Image.file(
                                File(e['thumbnailPath']!),
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                                top: 0,
                                left: 0,
                                right: 0,
                                bottom: 0,
                                child: Container(
                                  color: Colors.black12,
                                  child: const Icon(
                                    Icons.play_circle,
                                    color: Colors.white,
                                    size: 40,
                                  ),
                                ))
                          ]),
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
