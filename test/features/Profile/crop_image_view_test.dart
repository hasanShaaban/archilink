import 'dart:async';
import 'dart:io';

import 'package:archilink/core/error/failure.dart';
import 'package:archilink/features/Profile/domain/repo/profile_repo.dart';
import 'package:archilink/features/Profile/presentation/manager/cubit/profile_cubit.dart';
import 'package:archilink/features/Profile/presentation/views/crop_image_view.dart';
import 'package:dartz/dartz.dart' hide State;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

class FakeProfileRepo implements ProfileRepo {
  File? lastProfilePictureFile;
  File? lastStoreLogoFile;
  File? lastStoreBannerFile;

  Either<Failure, bool> updateProfilePictureResult = const Right(true);
  Either<Failure, bool> updateStoreLogoResult = const Right(true);
  Either<Failure, bool> updateStoreBannerResult = const Right(true);

  Completer<Either<Failure, bool>>? delayedCompleter;

  @override
  Future<Either<Failure, bool>> updateProfilePicture(File imageFile) async {
    lastProfilePictureFile = imageFile;
    if (delayedCompleter != null) return delayedCompleter!.future;
    return updateProfilePictureResult;
  }

  @override
  Future<Either<Failure, bool>> updateStoreLogo(File imageFile) async {
    lastStoreLogoFile = imageFile;
    if (delayedCompleter != null) return delayedCompleter!.future;
    return updateStoreLogoResult;
  }

