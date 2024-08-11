import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:video_player/video_player.dart';

class WorkoutDetails extends StatefulWidget {
  final String title;

  const WorkoutDetails({super.key, required this.title});

  @override
  WorkoutDetailsState createState() => WorkoutDetailsState();
}

class WorkoutDetailsState extends State<WorkoutDetails> {
  late Future<DocumentSnapshot> _workoutFuture;
  VideoPlayerController? _controller;

  @override
  void initState() {
    super.initState();
    _workoutFuture = FirebaseFirestore.instance
        .collection('workouts')
        .where('title', isEqualTo: widget.title)
        .limit(1)
        .get()
        .then((snapshot) => snapshot.docs.first);
         _workoutFuture.then((doc) {
      String videoUrl = doc['videoUrl'];
      _controller = VideoPlayerController.networkUrl(Uri.parse(videoUrl))
        ..initialize().then((_) {
          setState(() {}); // Ensure the widget rebuilds to show the video
          _controller?.play();
          _controller?.addListener(_onVideoStateChanged);
        }).catchError((error) {
          print('Error initializing video player: $error');
        });
    }).catchError((error) {
      print('Error fetching document: $error');
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
  void _onVideoStateChanged() {
    if (_controller!.value.position == _controller!.value.duration) {
      _controller!.seekTo(Duration.zero); // Seek to beginning
      _controller!.play(); // Play again
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Workout Details'),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: _workoutFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('Workout not found'));
          } else {
            var data = snapshot.data!;
            String title = data['title'];
            String sets = data['sets'];
            String description = data['description'];

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (_controller != null && _controller!.value.isInitialized)
                    AspectRatio(
                      aspectRatio: _controller!.value.aspectRatio,
                      child: VideoPlayer(_controller!),
                    )
                  else
                    Container(
                      height: 200, // Adjust the height as needed
                      color: Colors.grey, // Placeholder color
                      child: Center(
                        child: Text('Loading video...'),
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Suggested Sets:',
                          style: TextStyle(fontSize: 18),
                        ),
                        Text(
                          '$sets sets',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      description,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}