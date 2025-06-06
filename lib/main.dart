import 'package:camera/camera.dart';
import 'package:face_detector_mlkit/pages/about/about_page.dart';
import 'package:face_detector_mlkit/pages/components/face_mesh_detector_view.dart';
import 'package:face_detector_mlkit/pages/faceMesh/face_mesh_page.dart';
import 'package:face_detector_mlkit/pages/home/home_page.dart';
import 'package:face_detector_mlkit/pages/policyprivacy/policy_privacy_page.dart';
import 'package:flutter/material.dart';

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
      initialRoute: "/",
      routes: {
        "/": (context) => SafeArea(child: HomePage()),
        "/faceMesh": (context) => SafeArea(child: FaceMeshPage()),
        "/privacy": (context) => SafeArea(child: PolicyPrivacyPage()),
        "/about": (context) => SafeArea(child: AboutPage()),
      },
    );
  }
}