  @override
  Future<Either<Failure, bool>> updateStoreBanner(File imageFile) async {
    lastStoreBannerFile = imageFile;
    if (delayedCompleter != null) return delayedCompleter!.future;
    return updateStoreBannerResult;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakeProfileCubit extends ProfileCubit {
  FakeProfileCubit(super.profileRepo);

  bool calledPersonalProfile = false;

  @override
  Future<void> getPersonlProfile() async {
    calledPersonalProfile = true;
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

    testWidgets('tapping confirm button triggers onConfirm callback with image file if provided', (tester) async {
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

    testWidgets('calls updateProfilePicture for student/mentor, shows success and refreshes profile', (tester) async {
      tester.view.physicalSize = const Size(1080, 1920);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final fakeRepo = FakeProfileRepo();
      final fakeCubit = FakeProfileCubit(fakeRepo);

      await tester.pumpWidget(
        BlocProvider<ProfileCubit>.value(
          value: fakeCubit,
          child: MaterialApp(
            home: Builder(
              builder: (context) => Scaffold(
                body: TextButton(
                  onPressed: () async {
                    final updated = await Navigator.of(context).push<bool>(
                      MaterialPageRoute(
                        builder: (_) => CropImageView(
                          imageFile: dummyFile,
                          cropType: CropImageType.profileImage,
                          isStore: false,
                          profileRepo: fakeRepo,
                        ),
                      ),
                    );
                    if (updated == true && context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Profile picture updated successfully'),
                        ),
                      );
                    }
                  },
                  child: const Text('Open Cropper'),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open Cropper'));
      await tester.pumpAndSettle();

      expect(find.text('Confirm Profile Picture'), findsOneWidget);

      await tester.tap(find.text('Confirm Profile Picture'));
      await tester.pumpAndSettle();

      expect(fakeRepo.lastProfilePictureFile?.path, dummyFile.path);
      expect(fakeCubit.calledPersonalProfile, isTrue);
      expect(find.text('Open Cropper'), findsOneWidget);
      expect(find.text('Profile picture updated successfully'), findsOneWidget);
    });

    testWidgets('calls updateStoreLogo for store profile picture, shows success and refreshes store profile', (tester) async {
      tester.view.physicalSize = const Size(1080, 1920);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final fakeRepo = FakeProfileRepo();
      final fakeCubit = FakeProfileCubit(fakeRepo);

      await tester.pumpWidget(
        BlocProvider<ProfileCubit>.value(
          value: fakeCubit,
          child: MaterialApp(
            home: Builder(
              builder: (context) => Scaffold(
                body: TextButton(
                  onPressed: () async {
                    final updated = await Navigator.of(context).push<bool>(
                      MaterialPageRoute(
                        builder: (_) => CropImageView(
                          imageFile: dummyFile,
                          cropType: CropImageType.profileImage,
                          isStore: true,
                          profileRepo: fakeRepo,
                        ),
                      ),
                    );
                    if (updated == true && context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Store logo updated successfully'),
                        ),
                      );
                    }
                  },
                  child: const Text('Open Cropper'),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open Cropper'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Confirm Profile Picture'));
      await tester.pumpAndSettle();

      expect(fakeRepo.lastStoreLogoFile?.path, dummyFile.path);
      expect(fakeCubit.calledPersonalProfile, isTrue);
      expect(find.text('Open Cropper'), findsOneWidget);
      expect(find.text('Store logo updated successfully'), findsOneWidget);
    });

    testWidgets('calls updateStoreBanner for store banner, shows success', (tester) async {
      tester.view.physicalSize = const Size(1080, 1920);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final fakeRepo = FakeProfileRepo();
      final fakeCubit = FakeProfileCubit(fakeRepo);

      await tester.pumpWidget(
        BlocProvider<ProfileCubit>.value(
          value: fakeCubit,
          child: MaterialApp(
            home: Builder(
              builder: (context) => Scaffold(
                body: TextButton(
                  onPressed: () async {
                    final updated = await Navigator.of(context).push<bool>(
                      MaterialPageRoute(
                        builder: (_) => CropImageView(
                          imageFile: dummyFile,
                          cropType: CropImageType.bannerImage,
                          isStore: true,
                          profileRepo: fakeRepo,
                        ),
                      ),
                    );
                    if (updated == true && context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Store banner image updated successfully'),
                        ),
                      );
                    }
                  },
                  child: const Text('Open Cropper'),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open Cropper'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Confirm Banner Image'));
      await tester.pumpAndSettle();

      expect(fakeRepo.lastStoreBannerFile?.path, dummyFile.path);
      expect(fakeCubit.calledPersonalProfile, isTrue);
      expect(find.text('Store banner image updated successfully'), findsOneWidget);
    });

    testWidgets('displays loading spinner inside confirm button during upload', (tester) async {
      tester.view.physicalSize = const Size(1080, 1920);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final fakeRepo = FakeProfileRepo();
      final completer = Completer<Either<Failure, bool>>();
      fakeRepo.delayedCompleter = completer;

      await tester.pumpWidget(
        MaterialApp(
          home: CropImageView(
            imageFile: dummyFile,
            cropType: CropImageType.profileImage,
            profileRepo: fakeRepo,
          ),
        ),
      );

      await tester.tap(find.text('Confirm Profile Picture'));
      await tester.pump(); // frame where upload started

      // Progress indicator should be visible inside confirm button
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Confirm Profile Picture'), findsNothing);

      // Complete upload
      completer.complete(const Right(true));
      await tester.pumpAndSettle();
    });

    testWidgets('displays error in appSnackBar when upload fails', (tester) async {
      tester.view.physicalSize = const Size(1080, 1920);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final fakeRepo = FakeProfileRepo();
      fakeRepo.updateProfilePictureResult = const Left(
        ServerFailure(message: 'Failed to update profile picture'),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: CropImageView(
            imageFile: dummyFile,
            cropType: CropImageType.profileImage,
            profileRepo: fakeRepo,
          ),
        ),
      );

      await tester.tap(find.text('Confirm Profile Picture'));
      await tester.pumpAndSettle();

      // View should still be open
      expect(find.text('Edit Profile Picture'), findsOneWidget);
      // SnackBar with error message
      expect(find.text('Failed to update profile picture'), findsOneWidget);
    });

    testWidgets('triggers cropImage if file exceeds 2MB and user confirms without cropping', (tester) async {
      tester.view.physicalSize = const Size(1080, 1920);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final tempDir = Directory.systemTemp.createTempSync('large_crop_test');
      final largeFile = File('${tempDir.path}/large_image.jpg')..createSync();
      largeFile.writeAsBytesSync(List.filled(2500000, 42));
      addTearDown(() {
        try {
          if (largeFile.existsSync()) largeFile.deleteSync();
        } catch (_) {}
      });

      final fakeCropper = FakeImageCropper(
        croppedResult: CroppedFile(dummyCroppedFile.path),
      );
      final fakeRepo = FakeProfileRepo();

      await tester.pumpWidget(
        MaterialApp(
          home: CropImageView(
            imageFile: largeFile,
            cropType: CropImageType.bannerImage,
            cropper: fakeCropper,
            profileRepo: fakeRepo,
          ),
        ),
      );

      await tester.tap(find.text('Confirm Banner Image'));
      await tester.pumpAndSettle();

      expect(fakeCropper.calledCrop, isTrue);
      expect(fakeRepo.lastStoreBannerFile?.path, dummyCroppedFile.path);
    });
  });
}
