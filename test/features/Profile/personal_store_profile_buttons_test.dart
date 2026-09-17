import 'package:archilink/features/Edit_Profile/presentation/view/edit_profile_view.dart';
import 'package:archilink/features/Profile/domain/entity/profile_entity.dart';
import 'package:archilink/features/Profile/presentation/views/widgets/personal_store_profile_buttons.dart';
import 'package:archilink/features/Profile/presentation/views/widgets/profile_statistics_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final fakeProfileData = ProfileEntity(
    name: 'Arch Store',
    username: 'arch_store',
    bio: 'Store bio',
    profilePictureUrl: null,
    bannerImageUrl: null,
    isFollowing: false,
    isVerified: true,
    followersCount: 150,
    followingCount: 20,
    postsCount: 12,
    projectCount: 0,
    role: 'store',
    details: ProfileDetailsEntity(
      aboutMe: 'About our store',
      academicExperiences: const [],
      contactInfo: const [],
      skills: const [],
      joinedAt: DateTime(2024, 1, 1),
    ),
  );

  group('PersonalStoreProfileButtons', () {
    testWidgets('renders Add Product, Edit Profile, and Share buttons', (tester) async {
      String? pushedRouteName;

      await tester.pumpWidget(
        MaterialApp(
          onGenerateRoute: (settings) {
            pushedRouteName = settings.name;
            return MaterialPageRoute(builder: (_) => const Scaffold());
          },
          home: Scaffold(
            body: PersonalStoreProfileButtons(
              width: 400,
              profileData: fakeProfileData,
            ),
          ),
        ),
      );

      expect(find.text('Add Product'), findsOneWidget);
      expect(find.text('Edit Profile'), findsOneWidget);

      // Tapping Add Product triggers navigation to AddEditProductView
      await tester.tap(find.text('Add Product'));
      await tester.pumpAndSettle();
      expect(pushedRouteName, '/addEditProduct');
    });

    testWidgets('Edit Profile triggers navigation with profileData', (tester) async {
      String? pushedRouteName;
      dynamic pushedArguments;

      await tester.pumpWidget(
        MaterialApp(
          onGenerateRoute: (settings) {
            pushedRouteName = settings.name;
            pushedArguments = settings.arguments;
            return MaterialPageRoute(builder: (_) => const Scaffold());
          },
          home: Scaffold(
            body: PersonalStoreProfileButtons(
              width: 400,
              profileData: fakeProfileData,
            ),
          ),
        ),
      );

      await tester.tap(find.text('Edit Profile'));
      await tester.pumpAndSettle();

      expect(pushedRouteName, EditProfileView.name);
      expect(pushedArguments, isA<Map<String, dynamic>>());
      expect((pushedArguments as Map<String, dynamic>)['profileData'], fakeProfileData);
      expect((pushedArguments as Map<String, dynamic>)['isStore'], true);
    });
  });

  group('ProfileStatisticsRow', () {
    testWidgets('renders only Products and Followers when isStore is true', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ProfileStatisticsRow(
              followers: 100,
              following: 50,
              posts: 12,
              projects: 5,
              isStore: true,
            ),
          ),
        ),
      );

      expect(find.text('Products'), findsOneWidget);
      expect(find.text('Followers'), findsOneWidget);
      expect(find.text('12'), findsOneWidget);
      expect(find.text('100'), findsOneWidget);

      // Non-store stats should NOT be rendered
      expect(find.text('Posts'), findsNothing);
      expect(find.text('Projects'), findsNothing);
      expect(find.text('Following'), findsNothing);
    });

    testWidgets('renders all 4 statistics when isStore is false', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ProfileStatisticsRow(
              followers: 100,
              following: 50,
              posts: 12,
              projects: 5,
              isStore: false,
            ),
          ),
        ),
      );

      expect(find.text('Posts'), findsOneWidget);
      expect(find.text('Projects'), findsOneWidget);
      expect(find.text('Followers'), findsOneWidget);
      expect(find.text('Following'), findsOneWidget);
    });
  });
}
