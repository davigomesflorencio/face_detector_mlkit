import 'package:face_detector_mlkit/pages/components/face_detector_view.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Face Detector'),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: FaceDetectorView());
  }
}
