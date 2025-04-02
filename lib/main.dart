import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:face_detector_mlkit/pages/home_page.dart';

List<CameraDescription> cameras = [];
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  cameras = await availableCameras();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.red,
        primaryColor: Color.fromARGB(100, 3, 169, 244),
        scaffoldBackgroundColor: Colors.grey.shade200,
      ),
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}
