import 'package:archilink/core/utils/app_colors.dart';
import 'package:archilink/core/utils/app_text_style.dart';
import 'package:archilink/core/utils/assets.dart';
import 'package:archilink/core/widgets/expandable_text.dart';
import 'package:archilink/features/Profile/domain/entity/profile_entity.dart';
import 'package:archilink/features/Profile/presentation/views/widgets/connect_info_row.dart';
import 'package:archilink/features/Profile/presentation/views/widgets/profile_details_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ProfileDetailsPage extends StatelessWidget {
  const ProfileDetailsPage({super.key, required this.entity});

  final ProfileEntity entity;

  String _chooseContactIcon(String platform) {
    switch (platform.trim().toLowerCase()) {
      case 'facebook':
        return Assets.assetsIconsFacebook;
      case 'instagram':
        return Assets.assetsIconsInstagram;
      case 'linkedin':
        return Assets.assetsIconsLinkedin;
      case 'email':
      case 'gmail':
        return Assets.assetsIconsMail;
      case 'phone':
      case 'call':
        return Assets.assetsIconsCall;
      default:
        return Assets.assetsIconsLink;
    }
  }

  String _formatAcademicExperience(AcademicExperienceEntity exp) {
    final parts = <String>[];
    if (exp.degree.trim().isNotEmpty && exp.fieldOfStudy.trim().isNotEmpty) {
      parts.add('${exp.degree.trim()} of ${exp.fieldOfStudy.trim()}');
    } else if (exp.degree.trim().isNotEmpty) {
      parts.add(exp.degree.trim());
    } else if (exp.fieldOfStudy.trim().isNotEmpty) {
      parts.add(exp.fieldOfStudy.trim());
    }

    if (exp.university.trim().isNotEmpty) {
      if (parts.isNotEmpty) {
        parts.add('from ${exp.university.trim()}');
      } else {
        parts.add(exp.university.trim());
      }
    }

    var text = parts.join(' ');
    if (text.isNotEmpty && !text.endsWith('.')) {
      text = '$text.';
    }
    return text.isNotEmpty ? text : 'Academic experience';
  }

  Widget _buildAcademicExperienceRow(
    BuildContext context,
    AcademicExperienceEntity exp,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 5),
          child: SvgPicture.asset(
            Assets.assetsIconsDot,
            colorFilter: ColorFilter.mode(
              Theme.of(context).colorScheme.primary,
              BlendMode.srcIn,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            _formatAcademicExperience(exp),
            style: AppTextStyle.interRegular12.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final details = entity.details;
    final hasAboutMe =
        details.aboutMe != null && details.aboutMe!.trim().isNotEmpty;
    final hasAcademic = details.academicExperiences.isNotEmpty;
    final hasSkills = details.skills.isNotEmpty;
    final hasContactInfo = details.contactInfo.isNotEmpty;

    final hasAnyDetails =
        hasAboutMe || hasAcademic || hasSkills || hasContactInfo;

    if (!hasAnyDetails) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 29, vertical: 40),
          child: Text(
            'No details provided yet',
            style: AppTextStyle.interRegular14.copyWith(
              color: AppColorsFromTheme.grayForText(context),
            ),
          ),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 29, vertical: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (hasAboutMe) ...[
            ProfileDetailsContainer(
              title: 'About me',
              content: ExpandableText(
                details.aboutMe!.trim(),
                trimLines: 3,
                style: AppTextStyle.interRegular12,
              ),
            ),
            const SizedBox(height: 8),
          ],
          if (hasAcademic) ...[
            ProfileDetailsContainer(
              title: 'Academic Experience',
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (int i = 0;
                      i < details.academicExperiences.length;
                      i++) ...[
                    if (i > 0) const SizedBox(height: 8),
                    _buildAcademicExperienceRow(
                      context,
                      details.academicExperiences[i],
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 8),
          ],
          if (hasSkills) ...[
            ProfileDetailsContainer(
              title: 'Skills',
              content: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: details.skills.map((skill) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColorsFromTheme.secondaryColor(context),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColorsFromTheme.borderColor(context),
                      ),
                    ),
                    child: Text(
                      skill.name,
                      style: AppTextStyle.interMedium12.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 8),
          ],
          if (hasContactInfo) ...[
            ProfileDetailsContainer(
              title: 'Contact Info',
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (int i = 0; i < details.contactInfo.length; i++) ...[
                    if (i > 0) const SizedBox(height: 8),
                    ConnectInfoRow(
                      title: details.contactInfo[i].username.isNotEmpty
                          ? details.contactInfo[i].username
                          : (details.contactInfo[i].url ??
                              details.contactInfo[i].platform),
                      icon: _chooseContactIcon(details.contactInfo[i].platform),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 8),
          ],
        ],
      ),
    );
  }
}
