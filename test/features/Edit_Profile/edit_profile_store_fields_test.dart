import 'package:archilink/core/error/failure.dart';
import 'package:archilink/features/Edit_Profile/domain/entity/edit_profile_request_body.dart';
import 'package:archilink/features/Edit_Profile/domain/entity/universities_response_entity.dart';
import 'package:archilink/features/Edit_Profile/domain/repo/edit_profile_repo.dart';
import 'package:archilink/features/Edit_Profile/presentation/manager/cubit/edit_profile_cubit.dart';
import 'package:archilink/features/Edit_Profile/presentation/view/edit_profile_view.dart';
import 'package:archilink/features/Edit_Profile/presentation/view/widgets/edit_profile_account_type_button.dart';
import 'package:archilink/features/Profile/domain/entity/profile_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeEditProfileRepo implements EditProfileRepo {
  String? updatedDescription;
  String? updatedCity;
  String? updatedCountry;
  EditProfileRequestBody? updatedProfileBody;

  @override
  Future<Either<Failure, UniversitiesResponseEntity>> getUniversities() async {
    return right(
      const UniversitiesResponseEntity(
        status: 'success',
        message: 'ok',
        universities: [],
      ),
    );
  }

  @override
  Future<Either<Failure, bool>> updateProfile(EditProfileRequestBody requestBody) async {
    updatedProfileBody = requestBody;
    return right(true);
  }

  @override
  Future<Either<Failure, bool>> updateStoreProfile({
    required String description,
    required String city,
    required String country,
  }) async {
    updatedDescription = description;
    updatedCity = city;
    updatedCountry = country;
    return right(true);
  }
}

void main() {
  late FakeEditProfileRepo fakeRepo;
  late EditProfileCubit editProfileCubit;

  final storeProfile = ProfileEntity(
    name: 'Arch Store',
    username: 'arch_store',
    bio: 'Store bio description',
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
      aboutMe: 'We build architectural products',
      academicExperiences: const [],
      contactInfo: const [],
      skills: const [],
      joinedAt: DateTime(2024, 1, 1),
    ),
  );

  final studentProfile = ProfileEntity(
    name: 'John Student',
    username: 'john_student',
    bio: 'Architecture student',
    profilePictureUrl: null,
    bannerImageUrl: null,
    isFollowing: false,
    isVerified: false,
    followersCount: 50,
    followingCount: 40,
    postsCount: 5,
    projectCount: 2,
    role: 'student',
    details: ProfileDetailsEntity(
      aboutMe: 'Passionate student',
      academicExperiences: const [],
      contactInfo: const [],
      skills: const [],
      joinedAt: DateTime(2024, 1, 1),
    ),
  );

  setUp(() {
    fakeRepo = FakeEditProfileRepo();
    editProfileCubit = EditProfileCubit(fakeRepo);
  });

  tearDown(() async {
    await editProfileCubit.close();
  });

  Widget buildWidget({required ProfileEntity profileData, bool isStore = false}) {
    return MaterialApp(
      home: BlocProvider<EditProfileCubit>.value(
        value: editProfileCubit,
        child: EditProfileView(
          profileData: profileData,
          isStore: isStore,
        ),
      ),
    );
  }

  group('EditProfileView role-based field filtering', () {
    testWidgets('shows only About Us and Location for store account', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(buildWidget(profileData: storeProfile, isStore: true));
      await tester.pumpAndSettle();

      // Fields that MUST be present for store:
      expect(find.text('About Us'), findsOneWidget);
      expect(find.text('Location'), findsOneWidget);

      // Fields that MUST be hidden for store:
      expect(find.text('Full Name'), findsNothing);
      expect(find.text('Bio'), findsNothing);
      expect(find.byType(EditProfileAccountTypeButton), findsNothing);
      expect(find.text('About Me'), findsNothing);
      expect(find.text('Academic Experience'), findsNothing);
      expect(find.text('Contact Information'), findsNothing);
      expect(find.text('Skills'), findsNothing);
    });

    testWidgets('shows all fields including academic experience and skills when isStore is false', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(buildWidget(profileData: studentProfile, isStore: false));
      await tester.pumpAndSettle();

      // All fields must be visible for student:
      expect(find.text('Full Name'), findsOneWidget);
      expect(find.text('Bio'), findsOneWidget);
      expect(find.text('Location'), findsOneWidget);
      expect(find.byType(EditProfileAccountTypeButton), findsOneWidget);
      expect(find.text('About Me'), findsOneWidget);
      expect(find.text('Academic Experience'), findsOneWidget);
      expect(find.text('Contact Information'), findsOneWidget);
      expect(find.text('Skills'), findsOneWidget);
    });

    testWidgets('EditProfileCubit.saveProfile calls updateStoreProfile when isStore is true', (tester) async {
      editProfileCubit.initializeFromProfile(storeProfile, isStore: true);

      editProfileCubit.updateAboutMe('You have no idea how high i can fly.');
      editProfileCubit.updateLocation('tartous, syria');

      expect(editProfileCubit.state.hasChanges, isTrue);

      await editProfileCubit.saveProfile();

      expect(fakeRepo.updatedDescription, 'You have no idea how high i can fly.');
      expect(fakeRepo.updatedCity, 'tartous');
      expect(fakeRepo.updatedCountry, 'syria');
      expect(fakeRepo.updatedProfileBody, isNull);
    });
  });
}
