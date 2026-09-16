import 'package:archilink/features/Auth/presentation/manager/cubits/cubit/current_user_cubit.dart';
import 'package:archilink/features/Profile/domain/entity/profile_type.dart';
import 'package:archilink/features/Profile/presentation/manager/cubit/profile_cubit.dart';
import 'package:archilink/features/Profile/presentation/views/profile_page_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Displays a store owner's profile.
///
/// Pass the store's [username] (the `handle` field on [ProductStoreEntity]).
/// The view determines the correct [ProfileType] by comparing [username]
/// against the currently cached user from [CurrentUserCubit]:
///
/// - Same username → [ProfileType.personalStoreProfile] (own store)
/// - Different  → [ProfileType.storeProfile] (someone else's store)
class StoreProfileView extends StatefulWidget {
  const StoreProfileView({super.key, required this.username});

  final String username;

  static const String name = '/storeProfile';

  @override
  State<StoreProfileView> createState() => _StoreProfileViewState();
}

class _StoreProfileViewState extends State<StoreProfileView> {
  late final ProfileType _profileType;

  @override
  void initState() {
    super.initState();

    final myUsername = context.read<CurrentUserCubit>().state.username;
    final isMyStore =
        myUsername != null && myUsername == widget.username;

    _profileType = isMyStore
        ? ProfileType.personalStoreProfile
        : ProfileType.storeProfile;

    // Fetch the store profile data. ProfileCubit is provided globally in main.dart.
    context.read<ProfileCubit>().getUserProfile(widget.username);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ProfilePageBody(type: _profileType),
    );
  }
}
