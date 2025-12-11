import 'package:archilink/core/utils/app_colors.dart';
import 'package:archilink/core/utils/app_text_style.dart';
import 'package:archilink/core/utils/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class RoleDropDownField extends StatefulWidget {
  const RoleDropDownField({
    super.key,
    required this.height,
    required this.label,
    required this.hint,
    this.value,
    required this.options,
    required this.onSelected,
  });

  final double height;
  final String label, hint;
  final String? value;
  final List<String> options;
  final void Function(String) onSelected;

  @override
  State<RoleDropDownField> createState() => _RoleDropDownFieldState();
}

class _RoleDropDownFieldState extends State<RoleDropDownField> {

  final GlobalKey _key = GlobalKey();

  void _openMenu() async {
    final RenderBox box = _key.currentContext!.findRenderObject() as RenderBox;
    final Offset position = box.localToGlobal(Offset.zero);
    final select = await showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(
        position.dx,
        position.dy +box.size.height,
        position.dy + box.size.width,
        0,
      ),
      popUpAnimationStyle: AnimationStyle(
        curve: Curves.easeInExpo,
        duration: const Duration(milliseconds: 400)
      ),
      items: [
      
        PopupMenuItem(
          height: 0,
          enabled: false,
          padding: EdgeInsets.zero,
          child: _buildRolesMenu(context),
        )
      ]
    );

    if (select != null) {
      widget.onSelected(select);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label, style: AppTextStyle.mallannaSemiBold14),
        InkWell(
          key: _key,
          onTap: _openMenu,
          child: Container(
            padding: EdgeInsets.only(right: 18, left: 12),
            width: double.infinity,
            height: widget.height * 41 / 896,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: AppColorsFromTheme.secondaryColor(
                  context,
                ).withOpacity(0.5),
              ),
              color: AppColorsFromTheme.secondaryColor(
                context,
              ).withOpacity(0.5),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    widget.value ?? widget.hint,
                    style: AppTextStyle.mallannaSemiBold14.copyWith(
                      color: widget.value == null
                          ? AppColors.lightGrayDarkMode
                          : Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ),
                SvgPicture.asset(
                  Assets.assetsIconsDownArrow,
                  color: AppColors.lightGrayDarkMode,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRolesMenu(BuildContext context){
    return Material(
      color: Colors.transparent,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColorsFromTheme.secondaryColor(context),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.lightGrayDarkMode),
          
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (i){
            return Column(
              children: [
                InkWell(
                  onTap: () => Navigator.pop(context, widget.options[i]),
                  borderRadius: i == 0
                      ? const BorderRadius.vertical(top: Radius.circular(14))
                      : i == widget.options.length - 1
                          ? const BorderRadius.vertical(bottom: Radius.circular(14))
                          : BorderRadius.zero,
                  child: Container(
                    padding: EdgeInsets.only(left: 24, top: 16, bottom: 16,),
                    width: double.infinity,
                    child: Text(
                      widget.options[i],
                      style: AppTextStyle.interMedium12.copyWith(color: Theme.of(context).colorScheme.onSurface),
                    ),
                  ),
                ),
                i != 2 ? Divider(color: AppColors.lightGrayDarkMode,height: 1,):SizedBox()
              ],
            );
          })
        ),
      ),
    );
  }
}
