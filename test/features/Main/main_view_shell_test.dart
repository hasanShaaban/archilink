import 'package:archilink/core/error/failure.dart';
import 'package:archilink/core/services/service_locator.dart';
import 'package:archilink/core/storage/local_storage.dart';
import 'package:archilink/features/Auth/data/data_source/auth_local_data_source_impl.dart';
import 'package:archilink/features/Auth/presentation/manager/cubits/cubit/current_user_cubit.dart';
import 'package:archilink/core/widgets/main_appbar.dart';
import 'package:archilink/features/Home/domain/repo/home_repo.dart';
import 'package:archilink/features/Home/presentation/views/home_page_body.dart';
import 'package:archilink/features/Main/presentation/manager/main_tab_controller.dart';
import 'package:archilink/features/Main/presentation/views/widgets/main_view_body.dart';
import 'package:archilink/features/Post/domain/entity/pagination_entity.dart';
import 'package:archilink/features/Post/domain/entity/posts_entity.dart';
import 'package:archilink/features/Post/domain/repo/post_repo.dart';
import 'package:archilink/features/Post/presentation/manager/cubit/post_like_cubit.dart';
import 'package:archilink/features/Profile/domain/entity/profile_type.dart';
import 'package:archilink/features/Profile/presentation/views/profile_page_body.dart';
import 'package:archilink/features/Store/domain/entity/add_product_params.dart';
import 'package:archilink/features/Store/domain/entity/category_feed_entity.dart';
import 'package:archilink/features/Store/domain/entity/product_entity.dart';
import 'package:archilink/features/Store/domain/entity/product_feed_entity.dart';
import 'package:archilink/features/Store/domain/repo/store_repo.dart';
import 'package:archilink/features/Store/presentation/manager/cubit/store_feed_cubit.dart';
import 'package:archilink/features/Store/presentation/views/store_feed_page.dart';
import 'package:archilink/features/settings/presentation/views/setting_page.dart';
import 'package:archilink/generated/l10n.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

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

class FakeHomeRepo implements HomeRepo {
  @override
  Future<Either<Failure, PostsEntity>> getGlobalFeed({required int page}) async {
    return right(
      const PostsEntity(
        posts: [],
        pagination: PaginationEntity(
          currentPage: 1,
          perPage: 20,
          lastPage: 1,
          total: 0,
          hasMore: false,
        ),
      ),
    );
  }

  @override
  Future<Either<Failure, PostsEntity>> getFollowingFeed({required int page}) async {
    return right(
      const PostsEntity(
        posts: [],
        pagination: PaginationEntity(
          currentPage: 1,
          perPage: 20,
          lastPage: 1,
          total: 0,
          hasMore: false,
        ),
      ),
    );
  }
}

