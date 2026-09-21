import 'package:archilink/core/utils/app_colors.dart';
import 'package:archilink/core/utils/app_text_style.dart';
import 'package:archilink/core/utils/assets.dart';
import 'package:archilink/features/Edit_Profile/presentation/view/edit_profile_view.dart';
import 'package:archilink/features/Profile/domain/entity/profile_entity.dart';
import 'package:archilink/features/Profile/presentation/views/widgets/profile_custom_button.dart';
import 'package:archilink/features/Profile/presentation/manager/cubit/profile_cubit.dart';
import 'package:archilink/features/Store/presentation/views/add_edit_product_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class PersonalStoreProfileButtons extends StatelessWidget {
  const PersonalStoreProfileButtons({
    super.key,
    required this.width,
    required this.profileData,
    this.onAddProduct,
  });

  final double width;
  final ProfileEntity profileData;
  final VoidCallback? onAddProduct;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 61),
      child: Row(
        children: [
          Expanded(
            child: ProfileCustomButton(
              onPress: () async {
                if (onAddProduct != null) {
                  onAddProduct!();
                } else {
                  final result = await Navigator.of(
                    context,
                    rootNavigator: true,
                  ).pushNamed(AddEditProductView.name);
                  if (result == true && context.mounted) {
                    try {
                      context.read<ProfileCubit>().getPersonlProfile();
                    } catch (_) {}
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Product added successfully'),
                        backgroundColor: Color(0xFF008080),
                      ),
                    );
                  }
                }
              },
              icon: Assets.assetsIconsAdd,
              iconSize: 16,
              title: 'Add Product',
              backgroundColor: Theme.of(context).colorScheme.primary,
              textStyle: AppTextStyle.interMedium12.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: ProfileCustomButton(
              onPress: () async {
                final result = await Navigator.of(
                  context,
                  rootNavigator: true,
                ).pushNamed(
                  EditProfileView.name,
                  arguments: {'profileData': profileData, 'isStore': true},
                );
                if (result == true && context.mounted) {
                  try {
                    context.read<ProfileCubit>().getPersonlProfile();
                  } catch (_) {}
                }
              },
              icon: Assets.assetsIconsEditProfile,
              iconSize: 16,
              title: 'Edit Profile',
              backgroundColor: AppColorsFromTheme.grayForTheme(context),
              textStyle: AppTextStyle.interMedium12.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: width * 36 / 402,
            height: width * 36 / 402,
            child: MaterialButton(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusGeometry.circular(10),
              ),
              color: AppColorsFromTheme.grayForTheme(context),
              padding: EdgeInsets.zero,
              onPressed: () {},
              child: SvgPicture.asset(
                Assets.assetsIconsShareProfile,
                width: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
