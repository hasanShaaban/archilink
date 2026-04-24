import 'package:archilink/features/Home/presentation/views/widgets/featured_member_item.dart';
import 'package:archilink/generated/l10n.dart';
import 'package:flutter/material.dart';

class ProfilesGridTab extends StatelessWidget {
  const ProfilesGridTab({super.key});

  @override
  Widget build(BuildContext context) {
    final double widht = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    const double itemHeight = 194;
    const double spacing = 25;

    return LayoutBuilder(
      builder: (context, constraints) {
        return GridView.builder(
          padding: const EdgeInsets.all(spacing),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: spacing,
            mainAxisSpacing: 0,
            mainAxisExtent: itemHeight,
          ),
          itemCount: 12,
          itemBuilder: (context, index) {
            return FeaturedMemberItem(
              lang: S.of(context),
              width: widht,
              height: height,
            );
          },
        );
      },
    );
  }
}
