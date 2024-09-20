import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:wa_status_downloader/components/status_saved_modal.dart';
import 'package:wa_status_downloader/components/video_play_component.dart';
import 'package:wa_status_downloader/utils/helpers.dart';

class OneVideoScreen extends StatelessWidget {
  final String path;
  const OneVideoScreen({super.key, required this.path});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 55,
            child: Center(
              child: Container(
                  alignment: Alignment.center,
                  child: VideoPlayComponent(
                    path: path,
                  )),
            ),
          ),
          Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              child: Container(
                height: 55,
                decoration: const BoxDecoration(
                  color: Color(0xFFD1C4E9),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InkWell(
                      onTap: () async {
                        var status = await downloadFile(path);
                        if (status) {
                          showStatusSavedModal(context);
                        }
                      },
                      child: Container(
                        height: 45,
                        padding: const EdgeInsets.all(3),
                        decoration: const BoxDecoration(
                            color: Colors.white, shape: BoxShape.circle),
                        child: const Icon(
                          Icons.download,
                          color: Colors.blueGrey,
                          size: 35,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        await shareFile(path);
                      },
                      child: Container(
                        height: 45,
                        padding: const EdgeInsets.all(3),
                        decoration: const BoxDecoration(
                            color: Colors.white, shape: BoxShape.circle),
                        child: const Icon(
                          Icons.share,
                          color: Colors.blueGrey,
                          size: 35,
                        ),
                      ),
                    ),
                  ],
                ),
              ))
        ],
      ),
    );
  }
}
