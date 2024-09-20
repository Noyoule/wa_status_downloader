import 'package:flutter/material.dart';
import 'package:wa_status_downloader/views/status/images/all_screen.dart';
import 'package:wa_status_downloader/views/status/videos/all_screen.dart';

class StatusMainScreen extends StatelessWidget {
  const StatusMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: const Text(
              'Whatsapp business',
              style: TextStyle(fontSize: 15, color: Colors.black54),
            ),
            bottom: const TabBar(
              tabs: [
                Tab(text: 'Images'),
                Tab(text: 'Vidéo'),
                Tab(text: 'Audio'),
              ],
            ),
          ),
          body: const TabBarView(
            children: [
              AllImagesScreen(),
              AllVideosScreen(),
              Center(child: Text('Audio')),
            ],
          ),
        ));
  }
}
