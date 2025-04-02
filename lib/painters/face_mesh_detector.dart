import 'package:face_detector_mlkit/painters/Face.dart';
import 'package:flutter/services.dart' as services;
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class FaceMeshDetector {
  static const services.MethodChannel _channel =
      services.MethodChannel('google_mlkit_face_mesh_detector');

  final id = DateTime.now().microsecondsSinceEpoch.toString();

  final FaceMeshDetectorOptions option;

  FaceMeshDetector({required this.option});

  Future<List<FaceMesh>> processImage(InputImage inputImage) async {
    final result = await _channel.invokeListMethod<dynamic>(
        'vision#startFaceMeshDetector', <String, dynamic>{
      'id': id,
      'option': option.index,
      'imageData': inputImage.toJson(),
    });

    final List<FaceMesh> meshes = <FaceMesh>[];
    for (final dynamic json in result!) {
      meshes.add(FaceMesh.fromJson(json));
    }

    return meshes;
  }

  Future<void> close() =>
      _channel.invokeMethod<void>('vision#closeFaceMeshDetector', {'id': id});
}
