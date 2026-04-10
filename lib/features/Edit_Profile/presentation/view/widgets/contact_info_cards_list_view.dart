import 'package:archilink/core/utils/app_colors.dart';
import 'package:archilink/core/utils/app_text_style.dart';
import 'package:archilink/core/utils/assets.dart';
import 'package:archilink/features/Edit_Profile/presentation/manager/cubit/edit_profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class ContactInfoCardsListView extends StatelessWidget {
  const ContactInfoCardsListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BlocBuilder<EditProfileCubit, EditProfileState>(
        builder: (context, state) {
          if (state.contactInfos.isEmpty) {
            return Center(
              child: Text(
                'No Contact info yet',
                style: AppTextStyle.interSemiBold12.copyWith(
                  color: AppColorsFromTheme.grayForText(context),
                ),
              ),
            );
          }
          return ListView.separated(
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              final contactInfo = state.contactInfos[index];
              return GestureDetector(
                onTap: () {},
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: AppColorsFromTheme.editProfileContainer(context),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColorsFromTheme.grayForTheme(context),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: SvgPicture.asset(
                          chooseContactIcon(contactInfo.platform),
                          width: 20,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            contactInfo.platform,
                            style: AppTextStyle.interRegular12.copyWith(
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            contactInfo.handle,
                            style: AppTextStyle.interRegular12.copyWith(
                              color: AppColorsFromTheme.grayForText(context),
                            ),
                          ),
                        ],
                      ),
                      Spacer(),
                      InkWell(
                        onTap: () {
                          context.read<EditProfileCubit>().removeContactInfo(
                            index,
                          );
                        },
                        child: Icon(
                          Icons.close_rounded,
                          size: 24,
                          color: AppColors.red,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            separatorBuilder: (_, __) => SizedBox(height: 10),
            itemCount: state.contactInfos.length,
          );
        },
      ),
    );
  }
}

String chooseContactIcon(String plaform) {
  switch (plaform) {
    case 'Facebook':
      return Assets.assetsIconsFacebook;
    case 'Instagram':
      return Assets.assetsIconsInstagram;
    case 'LinkedIn':
      return Assets.assetsIconsLinkedin;
    case 'Email':
      return Assets.assetsIconsMail;
    case 'Phone':
      return Assets.assetsIconsCall;
    case 'other Links':
    default:
      return Assets.assetsIconsLink;
  }
}
