import 'package:archilink/core/utils/app_colors.dart';
import 'package:archilink/core/utils/app_text_style.dart';
import 'package:archilink/features/Edit_Profile/presentation/manager/cubit/edit_profile_cubit.dart';
import 'package:archilink/features/Edit_Profile/presentation/view/widgets/edit_profile_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LocationView extends StatefulWidget {
  const LocationView({super.key});
  static const String name = '/LocationView';

  @override
  State<LocationView> createState() => _LocationViewState();
}

class _LocationViewState extends State<LocationView> {
  late final TextEditingController countryController;
  late final TextEditingController cityController;
  late final FocusNode countryFocusNode;
  late final FocusNode cityFocusNode;

  @override
  void initState() {
    super.initState();
    final state = context.read<EditProfileCubit>().state;
    final parts = _splitLocation(state.location);
    countryController = TextEditingController(
      text: parts.country.isEmpty ? 'Syria' : parts.country,
    );
    cityController = TextEditingController(text: parts.city);
    countryFocusNode = FocusNode()..addListener(() => setState(() {}));
    cityFocusNode = FocusNode()..addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    countryFocusNode.dispose();
    cityFocusNode.dispose();
    countryController.dispose();
    cityController.dispose();
    super.dispose();
  }

  void _syncLocation(EditProfileCubit cubit) {
    cubit.updateLocation(
      _buildLocation(cityController.text, countryController.text),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<EditProfileCubit>();
    return Scaffold(
      body: SafeArea(
        child: BlocListener<EditProfileCubit, EditProfileState>(
          listenWhen: (prev, next) => prev.location != next.location,
          listener: (context, state) {
            final parts = _splitLocation(state.location);
            if (cityController.text != parts.city) {
              cityController.text = parts.city;
            }
            if (countryController.text != parts.country) {
              countryController.text = parts.country;
            }
          },
          child: Column(
            children: [
              EditProfileAppBar(
                titel: 'Location',
                withDoneButton: true,
                onDone: () {
                  _syncLocation(cubit);
                  Navigator.pop(context);
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        focusNode: countryFocusNode,
                        onTapOutside: (event) => countryFocusNode.unfocus(),
                        controller: countryController,
                        style: AppTextStyle.interRegular14.copyWith(
                          color: countryFocusNode.hasFocus
                              ? Theme.of(context).colorScheme.onSurface
                              : AppColorsFromTheme.grayForText(context),
                        ),
                        textInputAction: TextInputAction.next,
                        onSubmitted: (_) => cityFocusNode.requestFocus(),
                        onChanged: (_) => _syncLocation(cubit),
                        decoration: InputDecoration(
                          hintText: 'Country',
                          hintStyle: AppTextStyle.interRegular14.copyWith(
                            color: AppColorsFromTheme.grayForText(context),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 16,
                          ),
                          filled: true,
                          fillColor:
                              AppColorsFromTheme.editProfileContainer(context),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        focusNode: cityFocusNode,
                        onTapOutside: (event) => cityFocusNode.unfocus(),
                        controller: cityController,
                        style: AppTextStyle.interRegular14.copyWith(
                          color: cityFocusNode.hasFocus
                              ? Theme.of(context).colorScheme.onSurface
                              : AppColorsFromTheme.grayForText(context),
                        ),
                        textInputAction: TextInputAction.done,
                        onChanged: (_) => _syncLocation(cubit),
                        decoration: InputDecoration(
                          hintText: 'City',
                          hintStyle: AppTextStyle.interRegular14.copyWith(
                            color: AppColorsFromTheme.grayForText(context),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 16,
                          ),
                          filled: true,
                          fillColor:
                              AppColorsFromTheme.editProfileContainer(context),
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
            ],
          ),
        ),
      ),
    );
  }

  _LocationParts _splitLocation(String value) {
    final cleaned = value.trim();
    if (cleaned.isEmpty) return const _LocationParts();
    final parts = cleaned.split(',');
    if (parts.length >= 2) {
      return _LocationParts(
        city: parts[0].trim(),
        country: parts.sublist(1).join(',').trim(),
      );
    }
    return _LocationParts(city: cleaned, country: '');
  }

  String _buildLocation(String city, String country) {
    final parts = <String>[];
    if (city.trim().isNotEmpty) {
      parts.add(city.trim());
    }
    if (country.trim().isNotEmpty) {
      parts.add(country.trim());
    }
    return parts.join(', ');
  }
}

class _LocationParts {
  const _LocationParts({this.city = '', this.country = ''});

  final String city;
  final String country;
}
