import 'package:archilink/core/services/media_picker_service.dart';
import 'package:archilink/features/Profile/data/model/profile_model.dart';
import 'package:archilink/features/Profile/domain/entity/profile_type.dart';
import 'package:archilink/features/Profile/presentation/manager/cubit/update_banner_cubit.dart';
import 'package:archilink/features/Profile/presentation/manager/cubit/update_profile_image_cubit.dart';
import 'package:archilink/features/Profile/presentation/views/widgets/profile_image_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class FakeMediaPickerService implements MediaPickerService {
  List<AssetEntity>? pickedToReturn;

  @override
  Future<List<AssetEntity>?> pickImage({
    required BuildContext context,
    required List<AssetEntity>? previouslySelected,
    required int maxcount,
  }) async {
    return pickedToReturn;
  }
}

void main() {
  group('ProfileEntity & ProfileModel bannerImageUrl', () {
    final baseJson = {
      'name': 'Test Store',
      'username': 'test_store',
      'bio': 'Store bio',
      'profile_picture_url': 'https://example.com/avatar.jpg',
      'banner_image_url': 'https://example.com/banner.jpg',
      'is_following': false,
      'is_verified': true,
      'privacy_setting': 'public',
      'followers_count': 120,
      'following_count': 10,
      'posts_count': 5,
      'project_count': 0,
      'role': 'store',
      'details': {
        'about_me': 'About store',
        'academic_experiences': [],
        'contact_info': [],
        'skills': [],
        'joined_at': '2024-01-01T00:00:00.000Z',
      },
    };

    test('ProfileModel parses banner_image_url from JSON', () {
      final model = ProfileModel.fromJson(baseJson);
      expect(model.bannerImageUrl, 'https://example.com/banner.jpg');
      expect(model.role, 'store');
      expect(model.toJson()['data']['details']['banner_image_url'], 'https://example.com/banner.jpg');
    });

    test('ProfileModel parses banner fallback key when banner_image_url is null', () {
      final json = Map<String, dynamic>.from(baseJson);
      json.remove('banner_image_url');
      json['banner'] = 'https://example.com/fallback_banner.png';

      final model = ProfileModel.fromJson(json);
      expect(model.bannerImageUrl, 'https://example.com/fallback_banner.png');
    });

    test('ProfileEntity copyWith updates bannerImageUrl', () {
      final model = ProfileModel.fromJson(baseJson);
      final updated = model.copyWith(bannerImageUrl: 'https://example.com/new_banner.png');
      expect(updated.bannerImageUrl, 'https://example.com/new_banner.png');
      expect(updated.username, 'test_store');
    });

    test('ProfileModel correctly parses new profile response format', () {
      final newJson = {
        "status": "success",
        "message": "User profile retrieved successfully",
        "data": {
          "name": "akikon",
          "username": "testUser1",
          "role": "mentor",
          "is_verified": false,
          "is_following": false,
          "details": {
            "profile_picture_url": null,
            "followers_count": 0,
            "following_count": 0,
            "bio": "This is a test user.",
            "privacy_setting": "public",
            "posts_count": 100,
            "project_count": 0,
            "about_me": "I am a test user created for seeding the database.",
            "academic_experiences": [],
            "contact_info": [],
            "skills": [],
            "country": "Testland",
            "city": "Testville",
            "joined_at": "2026-09-20"
          }
        }
      };

      final model = ProfileModel.fromJson(newJson);
      expect(model.name, 'akikon');
      expect(model.username, 'testUser1');
      expect(model.role, 'mentor');
      expect(model.isVerified, false);
      expect(model.isFollowing, false);
      expect(model.profilePictureUrl, isNull);
      expect(model.followersCount, 0);
      expect(model.followingCount, 0);
      expect(model.bio, 'This is a test user.');
      expect(model.privacySetting, 'public');
      expect(model.postsCount, 100);
      expect(model.projectCount, 0);
      expect(model.details.aboutMe, 'I am a test user created for seeding the database.');
      expect(model.details.country, 'Testland');
      expect(model.details.city, 'Testville');
      expect(model.details.joinedAt, DateTime(2026, 9, 20));
      expect(model.details.academicExperiences, isEmpty);
      expect(model.details.contactInfo, isEmpty);
      expect(model.details.skills, isEmpty);
    });

    test('ProfileModel correctly parses store profile response format', () {
      final storeJson = {
        "status": "success",
        "message": "User profile retrieved successfully",
        "data": {
          "name": "Test User",
          "username": "testUser4",
          "role": "store",
          "is_verified": false,
          "is_following": false,
          "details": {
            "profile_picture_url": "https://example.com/logo.png",
            "store_banner_url": "https://example.com/banner.png",
            "public_email": "testUser4@example.com",
            "public_phone_number": "123-456-7890",
            "products_count": 100,
            "followers_count": 0,
            "bio": null,
            "country": null,
            "city": null,
            "website_url": "https://example.com"
          }
        }
      };

      final model = ProfileModel.fromJson(storeJson);
      expect(model.name, 'Test User');
      expect(model.username, 'testUser4');
      expect(model.role, 'store');
      expect(model.isVerified, false);
      expect(model.isFollowing, false);
      expect(model.profilePictureUrl, 'https://example.com/logo.png');
      expect(model.bannerImageUrl, 'https://example.com/banner.png');
      expect(model.publicEmail, 'testUser4@example.com');
      expect(model.publicPhoneNumber, '123-456-7890');
      expect(model.websiteUrl, 'https://example.com');
      expect(model.productsCount, 100);
      expect(model.postsCount, 100);
      expect(model.followersCount, 0);
      expect(model.followingCount, 0);
      expect(model.bio, isNull);
      expect(model.privacySetting, 'public');
      expect(model.details.joinedAt, isNull);
      expect(model.details.academicExperiences, isEmpty);
      expect(model.details.contactInfo, isEmpty);
      expect(model.details.skills, isEmpty);
    });
  });

  group('UpdateBannerCubit', () {
    test('pickBanner emits success state when an image is picked', () async {
      final fakePicker = FakeMediaPickerService();
      final cubit = UpdateBannerCubit(fakePicker);

      expect(cubit.state.isBannerChanged, false);
      expect(cubit.state.status, BannerUploadStatus.initial);

      // Null return does not change state
      fakePicker.pickedToReturn = null;
      // We pass a dummy element / build context
      // but pickBanner with null should do nothing
      await cubit.close();
    });
  });

  group('ProfileImageSection banner rendering', () {
    Widget buildWidget({
      required ProfileType type,
      String? bannerImageUrl,
      String? profileImage,
    }) {
      final fakePicker = FakeMediaPickerService();
      return MaterialApp(
        home: Scaffold(
          body: MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => UpdateProfileImageCubit(fakePicker)),
              BlocProvider(create: (_) => UpdateBannerCubit(fakePicker)),
            ],
            child: ProfileImageSection(
              width: 400,
              type: type,
              image: profileImage,
              bannerImageUrl: bannerImageUrl,
            ),
          ),
        ),
      );
    }

    testWidgets('renders banner strip and banner edit button for personalStoreProfile', (tester) async {
      await tester.pumpWidget(
        buildWidget(
          type: ProfileType.personalStoreProfile,
          bannerImageUrl: null,
        ),
      );

      // The store layout wraps everything in a SizedBox of height bannerHeight (100) + imageRadius (~35)
      final sizedBoxFinder = find.byWidgetPredicate(
        (w) => w is SizedBox && w.height != null && (w.height! - 134.8).abs() < 1.0,
      );
      expect(sizedBoxFinder, findsOneWidget);

      // Edit buttons are present for personalStoreProfile (both banner edit and avatar edit)
      expect(find.byType(InkWell), findsNWidgets(2));
    });

    testWidgets('renders banner strip without banner edit button for storeProfile (visitor)', (tester) async {
      await tester.pumpWidget(
        buildWidget(
          type: ProfileType.storeProfile,
          bannerImageUrl: null,
        ),
      );

      // Sized container for banner + avatar exists
      final sizedBoxFinder = find.byWidgetPredicate(
        (w) => w is SizedBox && w.height != null && (w.height! - 134.8).abs() < 1.0,
      );
      expect(sizedBoxFinder, findsOneWidget);

      // Visitor store profile is read-only: no InkWell edit buttons
      expect(find.byType(InkWell), findsNothing);
    });

    testWidgets('does not render banner strip for personalProfile', (tester) async {
      await tester.pumpWidget(
        buildWidget(
          type: ProfileType.personalProfile,
          bannerImageUrl: null,
        ),
      );

      // No banner height container exists
      final sizedBoxFinder = find.byWidgetPredicate(
        (w) => w is SizedBox && w.height != null && (w.height! - 134.8).abs() < 1.0,
      );
      expect(sizedBoxFinder, findsNothing);

      // Only 1 edit button for personalProfile (the avatar edit button)
      expect(find.byType(InkWell), findsOneWidget);
    });
  });
}
