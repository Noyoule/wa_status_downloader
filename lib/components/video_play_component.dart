import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayComponent extends StatefulWidget {
  final String path;
  const VideoPlayComponent({super.key, required this.path});

  @override
  State<VideoPlayComponent> createState() => _VideoPlayComponentState();
}

class _VideoPlayComponentState extends State<VideoPlayComponent>
    with SingleTickerProviderStateMixin {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;
  bool _isVisible =
      true; // Pour gérer la visibilité de l'icône de lecture/pause

  @override
  void initState() {
    super.initState();
    // Initialise le contrôleur vidéo
    _controller = VideoPlayerController.file(File(widget.path));
    _initializeVideoPlayerFuture = _controller.initialize();
    _controller.play();
    _controller.setLooping(true);
    _controller.addListener(() {
      setState(() {});
    });

    // Gérer la visibilité automatique de l'icône après un certain temps
    _controller.addListener(() {
      if (_controller.value.isPlaying && _isVisible) {
        setState(() {
          _isVisible = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
        _isVisible = true;
      } else {
        _controller.play();
        Future.delayed(const Duration(milliseconds: 700), () {
          setState(() {
            _isVisible = false;
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializeVideoPlayerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Stack(
            children: [
              GestureDetector(
                onTap: _togglePlayPause,
                child: Stack(
                  children: [
                    AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    ),
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: AnimatedOpacity(
                        opacity: _isVisible ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 300),
                        child: Center(
                          child: GestureDetector(
                            onTap: _togglePlayPause,
                            child: Icon(
                              _controller.value.isPlaying
                                  ? Icons.pause_circle_filled
                                  : Icons.play_circle_filled,
                              size: 100,
                              color: Colors.white.withOpacity(0.7),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                left: 2,
                right: 2,
                bottom: 10,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(_formatDuration(_controller.value.position),
                      style: const TextStyle(
                          color: Colors.grey
                      ),),
                    Expanded(
                      child: Slider(
                        value: _controller.value.position.inSeconds.toDouble(),
                        max: _controller.value.duration.inSeconds.toDouble(),
                        activeColor: Theme.of(context).primaryColor,
                        inactiveColor: Colors.grey,
                        onChanged: (value) {
                          setState(() {
                            _controller
                                .seekTo(Duration(seconds: value.toInt()));
                          });
                        },
                      ),
                    ),
                    Text(_formatDuration(_controller.value.duration),
                    style: const TextStyle(
                      color: Colors.grey
                    ),),
                  ],
                ),
              ),
            ],
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  // Fonction pour formater la durée en minutes:secondes
  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }
}
