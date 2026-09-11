import 'package:archilink/core/utils/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';

class ConnectInfoRow extends StatelessWidget {
  const ConnectInfoRow({
    super.key,
    required this.title,
    required this.icon,
    this.url,
  });

  final String title;
  final String icon;
  final String? url;

  Future<void> _launchContactUrl(BuildContext context) async {
    final rawUrl = url?.trim();
    if (rawUrl == null || rawUrl.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No link available for this contact'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    Uri? uri;
    // Check if it's already a well-known scheme like mailto: or tel:
    if (rawUrl.startsWith('mailto:') || rawUrl.startsWith('tel:')) {
      uri = Uri.tryParse(rawUrl);
    } else if (RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    ).hasMatch(rawUrl)) {
      uri = Uri(scheme: 'mailto', path: rawUrl);
    } else if (RegExp(r'^\+?[0-9\s\-()]{7,}$').hasMatch(rawUrl) &&
        !rawUrl.contains('.')) {
      uri = Uri(
        scheme: 'tel',
        path: rawUrl.replaceAll(RegExp(r'[\s\-()]'), ''),
      );
    } else {
      var formatted = rawUrl;
      if (!formatted.startsWith('http://') &&
          !formatted.startsWith('https://')) {
        formatted = 'https://$formatted';
      }
      uri = Uri.tryParse(formatted);
    }

    if (uri == null ||
        (uri.scheme != 'mailto' && uri.scheme != 'tel' && uri.host.isEmpty)) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Invalid link: $rawUrl'),
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    try {
      final mode = (uri.scheme == 'http' || uri.scheme == 'https')
          ? LaunchMode.externalApplication
          : LaunchMode.platformDefault;

      final launched = await launchUrl(uri, mode: mode);
      if (!launched && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not open link: $rawUrl'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not open link: $rawUrl'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasUrl = url != null && url!.trim().isNotEmpty;

    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () => _launchContactUrl(context),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: SvgPicture.asset(
                icon,
                colorFilter: ColorFilter.mode(
                  Theme.of(context).colorScheme.onSurface,
                  BlendMode.srcIn,
                ),
                width: 20,
              ),
            ),
            Expanded(
              child: Text(
                title,
                style: AppTextStyle.interMedium12.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (hasUrl)
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Icon(
                  Icons.open_in_new_rounded,
                  size: 14,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.5),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
