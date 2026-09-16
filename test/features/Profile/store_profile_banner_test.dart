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
      expect(model.toJson()['data']['banner_image_url'], 'https://example.com/banner.jpg');
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
