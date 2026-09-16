import 'package:archilink/core/error/failure.dart';
import 'package:archilink/core/network/websocket/reverb_client.dart';
import 'package:archilink/core/services/service_locator.dart';
import 'package:archilink/core/storage/local_storage.dart';
import 'package:archilink/features/Auth/data/data_source/auth_local_data_source_impl.dart';
import 'package:archilink/features/Auth/domain/data_source/auth_local_data_source.dart';
import 'package:archilink/features/Auth/presentation/manager/cubits/cubit/current_user_cubit.dart';
import 'package:archilink/features/settings/domain/repo/setting_repo.dart';
import 'package:archilink/features/settings/presentation/manager/cubit/settings_session_cubit.dart';
import 'package:archilink/features/settings/presentation/views/customer_support_view.dart';
import 'package:archilink/features/settings/presentation/views/setting_page.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

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

class FakeSettingRepo implements SettingRepo {
  @override
  Future<Either<Failure, bool>> logOut() async => right(true);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakeReverbClient implements ReverbClient {
  @override
  void disconnect() {}

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  late FakeLocalStorage fakeStorage;
  late AuthLocalDataSource authLocalDataSource;
  late CurrentUserCubit currentUserCubit;

  setUp(() {
    fakeStorage = FakeLocalStorage();
    authLocalDataSource = AuthLocalDataSourceImpl(fakeStorage);
    currentUserCubit = CurrentUserCubit(authLocalDataSource);

    if (sl.isRegistered<SettingsSessionCubit>()) {
      sl.unregister<SettingsSessionCubit>();
    }
    sl.registerFactory<SettingsSessionCubit>(
      () => SettingsSessionCubit(
        FakeSettingRepo(),
        authLocalDataSource,
        currentUserCubit,
        FakeReverbClient(),
      ),
    );
  });

  tearDown(() async {
    await currentUserCubit.close();
    if (sl.isRegistered<SettingsSessionCubit>()) {
      sl.unregister<SettingsSessionCubit>();
    }
  });

  Widget buildWidget({void Function(RouteSettings)? onNavigate}) {
    return MaterialApp(
      onGenerateRoute: (settings) {
        onNavigate?.call(settings);
        return MaterialPageRoute(builder: (_) => const Scaffold());
      },
      home: BlocProvider<CurrentUserCubit>.value(
        value: currentUserCubit,
        child: const SettingPage(),
      ),
    );
  }

  group('SettingPage store-specific menu', () {
    testWidgets('renders flat 6-item list for store role', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      currentUserCubit.setRole('store');
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      // Items that MUST be present for store:
      expect(find.text('Account Center'), findsOneWidget);
      expect(find.text('Privacy and Policy'), findsOneWidget);
      expect(find.text('Subscription Plan'), findsOneWidget);
      expect(find.text('Theme'), findsOneWidget);
      expect(find.text('Customer Support'), findsOneWidget);
      expect(find.text('Log out'), findsOneWidget);

      // Section titles and items that MUST be hidden for store:
      expect(find.text('Your Account'), findsNothing);
      expect(find.text('Profile Privacy'), findsNothing);
      expect(find.text('Followers & Followings'), findsNothing);
      expect(find.text('My Activity'), findsNothing);
      expect(find.text('Saved Collections'), findsNothing);
      expect(find.text('Content Management'), findsNothing);
    });

    testWidgets('Customer Support navigates to CustomerSupportView for store role', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      String? pushedRoute;
      currentUserCubit.setRole('store');
      await tester.pumpWidget(buildWidget(
        onNavigate: (settings) => pushedRoute = settings.name,
      ));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Customer Support'));
      await tester.pumpAndSettle();

      expect(pushedRoute, CustomerSupportView.name);
    });

    testWidgets('Log out opens confirmation dialog for store role', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      currentUserCubit.setRole('store');
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Log out'));
      await tester.pumpAndSettle();

      expect(find.text('Are you sure you want to log out?'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Submit'), findsOneWidget);
    });

    testWidgets('renders all 3 sections with full items for student role', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      currentUserCubit.setRole('student');
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();

      // Section titles present:
      expect(find.text('Your Account'), findsOneWidget);

      // All student items present:
      expect(find.text('Account Center'), findsOneWidget);
      expect(find.text('Profile Privacy'), findsOneWidget);
      expect(find.text('Subscription Plan'), findsOneWidget);
      expect(find.text('Followers & Followings'), findsOneWidget);
      expect(find.text('My Activity'), findsOneWidget);
      expect(find.text('Saved Collections'), findsOneWidget);
      expect(find.text('Content Management'), findsOneWidget);
      expect(find.text('Theme'), findsOneWidget);
      expect(find.text('Customer Support'), findsOneWidget);
      expect(find.text('Log out'), findsOneWidget);

      // Store-only "Privacy and Policy" not present in student view
      expect(find.text('Privacy and Policy'), findsNothing);
    });
  });
}
