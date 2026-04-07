import 'package:archilink/core/utils/app_colors.dart';
import 'package:archilink/core/utils/app_text_style.dart';
import 'package:archilink/features/Edit_Profile/presentation/manager/cubit/edit_profile_cubit.dart';
import 'package:archilink/features/Edit_Profile/presentation/view/widgets/edit_profile_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AboutMeView extends StatefulWidget {
  const AboutMeView({super.key});
  static const name = '/aboutMe';

  @override
  State<AboutMeView> createState() => _AboutMeViewState();
}

class _AboutMeViewState extends State<AboutMeView> {
  FocusNode focusNode = FocusNode();
  late final TextEditingController aboutController;

  @override
  void initState() {
    final state = context.read<EditProfileCubit>().state;
    aboutController = TextEditingController(text: state.aboutMe);

     focusNode.addListener(() => setState(() {}));
    super.initState();
  }

  @override
  void dispose() {
    focusNode.dispose();
    aboutController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<EditProfileCubit>();
    return Scaffold(
      body: SafeArea(
        child: BlocListener<EditProfileCubit, EditProfileState>(
          listenWhen: (prev, next) => prev.aboutMe != next.aboutMe,
          listener: (context, state) {
            if (aboutController.text != state.aboutMe) {
              aboutController.text = state.aboutMe;
            }
          },
          child: Column(
            children: [
              EditProfileAppBar(
                withDoneButton: true,
                titel: 'About me',
                onDone: () {
                  cubit.updateAboutMe(aboutController.text);
                  Navigator.pop(context);
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: TextField(
                  focusNode: focusNode,
                  onTapOutside: (event) => focusNode.unfocus(),
                  controller: aboutController,
                  onChanged: cubit.updateAboutMe,
                  style: AppTextStyle.interRegular14.copyWith(
                    color: focusNode.hasFocus
                        ? Theme.of(context).colorScheme.onSurface
                        : AppColorsFromTheme.grayForText(context),
                  ),
                  maxLines: null,
                  minLines: 1,
                  textInputAction: TextInputAction.newline,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 16,
                    ),
                    filled: true,
                    fillColor: AppColorsFromTheme.editProfileContainer(context),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
