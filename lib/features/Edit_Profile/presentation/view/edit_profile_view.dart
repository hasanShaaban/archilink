import 'package:archilink/core/utils/app_colors.dart';
import 'package:archilink/core/utils/app_text_style.dart';
import 'package:archilink/features/Edit_Profile/presentation/view/widgets/edit_profile_app_bar.dart';
import 'package:flutter/material.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({super.key});

  static const name = '/editProfile';

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  final ValueNotifier<bool> hasChanges = ValueNotifier(false);
  late final EditProfileController controller;

  @override
  void initState() {
    controller = EditProfileController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            EditProfileAppBar(),
            SizedBox(height: 16),
            Padding(
              padding: EdgeInsetsGeometry.symmetric(horizontal: 20),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: AppColorsFromTheme.grayForTheme(context),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    EditableText(
                      title: 'Full Name',
                      isOneRow: true,
                      initialValue: 'Hasan Shaaban',
                      controller: controller.fullName,
                    ),
                    Divider(height: 1),
                    EditableText(
                      title: 'UserName',
                      isOneRow: true,
                      initialValue: 'hsa_hasan',
                      controller: controller.username,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EditableText extends StatefulWidget {
  const EditableText({
    super.key,
    required this.title,
    required this.isOneRow,
    required this.initialValue,
    required this.controller,
  });
  final String title, initialValue;
  final bool isOneRow;
  final TextEditingController controller;

  @override
  State<EditableText> createState() => _EditableTextState();
}

class _EditableTextState extends State<EditableText> {
  bool isEditing = false;
  bool enabled = true;

  @override
  void initState() {
    widget.controller.text = widget.initialValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: AnimatedSize(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.title,
                    style: AppTextStyle.interSemiBold12.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),

                  if (!isEditing && widget.isOneRow)
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => setState(() => isEditing = true),
                        child: Text(
                          widget.controller.text,
                          style: AppTextStyle.interRegular12.copyWith(
                            color: AppColors.gray,
                          ),
                        ),
                      ),
                    ),
                  if (isEditing)
                    Row(
                      children: [
                        SizedBox(
                          width: 150,
                          child: TextField(
                            style: AppTextStyle.interRegular10,
                            enabled: enabled,
                            onTapUpOutside: (event) {
                              setState(() {
                                isEditing = false;
                              });
                            },
                            controller: widget.controller,
                            maxLines: null,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 8,
                              ),
                              filled: true,
                              fillColor: AppColorsFromTheme.containerColor(
                                context,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                      ],
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EditProfileController {
  final fullName = TextEditingController();
  final username = TextEditingController();
  final bio = TextEditingController();
  final about = TextEditingController();
  final services = TextEditingController();

  void dispose() {
    fullName.dispose();
    username.dispose();
    bio.dispose();
    about.dispose();
    services.dispose();
  }
}
