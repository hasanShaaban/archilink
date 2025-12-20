import 'package:archilink/core/utils/app_text_style.dart';
import 'package:archilink/generated/l10n.dart';
import 'package:flutter/material.dart';

class ExpandableText extends StatefulWidget {
  final String text;
  final int trimLines;
  final TextStyle? style;

  const ExpandableText(this.text, {super.key, this.trimLines = 3, this.style = AppTextStyle.mallannaRegular14});

  @override
  _ExpandableTextState createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool _readMore = true;

  @override
  Widget build(BuildContext context) {
    var lang = S.of(context);
    final textSpan = TextSpan(text: widget.text);
    final textPainter = TextPainter(
      text: textSpan,
      maxLines: widget.trimLines,
      textDirection: lang.local == 'ar' ? TextDirection.rtl : TextDirection.ltr,
    );
    textPainter.layout(maxWidth: MediaQuery.of(context).size.width);

    final isOverflowing = textPainter.didExceedMaxLines;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.text,
          maxLines: _readMore ? widget.trimLines : null,
          overflow: _readMore ? TextOverflow.ellipsis : TextOverflow.visible,
          style: widget.style!.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
            height: 1.4,
          ),
        ),
        if (isOverflowing)
          GestureDetector(
            onTap: () => setState(() => _readMore = !_readMore),
            child: Text(
              _readMore ? "Read more" : "Read less",
              style: AppTextStyle.mallannaRegular14.copyWith(
                color: Theme.of(context).colorScheme.primary,
                height: 1.2,
              ),
            ),
          ),
      ],
    );
  }
}