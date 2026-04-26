import 'package:archilink/core/utils/app_colors.dart';
import 'package:archilink/core/utils/app_text_style.dart';
import 'package:archilink/core/utils/assets.dart';
import 'package:archilink/core/functions/snack_bar_builder.dart';
import 'package:archilink/core/services/service_locator.dart';
import 'package:archilink/features/Auth/presentation/views/auth_view.dart';
import 'package:archilink/features/settings/presentation/manager/cubit/settings_session_cubit.dart';
import 'package:archilink/features/settings/presentation/manager/cubit/settings_session_state.dart';
import 'package:archilink/features/settings/presentation/views/followers_and_following_view.dart';
import 'package:archilink/features/settings/presentation/views/my_activity_view.dart';
import 'package:archilink/features/settings/presentation/views/widgets/setting_option.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<SettingsSessionCubit>(),
      child: BlocConsumer<SettingsSessionCubit, SettingsSessionState>(
        listener: (context, state) {
          if (state is SettingsSessionError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(appSnackBar(context, state.failure, state.message));
          }

          if (state is SettingsSessionLoggedOut) {
            Navigator.of(
              context,
              rootNavigator: true,
            ).pushNamedAndRemoveUntil(AuthView.name, (route) => false);
          }
        },
        builder: (context, state) {
          final colorScheme = Theme.of(context).colorScheme;
          final isLoading = state is SettingsSessionLoading;

          return Stack(
            children: [
              Scaffold(
                appBar: AppBar(
                  title: Text(
                    'Settings and Activity',
                    style: AppTextStyle.interSemiBold16,
                  ),
                ),
                body: SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Divider(),
                      Padding(
                        padding: EdgeInsetsGeometry.symmetric(horizontal: 24),
                        child: Text(
                          'Your Account',
                          style: AppTextStyle.interMedium12.copyWith(
                            color: AppColors.gray,
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          SettingOption(
                            colorScheme: colorScheme,
                            icon: Assets.assetsIconsUser,
                            title: 'Account Center',
                            onTap: () {},
                          ),
                          SettingOption(
                            colorScheme: colorScheme,
                            icon: Assets.assetsIconsProfilePrivacy,
                            title: 'Profile Privacy',
                            onTap: () {},
                          ),
                          SettingOption(
                            colorScheme: colorScheme,
                            icon: Assets.assetsIconsSubsecriptionPlan,
                            title: 'Subscription Plan',
                            onTap: () {},
                          ),
                          SettingOption(
                            colorScheme: colorScheme,
                            icon: Assets.assetsIconsFollowersAndFollowings,
                            title: 'Followers & Followings',
                            onTap: () {
                              Navigator.of(
                                context,
                                rootNavigator: true,
                              ).pushNamed(FollowersAndFollowingView.name);
                            },
                          ),
                        ],
                      ),
                      Divider(),
                      Padding(
                        padding: EdgeInsetsGeometry.symmetric(horizontal: 24),
                        child: Text(
                          'Content and Activity',
                          style: AppTextStyle.interMedium12.copyWith(
                            color: AppColors.gray,
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          SettingOption(
                            colorScheme: colorScheme,
                            icon: Assets.assetsIconsMyActivity,
                            title: 'My Activity',
                            onTap: () {
                              Navigator.of(
                                context,
                                rootNavigator: true,
                              ).pushNamed(MyActivityView.name);
                            },
                          ),
                          SettingOption(
                            colorScheme: colorScheme,
                            icon: Assets.assetsIconsSavedCollection,
                            title: 'Saved Collections',
                            onTap: () {},
                          ),
                          SettingOption(
                            colorScheme: colorScheme,
                            icon: Assets.assetsIconsContentManagement,
                            title: 'Content Management',
                            onTap: () {},
                          ),
                        ],
                      ),
                      Divider(),
                      Padding(
                        padding: EdgeInsetsGeometry.symmetric(horizontal: 24),
                        child: Text(
                          'Content and Activity',
                          style: AppTextStyle.interMedium12.copyWith(
                            color: AppColors.gray,
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          SettingOption(
                            colorScheme: colorScheme,
                            icon: Assets.assetsIconsTheme,
                            title: 'Theme',
                            onTap: () {},
                          ),
                          SettingOption(
                            colorScheme: colorScheme,
                            icon: Assets.assetsIconsCustomerSupport,
                            title: 'Customer Support',
                            onTap: () {},
                          ),
                          SettingOption(
                            colorScheme: colorScheme,
                            icon: Assets.assetsIconsLogout,
                            title: 'Log out',
                            onTap: () async {
                              final confirmed = await _showLogoutDialog(
                                context,
                              );
                              if (!context.mounted || !confirmed) return;
                              context.read<SettingsSessionCubit>().logout();
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              if (isLoading)
                Positioned.fill(
                  child: AbsorbPointer(
                    absorbing: true,
                    child: ColoredBox(
                      color: Colors.black26,
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Future<bool> _showLogoutDialog(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text('Log out'),
        content: Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Submit'),
          ),
        ],
      ),
    );

    return result ?? false;
  }
}
