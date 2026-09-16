import 'package:archilink/features/Profile/domain/entity/profile_entity.dart';
import 'package:archilink/features/Profile/domain/entity/profile_type.dart';
import 'package:archilink/features/Profile/presentation/views/widgets/profile_details_page.dart';
import 'package:archilink/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final completeProfile = ProfileEntity(
    name: 'Sample User',
    username: 'sample_user',
    bio: 'Sample bio',
    profilePictureUrl: null,
    bannerImageUrl: null,
    isFollowing: false,
    isVerified: false,
    followersCount: 10,
    followingCount: 10,
    postsCount: 5,
    projectCount: 2,
    role: 'store',
    details: ProfileDetailsEntity(
      aboutMe: 'We build exceptional architectural software and solutions.',
      academicExperiences: const [
        AcademicExperienceEntity(
          university: 'Architecture University',
          degree: 'Bachelor',
          fieldOfStudy: 'Design',
          startYear: 2018,
          endYear: 2022,
        ),
      ],
      skills: const [
        SkillsEntity(id: 1, name: 'Revit'),
        SkillsEntity(id: 2, name: 'AutoCAD'),
      ],
      contactInfo: const [
        ContactInfoEntity(
          platform: 'Email',
          username: 'contact@archistore.com',
          url: 'mailto:contact@archistore.com',
        ),
      ],
      joinedAt: DateTime(2024, 1, 1),
    ),
  );

  Widget buildTestApp(Widget child) {
    return MaterialApp(
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      home: Scaffold(body: child),
    );
  }

  group('ProfileDetailsPage store role filtering', () {
    testWidgets('personalStoreProfile shows About Us and Contact Info, hides Academic Experience and Skills', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          ProfileDetailsPage(
            entity: completeProfile,
            type: ProfileType.personalStoreProfile,
          ),
        ),
      );

      // Verify title is "About Us" and contact info is visible
      expect(find.text('About Us'), findsOneWidget);
      expect(find.text('Contact Info'), findsOneWidget);
      expect(find.text('contact@archistore.com'), findsOneWidget);

      // Verify Academic Experience and Skills are hidden for store
      expect(find.text('Academic Experience'), findsNothing);
      expect(find.text('Skills'), findsNothing);
      expect(find.text('Revit'), findsNothing);
      expect(find.text('About me'), findsNothing);
    });

    testWidgets('storeProfile (visitor) shows About Us and Contact Info, hides Academic Experience and Skills', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          ProfileDetailsPage(
            entity: completeProfile,
            type: ProfileType.storeProfile,
          ),
        ),
      );

      expect(find.text('About Us'), findsOneWidget);
      expect(find.text('Contact Info'), findsOneWidget);
      expect(find.text('Academic Experience'), findsNothing);
      expect(find.text('Skills'), findsNothing);
      expect(find.text('About me'), findsNothing);
    });

    testWidgets('personalProfile (student) shows About me, Academic Experience, Skills, and Contact Info', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          ProfileDetailsPage(
            entity: completeProfile,
            type: ProfileType.personalProfile,
          ),
        ),
      );

      expect(find.text('About me'), findsOneWidget);
      expect(find.text('Academic Experience'), findsOneWidget);
      expect(find.text('Skills'), findsOneWidget);
      expect(find.text('Contact Info'), findsOneWidget);
      expect(find.text('Revit'), findsOneWidget);
      expect(find.text('About Us'), findsNothing);
    });

    testWidgets('shows "No details provided yet" when store has only academic and skills data', (tester) async {
      final academicOnlyProfile = ProfileEntity(
        name: 'Sample User',
        username: 'sample_user',
        bio: 'Sample bio',
        profilePictureUrl: null,
        bannerImageUrl: null,
        isFollowing: false,
        isVerified: false,
        followersCount: 10,
        followingCount: 10,
        postsCount: 5,
        projectCount: 2,
        role: 'store',
        details: ProfileDetailsEntity(
          aboutMe: null,
          academicExperiences: const [
            AcademicExperienceEntity(
              university: 'Architecture University',
              degree: 'Bachelor',
              fieldOfStudy: 'Design',
              startYear: 2018,
              endYear: 2022,
            ),
          ],
          skills: const [
            SkillsEntity(id: 1, name: 'Revit'),
          ],
          contactInfo: const [],
          joinedAt: DateTime(2024, 1, 1),
        ),
      );

      await tester.pumpWidget(
        buildTestApp(
          ProfileDetailsPage(
            entity: academicOnlyProfile,
            type: ProfileType.personalStoreProfile,
          ),
        ),
      );

      expect(find.text('No details provided yet'), findsOneWidget);
      expect(find.text('Academic Experience'), findsNothing);
      expect(find.text('Skills'), findsNothing);
    });
  });
}
