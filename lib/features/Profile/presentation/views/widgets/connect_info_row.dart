import 'package:archilink/core/utils/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ConnectInfoRow extends StatelessWidget {
  const ConnectInfoRow({
    super.key, required this.title, required this.icon,
  });
  final String title, icon;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: SvgPicture.asset(icon, color: Theme.of(context).colorScheme.onSurface,width: 20,),
        ),
        Text(title, style: AppTextStyle.interMedium12.copyWith(color: Theme.of(context).colorScheme.onSurface),)
      ],
    );
  }
}
