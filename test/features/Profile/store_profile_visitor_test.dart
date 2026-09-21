import 'package:archilink/core/error/failure.dart';
import 'package:archilink/core/services/media_picker_service.dart';
import 'package:archilink/core/services/service_locator.dart';
import 'package:archilink/core/storage/local_storage.dart';
import 'package:archilink/core/utils/constants.dart';
import 'package:archilink/features/Auth/data/data_source/auth_local_data_source_impl.dart';
import 'package:archilink/features/Auth/presentation/manager/cubits/cubit/current_user_cubit.dart';
import 'package:archilink/features/Chat/domain/entity/chat_args.dart';
import 'package:archilink/features/Chat/presentation/view/app_chat_view.dart';
import 'package:archilink/features/Profile/domain/entity/follow_status.dart';
import 'package:archilink/features/Profile/domain/entity/profile_type.dart';
import 'package:archilink/features/Profile/domain/repo/profile_repo.dart';
import 'package:archilink/features/Profile/presentation/manager/bloc/profile_bloc.dart';
import 'package:archilink/features/Profile/presentation/manager/cubit/follow_cubit.dart';
import 'package:archilink/features/Profile/presentation/manager/cubit/profile_cubit.dart';
import 'package:archilink/features/Profile/presentation/views/profile_page_body.dart';
import 'package:archilink/features/Profile/presentation/views/store_profile_view.dart';
import 'package:archilink/features/Profile/presentation/views/widgets/store_profile_buttons.dart';
import 'package:archilink/features/Profile/domain/entity/profile_entity.dart';
import 'package:archilink/features/Profile/presentation/views/widgets/profile_info_section.dart';
import 'package:archilink/features/Profile/presentation/views/widgets/profile_posts_page.dart';
import 'package:archilink/features/Store/presentation/views/widgets/product_card.dart';
import 'package:archilink/features/Store/domain/entity/product_entity.dart';
import 'package:archilink/features/Store/domain/entity/product_store_entity.dart';
import 'package:archilink/features/Store/presentation/views/product_details_view.dart';
import 'package:archilink/features/Store/presentation/views/widgets/store_header_tile.dart';
import 'package:archilink/generated/l10n.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class FakeLocalStorage implements LocalStorage {
  final Map<String, dynamic> _data = {};

  @override
  Future<void> clear() async => _data.clear();
  @override
  Future<void> delete(String key) async => _data.remove(key);
  @override
  T? read<T>(String key) => _data[key] as T?;
  @override
  Future<void> write<T>(String key, T value) async => _data[key] = value;
}

class FakeMediaPickerService implements MediaPickerService {
  @override
  Future<List<AssetEntity>?> pickImage({
    required BuildContext context,
    required List<AssetEntity>? previouslySelected,
    required int maxcount,
  }) async => null;
}

class FakeProfileRepo implements ProfileRepo {
  String? followedUser;
  String? unfollowedUser;

  @override
  Future<Either<Failure, FollowStatus>> follow(String username) async {
    followedUser = username;
    return right(FollowStatus.followed);
  }

