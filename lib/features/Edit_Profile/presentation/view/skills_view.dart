
import 'package:archilink/features/Edit_Profile/presentation/manager/cubit/edit_profile_cubit.dart';
import 'package:archilink/features/Edit_Profile/presentation/view/widgets/add_skill_text_field.dart';
import 'package:archilink/features/Edit_Profile/presentation/view/widgets/edit_profile_add_button.dart';
import 'package:archilink/features/Edit_Profile/presentation/view/widgets/edit_profile_app_bar.dart';
import 'package:archilink/features/Edit_Profile/presentation/view/widgets/skills_cards_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SkillsView extends StatefulWidget {
  const SkillsView({super.key});
  static const name = '/skills';

  @override
  State<SkillsView> createState() => _SkillsViewState();
}

class _SkillsViewState extends State<SkillsView> with TickerProviderStateMixin {
  bool showInput = false;
  FocusNode focusNode = FocusNode();
  late final TextEditingController skillController;

  @override
  void initState() {
    skillController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    skillController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<EditProfileCubit>();
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            EditProfileAppBar(
              titel: 'Skills',
              withDoneButton: true,
              onDone: () {
                final pending = skillController.text.trim();
                if (pending.isNotEmpty) {
                  cubit.addSkill(pending);
                  skillController.clear();
                }
                Navigator.pop(context);
              },
            ),
            EditProfileAddButton(
              showInput: showInput,
              title: 'Add skill',
              onPressed: () {
                setState(() {
                  showInput = !showInput;
                });
              },
            ),
            AnimatedSize(
              duration: Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              alignment: Alignment.topCenter,
              child: ClipRect(
                child: Align(
                  alignment: Alignment.topCenter,
                  heightFactor: showInput ? 1 : 0,
                  child: AddSkillTextFiled(
                    focusNode: focusNode,
                    skillController: skillController,
                    cubit: cubit,
                  ),
                ),
              ),
            ),
            SkillsCardsListView(),
          ],
        ),
      ),
    );
  }
}
