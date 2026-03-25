import 'package:archilink/core/utils/app_text_style.dart';
import 'package:archilink/core/utils/assets.dart';
import 'package:archilink/features/Profile/domain/entity/profile_entity.dart';
import 'package:archilink/features/Profile/presentation/views/widgets/connect_info_row.dart';
import 'package:archilink/features/Profile/presentation/views/widgets/profile_details_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ProfileDetailsPage extends StatelessWidget {
  const ProfileDetailsPage({super.key, required this.entity});
  final ProfileEntity entity;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 29),
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            SizedBox(height: 18),
            // ProfileDetailsContainer(
            //   title: 'About me',
            //   content: ExpandableText(
            //     style: AppTextStyle.interRegular12,
            //     trimLines: 2,
            //     '  I am a licensed architect with 3 years of experience in designing residential, commercial, and public spaces. My work focuses on blending functionality with aesthetics, creating sustainable and user-centered environments. Skilled in AutoCAD, Revit, and 3D visualization tools, I translate concepts into detailed plans that bring clients’ visions to life. I am passionate about innovative design, efficient project management, and delivering high-quality results from concept to completion.',
            //   ),
            // ),
            SizedBox(height: 8),
            ProfileDetailsContainer(
              title: 'Academic Experience',
              content: Column(
                children: [
                  Row(
                    children: [

                      SizedBox(width: 8),
                      SvgPicture.asset(
                        Assets.assetsIconsDot,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      SizedBox(width: 8),
                      Text(
                        '${entity.details.academicExperiences.first.degree} of ${entity.details.academicExperiences.first.fieldOfStudy} from ${entity.details.academicExperiences.first.university}.',
                        style: AppTextStyle.interRegular12.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 8),
            ProfileDetailsContainer(
              title: 'Contact Info',
              content: Column(
                children: [
                  ConnectInfoRow(
                    title: 'Hasan_SH',
                    icon: Assets.assetsIconsFacebook,
                  ),
                  SizedBox(height: 8),
                  ConnectInfoRow(
                    title: 'Has_an',
                    icon: Assets.assetsIconsInstagram,
                  ),
                  SizedBox(height: 8),
                  ConnectInfoRow(
                    title: 'HasanA.SH',
                    icon: Assets.assetsIconsLinkedin,
                  ),
                  SizedBox(height: 8),
                  ConnectInfoRow(
                    title: '0931439996',
                    icon: Assets.assetsIconsCall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

