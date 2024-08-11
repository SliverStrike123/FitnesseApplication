import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class TrCreateWorkout extends StatefulWidget {
  const TrCreateWorkout({Key? key}) : super(key: key);

  @override
  _TrCreateWorkoutState createState() => _TrCreateWorkoutState();
}

class _TrCreateWorkoutState extends State<TrCreateWorkout> {
  File? _videoFile;
  VideoPlayerController? _videoPlayerController;
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _setsController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickVideo() async {
    final pickedFile = await _picker.pickVideo(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _videoFile = File(pickedFile.path);
        _videoPlayerController = VideoPlayerController.file(_videoFile!)
          ..initialize().then((_) {
            setState(() {});
            _videoPlayerController!.play();
          });
      } else {
        print('No video selected.');
      }
    });
  }

  Future<void> _uploadVideoAndSaveWorkout() async {
    if (_videoFile == null) return;

    try {
      // Upload video to Firebase Storage
      String fileName = 'workouts/${DateTime.now().millisecondsSinceEpoch}.mp4';
      UploadTask uploadTask = FirebaseStorage.instance
          .ref()
          .child(fileName)
          .putFile(_videoFile!);

      TaskSnapshot taskSnapshot = await uploadTask;
      String videoUrl = await taskSnapshot.ref.getDownloadURL();

      // Save workout details to Firestore
      await FirebaseFirestore.instance.collection('workouts').add({
        'title': _titleController.text,
        'description': _descriptionController.text,
        'sets': _setsController.text,
        'videoUrl': videoUrl,
        'createdAt': Timestamp.now(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Workout saved successfully!')),
      );

      // Clear the form
      _titleController.clear();
      _descriptionController.clear();
      _setsController.clear();
      setState(() {
        _videoFile = null;
        _videoPlayerController = null;
      });
    } catch (e) {
      print('Error uploading video and saving workout: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving workout: $e')),
      );
    }
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    _descriptionController.dispose();
    _setsController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Workout'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: _pickVideo,
              child: Text(
                _videoFile == null ? 'Pick a Video' : 'Video Selected',
                style: TextStyle(color: Colors.black),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[300], // Button color
              ),
            ),
            SizedBox(height: 16),
            if (_videoFile != null && _videoPlayerController != null)
              AspectRatio(
                aspectRatio: _videoPlayerController!.value.aspectRatio,
                child: VideoPlayer(_videoPlayerController!),
              ),
            SizedBox(height: 16),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Workout Title',
                labelStyle: TextStyle(color: Colors.black),
                border: OutlineInputBorder(),
              ),
              style: TextStyle(color: Colors.black),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
                labelStyle: TextStyle(color: Colors.black),
                border: OutlineInputBorder(),
              ),
              style: TextStyle(color: Colors.black),
              maxLines: 3,
            ),
            SizedBox(height: 16),
            TextField(
              controller: _setsController,
              decoration: InputDecoration(
                labelText: 'Suggested Sets',
                labelStyle: TextStyle(color: Colors.black),
                border: OutlineInputBorder(),
              ),
              style: TextStyle(color: Colors.black),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _uploadVideoAndSaveWorkout,
              child: Text(
                'Save Workout',
                style: TextStyle(color: Colors.black),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[300], // Button color
              ),
            ),
          ],
        ),
      ),
    );
  }
}
