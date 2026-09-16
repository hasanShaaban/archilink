import 'package:archilink/core/storage/local_storage.dart';
import 'package:archilink/core/utils/assets.dart';
import 'package:archilink/core/widgets/app_bar_action_button.dart';
import 'package:archilink/core/widgets/main_appbar.dart';
import 'package:archilink/features/Auth/data/data_source/auth_local_data_source_impl.dart';
import 'package:archilink/features/Auth/presentation/manager/cubits/cubit/current_user_cubit.dart';
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

void main() {
  late FakeLocalStorage fakeStorage;
  late CurrentUserCubit currentUserCubit;

  setUp(() {
    fakeStorage = FakeLocalStorage();
    currentUserCubit = CurrentUserCubit(AuthLocalDataSourceImpl(fakeStorage));
  });

  tearDown(() async {
    await currentUserCubit.close();
  });

  Widget buildWidget({bool withTabbar = false, bool? showSearch}) {
    return MaterialApp(
      home: BlocProvider<CurrentUserCubit>.value(
        value: currentUserCubit,
        child: Scaffold(
          body: CustomScrollView(
            slivers: [
              MainAppBar(withTabbar: withTabbar, showSearch: showSearch),
            ],
          ),
        ),
      ),
    );
  }

  Finder findSearchButton() {
    return find.byWidgetPredicate(
      (w) => w is AppBarActionButton && w.icon == Assets.assetsIconsSearch,
    );
  }

  Finder findMailButton() {
    return find.byWidgetPredicate(
      (w) => w is AppBarActionButton && w.icon == Assets.assetsIconsMail,
    );
  }

  group('MainAppBar search icon visibility', () {
    testWidgets('hides search button for store role', (tester) async {
      currentUserCubit.setRole('store');
      await tester.pumpWidget(buildWidget());

      expect(findMailButton(), findsOneWidget);
      expect(findSearchButton(), findsNothing);
    });

    testWidgets('hides search button for Store role (case-insensitive)', (tester) async {
      currentUserCubit.setRole('Store');
      await tester.pumpWidget(buildWidget());

      expect(findMailButton(), findsOneWidget);
      expect(findSearchButton(), findsNothing);
    });

    testWidgets('shows search button for student role', (tester) async {
      currentUserCubit.setRole('student');
      await tester.pumpWidget(buildWidget());

      expect(findMailButton(), findsOneWidget);
      expect(findSearchButton(), findsOneWidget);
    });

    testWidgets('shows search button for mentor role', (tester) async {
      currentUserCubit.setRole('mentor');
      await tester.pumpWidget(buildWidget());

      expect(findMailButton(), findsOneWidget);
      expect(findSearchButton(), findsOneWidget);
    });

    testWidgets('explicit showSearch: false overrides student role', (tester) async {
      currentUserCubit.setRole('student');
      await tester.pumpWidget(buildWidget(showSearch: false));

      expect(findMailButton(), findsOneWidget);
      expect(findSearchButton(), findsNothing);
    });

    testWidgets('explicit showSearch: true overrides store role', (tester) async {
      currentUserCubit.setRole('store');
      await tester.pumpWidget(buildWidget(showSearch: true));

      expect(findMailButton(), findsOneWidget);
      expect(findSearchButton(), findsOneWidget);
    });
  });
}
