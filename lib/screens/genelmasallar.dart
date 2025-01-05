import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class GenelMasallar extends StatefulWidget {
  final String title;
  final String content;
  final String? imageUrl;

  const GenelMasallar({
    Key? key,
    required this.title,
    required this.content,
    this.imageUrl,
  }) : super(key: key);

  @override
  _GenelMasallarState createState() => _GenelMasallarState();
}

class _GenelMasallarState extends State<GenelMasallar> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  bool _isVideoInitialized = false;

  @override
  void initState() {
    super.initState();
    if (widget.imageUrl != null) {
      _initializeVideo();
    }
  }

  Future<void> _initializeVideo() async {
    _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(widget.imageUrl!));
    
    try {
      await _videoPlayerController.initialize();
      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        autoPlay: false,
        looping: false,
        aspectRatio: _videoPlayerController.value.aspectRatio,
        placeholder: Center(child: CircularProgressIndicator()),
      );
      setState(() {
        _isVideoInitialized = true;
      });
    } catch (e) {
      print('Error initializing video: $e');
    }
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Color(0xFFA5C5A8),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.imageUrl != null)
              Container(
                width: double.infinity,
                height: 250,
                child: _isVideoInitialized
                    ? Chewie(controller: _chewieController!)
                    : Stack(
                        children: [
                          Center(
                            child: CircularProgressIndicator(),
                          ),
                          Center(
                            child: IconButton(
                              icon: Icon(Icons.play_circle_fill, size: 50),
                              onPressed: () {
                                if (!_isVideoInitialized) {
                                  _initializeVideo();
                                }
                              },
                            ),
                          ),
                        ],
                      ),
              ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Anahtar Kelimeler:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black54,
                    ),
                  ),
                  SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: widget.content.split(', ').map((keyword) => Chip(
                      label: Text(
                        keyword,
                        style: TextStyle(color: Colors.black87),
                      ),
                      backgroundColor: Color(0xFFA5C5A8).withOpacity(0.3),
                    )).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Implement favorite functionality
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Favorilere eklendi'),
              duration: Duration(seconds: 2),
            ),
          );
        },
        child: Icon(Icons.favorite_border),
        backgroundColor: Color(0xFFA5C5A8),
      ),
    );
  }
}