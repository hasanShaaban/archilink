import 'dart:io';

import 'package:archilink/features/Profile/presentation/views/crop_image_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_cropper/image_cropper.dart';

class FakeImageCropper extends ImageCropper {
  FakeImageCropper({this.croppedResult});

  final CroppedFile? croppedResult;
  bool calledCrop = false;

  @override
  Future<CroppedFile?> cropImage({
    required String sourcePath,
    int? maxWidth,
    int? maxHeight,
    CropAspectRatio? aspectRatio,
    List<CropAspectRatioPreset> aspectRatioPresets = const [
      CropAspectRatioPreset.original,
      CropAspectRatioPreset.square,
      CropAspectRatioPreset.ratio3x2,
      CropAspectRatioPreset.ratio4x3,
      CropAspectRatioPreset.ratio16x9,
    ],
    CropStyle cropStyle = CropStyle.rectangle,
    ImageCompressFormat compressFormat = ImageCompressFormat.jpg,
    int compressQuality = 90,
    List<PlatformUiSettings>? uiSettings,
  }) async {
    calledCrop = true;
    return croppedResult;
  }
}

void main() {
  late File dummyFile;
  late File dummyCroppedFile;

  setUpAll(() {
    final tempDir = Directory.systemTemp.createTempSync('crop_test');
    dummyFile = File('${tempDir.path}/test_image.jpg')..createSync();
    dummyFile.writeAsBytesSync([0, 1, 2, 3]);

    dummyCroppedFile = File('${tempDir.path}/cropped_image.jpg')..createSync();
    dummyCroppedFile.writeAsBytesSync([4, 5, 6, 7]);
  });

  tearDownAll(() {
    try {
      if (dummyFile.existsSync()) dummyFile.deleteSync();
      if (dummyCroppedFile.existsSync()) dummyCroppedFile.deleteSync();
    } catch (_) {}
  });

  group('CropImageView', () {
    setUp(() {
      // Common setup if needed
    });

    testWidgets('renders profile picture crop view with avatar preview and confirm button', (tester) async {
      tester.view.physicalSize = const Size(1080, 1920);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        MaterialApp(
          home: CropImageView(
            imageFile: dummyFile,
            cropType: CropImageType.profileImage,
          ),
        ),
      );

      expect(find.text('Edit Profile Picture'), findsOneWidget);
      expect(find.text('Original Image'), findsOneWidget);
      expect(find.text('Crop & Resize'), findsOneWidget);
      expect(find.text('Confirm Profile Picture'), findsOneWidget);
      expect(find.text('Recommended aspect ratio: 1:1 (Square)'), findsOneWidget);
      expect(find.text('Reset'), findsNothing);
    });

    testWidgets('renders banner image crop view with banner preview and confirm button', (tester) async {
      tester.view.physicalSize = const Size(1080, 1920);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        MaterialApp(
          home: CropImageView(
            imageFile: dummyFile,
            cropType: CropImageType.bannerImage,
          ),
        ),
      );

      expect(find.text('Edit Banner Image'), findsOneWidget);
      expect(find.text('Original Image'), findsOneWidget);
      expect(find.text('Crop & Resize'), findsOneWidget);
      expect(find.text('Confirm Banner Image'), findsOneWidget);
      expect(find.text('Recommended aspect ratio: 16:9 (Banner)'), findsOneWidget);
    });

    testWidgets('crops image using cropper, updates badge and shows Reset button', (tester) async {
      tester.view.physicalSize = const Size(1080, 1920);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final fakeCropper = FakeImageCropper(
        croppedResult: CroppedFile(dummyCroppedFile.path),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: CropImageView(
            imageFile: dummyFile,
            cropType: CropImageType.profileImage,
            cropper: fakeCropper,
          ),
        ),
      );

      // Tap Crop & Resize
      await tester.tap(find.text('Crop & Resize'));
      await tester.pumpAndSettle();

      expect(fakeCropper.calledCrop, isTrue);
      expect(find.text('Cropped & Resized'), findsOneWidget);
      expect(find.text('Re-crop'), findsOneWidget);
      expect(find.text('Reset'), findsOneWidget);

      // Tap Reset
      await tester.tap(find.text('Reset'));
      await tester.pumpAndSettle();

      expect(find.text('Original Image'), findsOneWidget);
      expect(find.text('Crop & Resize'), findsOneWidget);
      expect(find.text('Reset'), findsNothing);
    });

    testWidgets('tapping confirm button triggers onConfirm callback with image file', (tester) async {
      tester.view.physicalSize = const Size(1080, 1920);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      File? confirmedFile;

      await tester.pumpWidget(
        MaterialApp(
          home: CropImageView(
            imageFile: dummyFile,
            cropType: CropImageType.profileImage,
            onConfirm: (file) => confirmedFile = file,
          ),
        ),
      );

      await tester.tap(find.text('Confirm Profile Picture'));
      await tester.pumpAndSettle();

      expect(confirmedFile, isNotNull);
      expect(confirmedFile!.path, dummyFile.path);
    });
  });
}