  @override
  Future<Either<Failure, bool>> unfollow(String username) async {
    unfollowedUser = username;
    return right(true);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakeProfileCubit extends Cubit<ProfileCubitState> implements ProfileCubit {
  FakeProfileCubit() : super(ProfileInitial());

  String? requestedUsername;
  bool calledGetPersonlProfile = false;

  @override
  Future<void> getUserProfile(String username) async {
    requestedUsername = username;
  }

  @override
  Future<void> getPersonlProfile() async {
    calledGetPersonlProfile = true;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakeProfileBloc extends Bloc<ProfileEvent, ProfileState> implements ProfileBloc {
  FakeProfileBloc([ProfileState? initial]) : super(initial ?? const ProfileState());

  void emitState(ProfileState newState) => emit(newState);

  @override
  ProfileRepo get repo => throw UnimplementedError();

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  late FakeProfileRepo fakeRepo;

  setUpAll(() {
    fakeRepo = FakeProfileRepo();
    if (!sl.isRegistered<FollowCubit>()) {
      sl.registerFactory<FollowCubit>(() => FollowCubit(fakeRepo));
    }
    if (!sl.isRegistered<MediaPickerService>(instanceName: kProfileImagePicker)) {
      sl.registerLazySingleton<MediaPickerService>(
        () => FakeMediaPickerService(),
        instanceName: kProfileImagePicker,
      );
    }
  });

  group('StoreProfileButtons', () {
    late FollowCubit followCubit;

    setUp(() {
      followCubit = FollowCubit(fakeRepo);
    });

    tearDown(() async {
      await followCubit.close();
    });

    Widget buildButtonWidget({required bool isFollowing}) {
      return MaterialApp(
        home: Scaffold(
          body: BlocProvider<FollowCubit>.value(
            value: followCubit,
            child: StoreProfileButtons(
              height: 800,
              width: 500,
              username: 'sample_store',
              isFollowing: isFollowing,
            ),
          ),
        ),
      );
    }

    testWidgets('renders Follow button when not following and toggles to Followed on tap', (tester) async {
      tester.view.physicalSize = const Size(1080, 1920);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(buildButtonWidget(isFollowing: false));
      await tester.pump();

      expect(find.text('Follow'), findsOneWidget);
      expect(find.text('Send a message'), findsOneWidget);

      await tester.tap(find.text('Follow'));
      await tester.pump();

      expect(fakeRepo.followedUser, 'sample_store');
      expect(find.text('Followed'), findsOneWidget);
    });

    testWidgets('renders Followed button when already following and toggles to Follow on tap', (tester) async {
      tester.view.physicalSize = const Size(1080, 1920);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(buildButtonWidget(isFollowing: true));
      await tester.pump();

      expect(find.text('Followed'), findsOneWidget);

      await tester.tap(find.text('Followed'));
      await tester.pump();

      expect(fakeRepo.unfollowedUser, 'sample_store');
      expect(find.text('Follow'), findsOneWidget);
    });

    testWidgets('tapping Send a message navigates to AppChatView', (tester) async {
      tester.view.physicalSize = const Size(1080, 1920);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      String? pushedRoute;
      dynamic pushedArgs;

      await tester.pumpWidget(
        MaterialApp(
          onGenerateRoute: (settings) {
            pushedRoute = settings.name;
            pushedArgs = settings.arguments;
            return MaterialPageRoute(builder: (_) => const Scaffold());
          },
          home: Scaffold(
            body: BlocProvider<FollowCubit>.value(
              value: followCubit,
              child: const StoreProfileButtons(
                height: 800,
                width: 500,
                username: 'sample_store',
                isFollowing: false,
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Send a message'));
      await tester.pumpAndSettle();

      expect(pushedRoute, AppChatView.name);
      expect(pushedArgs, isA<ChatArgs>());
      expect((pushedArgs as ChatArgs).chatTitle, 'sample_store');
    });
  });

  group('StoreProfileView profile type resolution', () {
    late FakeLocalStorage fakeStorage;
    late CurrentUserCubit currentUserCubit;
    late FakeProfileCubit fakeProfileCubit;
    late FakeProfileBloc fakeProfileBloc;

    setUp(() {
      fakeStorage = FakeLocalStorage();
      currentUserCubit = CurrentUserCubit(AuthLocalDataSourceImpl(fakeStorage));
      fakeProfileCubit = FakeProfileCubit();
      fakeProfileBloc = FakeProfileBloc();
    });

    tearDown(() async {
      await currentUserCubit.close();
      await fakeProfileCubit.close();
      await fakeProfileBloc.close();
    });

    testWidgets('resolves to storeProfile when visited store is different from myUsername', (tester) async {
      tester.view.physicalSize = const Size(1080, 1920);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      currentUserCubit.setUser(username: 'my_store', token: 'tok', role: 'store');

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: S.delegate.supportedLocales,
          home: MultiBlocProvider(
            providers: [
              BlocProvider<CurrentUserCubit>.value(value: currentUserCubit),
              BlocProvider<ProfileCubit>.value(value: fakeProfileCubit),
              BlocProvider<ProfileBloc>.value(value: fakeProfileBloc),
            ],
            child: const StoreProfileView(username: 'other_store'),
          ),
        ),
      );

      final profilePageFinder = find.byType(ProfilePageBody);
      expect(profilePageFinder, findsOneWidget);
      final profilePage = tester.widget<ProfilePageBody>(profilePageFinder);
      expect(profilePage.type, ProfileType.storeProfile);
      expect(fakeProfileCubit.requestedUsername, 'other_store');
    });

    testWidgets('resolves to personalStoreProfile when visited store is my own store', (tester) async {
      tester.view.physicalSize = const Size(1080, 1920);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      currentUserCubit.setUser(username: 'my_store', token: 'tok', role: 'store');

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: S.delegate.supportedLocales,
          home: MultiBlocProvider(
            providers: [
              BlocProvider<CurrentUserCubit>.value(value: currentUserCubit),
              BlocProvider<ProfileCubit>.value(value: fakeProfileCubit),
              BlocProvider<ProfileBloc>.value(value: fakeProfileBloc),
            ],
            child: const StoreProfileView(username: 'my_store'),
          ),
        ),
      );

      final profilePageFinder = find.byType(ProfilePageBody);
      expect(profilePageFinder, findsOneWidget);
      final profilePage = tester.widget<ProfilePageBody>(profilePageFinder);
      expect(profilePage.type, ProfileType.personalStoreProfile);
      expect(fakeProfileCubit.requestedUsername, 'my_store');
    });
  });

  group('ProductDetailsView navigation to StoreProfileView', () {
    testWidgets('tapping store in ProductDetailsView navigates to StoreProfileView with store entity', (tester) async {
      tester.view.physicalSize = const Size(1080, 1920);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      String? pushedRoute;
      dynamic pushedArgs;

      const sampleProduct = ProductEntity(
        id: 1,
        store: ProductStoreEntity(
          id: 10,
          name: 'Urban Arch Store',
          username: 'urban_arch',
        ),
        name: 'Drafting Compass',
        description: 'High precision drafting tool',
        price: 25.0,
        quantityInStock: 8,
        sku: 'SKU-001',
        status: 'available',
      );

      await tester.pumpWidget(
        MaterialApp(
          onGenerateRoute: (settings) {
            pushedRoute = settings.name;
            pushedArgs = settings.arguments;
            return MaterialPageRoute(builder: (_) => const Scaffold());
          },
          home: const ProductDetailsView(product: sampleProduct),
        ),
      );

      expect(find.byType(StoreHeaderTile), findsOneWidget);
      await tester.tap(find.byType(StoreHeaderTile));
      await tester.pumpAndSettle();

      expect(pushedRoute, StoreProfileView.name);
      expect(pushedArgs, isA<ProductStoreEntity>());
      expect((pushedArgs as ProductStoreEntity).username, 'urban_arch');
      expect((pushedArgs as ProductStoreEntity).id, 10);
    });
  });

  group('ProfileInfoSection bio visibility', () {
    final storeProfileEntity = ProfileEntity(
      name: 'Store Name',
      username: 'store_user',
      bio: 'Hidden store bio text',
      profilePictureUrl: null,
      followingCount: 0,
      postsCount: 5,
      projectCount: 0,
      role: 'store',
      isFollowing: false,
      details: ProfileDetailsEntity(
        academicExperiences: const [],
        contactInfo: const [],
        skills: const [],
        joinedAt: DateTime(2024, 1, 1),
      ),
    );

    final studentProfileEntity = ProfileEntity(
      name: 'Student Name',
      username: 'student_user',
      bio: 'Visible student bio text',
      profilePictureUrl: null,
      followingCount: 5,
      postsCount: 3,
      projectCount: 2,
      role: 'student',
      isFollowing: false,
      details: ProfileDetailsEntity(
        academicExperiences: const [],
        contactInfo: const [],
        skills: const [],
        joinedAt: DateTime(2024, 1, 1),
      ),
    );

    testWidgets('hides bio for store role', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProfileInfoSection(profileData: storeProfileEntity),
          ),
        ),
      );

      expect(find.text('Hidden store bio text'), findsNothing);
      expect(find.text('No bio yet'), findsNothing);
      expect(find.text('Store Name'), findsOneWidget);
    });

    testWidgets('shows bio for student role', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProfileInfoSection(profileData: studentProfileEntity),
          ),
        ),
      );

      expect(find.text('Visible student bio text'), findsOneWidget);
    });
  });

  const sampleProduct = ProductEntity(
    id: 99,
    store: ProductStoreEntity(
      id: 1,
      name: 'My Store',
      username: 'my_store',
    ),
    name: 'Sample Item',
    description: 'Item description',
    price: 99.0,
    quantityInStock: 5,
    categories: [],
    mediaItems: [],
    sku: 'SKU-99',
    status: 'available',
  );

  group('ProductCard 3-dots menu', () {
    testWidgets('renders 3-dots menu when showMenu is true and triggers callbacks', (tester) async {
      bool editCalled = false;
      bool deleteCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 200,
                height: 400,
                child: ProductCard(
                  product: sampleProduct,
                  showMenu: true,
                  onEdit: () => editCalled = true,
                  onDelete: () => deleteCalled = true,
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.more_vert), findsOneWidget);

      // Tap 3-dots button to open menu
      await tester.tap(find.byIcon(Icons.more_vert));
      await tester.pumpAndSettle();

      expect(find.text('Edit'), findsOneWidget);
      expect(find.text('Delete'), findsOneWidget);

      // Tap Edit
      await tester.tap(find.text('Edit'));
      await tester.pumpAndSettle();
      expect(editCalled, isTrue);

      // Open menu again and tap Delete
      await tester.tap(find.byIcon(Icons.more_vert));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle();
      expect(deleteCalled, isTrue);
    });

    testWidgets('hides 3-dots menu when showMenu is false', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 200,
                height: 400,
                child: ProductCard(
                  product: sampleProduct,
                  showMenu: false,
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.more_vert), findsNothing);
    });
  });

  group('ProfilePostsPage store products rendering', () {
    testWidgets('renders products grid with 3-dots menu for personalStoreProfile', (tester) async {
      final fakeBloc = FakeProfileBloc(
        const ProfileState(
          profileProducts: [sampleProduct],
          isInitialLoading: false,
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: S.delegate.supportedLocales,
          home: Scaffold(
            body: BlocProvider<ProfileBloc>.value(
              value: fakeBloc,
              child: const SizedBox(
                width: 400,
                height: 800,
                child: ProfilePostsPage(
                  width: 400,
                  height: 800,
                  type: ProfileType.personalStoreProfile,
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Sample Item'), findsOneWidget);
      expect(find.byIcon(Icons.more_vert), findsOneWidget);

      await fakeBloc.close();
    });

    testWidgets('hides 3-dots menu for visitor storeProfile', (tester) async {
      final fakeBloc = FakeProfileBloc(
        const ProfileState(
          profileProducts: [sampleProduct],
          isInitialLoading: false,
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: S.delegate.supportedLocales,
          home: Scaffold(
            body: BlocProvider<ProfileBloc>.value(
              value: fakeBloc,
              child: const SizedBox(
                width: 400,
                height: 800,
                child: ProfilePostsPage(
                  width: 400,
                  height: 800,
                  type: ProfileType.storeProfile,
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Sample Item'), findsOneWidget);
      expect(find.byIcon(Icons.more_vert), findsNothing);

      await fakeBloc.close();
    });
  });
}
