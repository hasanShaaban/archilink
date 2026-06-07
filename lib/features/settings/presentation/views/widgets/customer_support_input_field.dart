import 'package:archilink/core/utils/app_colors.dart';
import 'package:archilink/core/utils/app_text_style.dart';
import 'package:archilink/core/utils/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomerSupportInputField extends StatefulWidget {
  const CustomerSupportInputField({super.key, this.onSend});

  final ValueChanged<String>? onSend;

  @override
  State<CustomerSupportInputField> createState() =>
      _CustomerSupportInputFieldState();
}

class _CustomerSupportInputFieldState extends State<CustomerSupportInputField> {
  late final TextEditingController _messageController;

  @override
  void initState() {
    super.initState();
    _messageController = TextEditingController();
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _handleSend() {
    final text = _messageController.text.trim();
    if (text.isNotEmpty) {
      widget.onSend?.call(text);
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: TextField(
            controller: _messageController,
            style: AppTextStyle.interMedium14,
            maxLines: 4,
            minLines: 1,
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColorsFromTheme.grayForTheme(context),
              hintText: 'Explain your problem.',
              hintStyle: AppTextStyle.interMedium12.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                  width: 1.5,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                  width: 2.0,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        TextButton(
          onPressed: _handleSend,
          style: TextButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                SvgPicture.asset(
                  Assets.assetsIconsSharePost,
                  // ignore: deprecated_member_use
                  color: Theme.of(context).colorScheme.onSurface,
                  width: 16,
                  height: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  'Send',
                  style: AppTextStyle.interSemiBold12.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