class FakePostLikeCubit extends Cubit<PostLikeState?> implements PostLikeCubit {
  FakePostLikeCubit() : super(null);
  @override
  PostRepo get repo => throw UnimplementedError();
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakeStoreRepo implements StoreRepo {
  @override
  Future<Either<Failure, ProductFeedEntity>> getProducts(int page) async {
    return right(
      const ProductFeedEntity(
        products: [],
        pagination: PaginationEntity(
          currentPage: 1,
          perPage: 20,
          lastPage: 1,
          total: 0,
          hasMore: false,
        ),
      ),
    );
  }

  @override
  Future<Either<Failure, CategoryFeedEntity>> getCategories({int page = 1}) async {
    return right(
      const CategoryFeedEntity(
        categories: [],
        pagination: PaginationEntity(
          currentPage: 1,
          perPage: 20,
          lastPage: 1,
          total: 0,
          hasMore: false,
        ),
      ),
    );
  }

  @override
  Future<Either<Failure, ProductEntity>> addProduct(AddProductParams params) async {
    return left(UnknownFailure());
  }
}

void main() {
  late FakeLocalStorage fakeStorage;
  late CurrentUserCubit currentUserCubit;

  setUp(() {
    fakeStorage = FakeLocalStorage();
    currentUserCubit = CurrentUserCubit(AuthLocalDataSourceImpl(fakeStorage));

    if (!sl.isRegistered<MainTabController>()) {
      sl.registerLazySingleton<MainTabController>(() => MainTabController());
    }
    if (!sl.isRegistered<StoreFeedCubit>()) {
      sl.registerFactory<StoreFeedCubit>(() => StoreFeedCubit(FakeStoreRepo()));
    }
    if (!sl.isRegistered<HomeRepo>()) {
      sl.registerLazySingleton<HomeRepo>(() => FakeHomeRepo());
    }
    if (!sl.isRegistered<PostLikeCubit>()) {
      sl.registerLazySingleton<PostLikeCubit>(() => FakePostLikeCubit());
    }
  });

  tearDown(() async {
    await currentUserCubit.close();
  });

  Widget buildTestWidget() {
    return MaterialApp(
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      home: BlocProvider<CurrentUserCubit>.value(
        value: currentUserCubit,
        child: const Scaffold(body: MainViewBody()),
      ),
    );
  }

  testWidgets('renders 3-tab _StoreShell for role == "store"', (tester) async {
    currentUserCubit.setRole('store');

    await tester.pumpWidget(buildTestWidget());

    // Verify _StoreShell is mounted and _StudentMentorShell is not
    expect(find.byWidgetPredicate((w) => w.runtimeType.toString() == '_StoreShell'), findsOneWidget);
    expect(find.byWidgetPredicate((w) => w.runtimeType.toString() == '_StudentMentorShell'), findsNothing);

    // Verify PersistentTabView in store shell has 3 screens configured
    final tabView = tester.widget<PersistentTabView>(find.byType(PersistentTabView));
    expect(tabView.screens.length, 3);
    expect(tabView.screens[0], isA<StoreFeedPage>());
    expect(tabView.screens[1], isA<ProfilePageBody>());
    expect((tabView.screens[1] as ProfilePageBody).type, ProfileType.personalStoreProfile);
    expect(tabView.screens[2], isA<SettingPage>());

    // Verify tabs items
    expect(tabView.items.length, 3);
    expect(tabView.items[0].title, 'Products');
  });

  testWidgets('store user does not encounter HomePageBody or MainAppBar (no home search icon)', (tester) async {
    currentUserCubit.setRole('store');

    await tester.pumpWidget(buildTestWidget());

    // HomePageBody and MainAppBar (which contains the home search icon) must not be mounted
    expect(find.byType(HomePageBody), findsNothing);
    expect(find.byType(MainAppBar), findsNothing);
  });

  testWidgets('renders 4-tab _StudentMentorShell for role == "student"', (tester) async {
    tester.view.physicalSize = const Size(1080, 1920);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    currentUserCubit.setRole('student');

    await tester.pumpWidget(buildTestWidget());

    // Verify _StudentMentorShell is mounted and _StoreShell is not
    expect(find.byWidgetPredicate((w) => w.runtimeType.toString() == '_StudentMentorShell'), findsOneWidget);
    expect(find.byWidgetPredicate((w) => w.runtimeType.toString() == '_StoreShell'), findsNothing);

    // Verify PersistentTabView in student shell has 4 screens configured
    final tabView = tester.widget<PersistentTabView>(find.byType(PersistentTabView));
    expect(tabView.screens.length, 4);
    expect(tabView.screens[0], isA<HomePageBody>());
    expect(tabView.screens[1], isA<StoreFeedPage>());
    expect(tabView.screens[2], isA<ProfilePageBody>());
    expect((tabView.screens[2] as ProfilePageBody).type, ProfileType.personalProfile);
    expect(tabView.screens[3], isA<SettingPage>());

    // Verify tab items count
    expect(tabView.items.length, 4);
  });
}
