import 'package:archilink/core/utils/app_colors.dart';
import 'package:archilink/features/Edit_Profile/presentation/manager/cubit/edit_profile_cubit.dart';
import 'package:archilink/features/Edit_Profile/presentation/view/widgets/edit_profile_app_bar.dart';
import 'package:archilink/features/Edit_Profile/presentation/view/widgets/edit_profile_popup_field.dart';
import 'package:archilink/features/Edit_Profile/presentation/view/widgets/editable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddContactInfoView extends StatefulWidget {
  const AddContactInfoView({
    super.key,
    this.initialContactInfo,
    this.editIndex,
  });

  static const String name = '/AddContactInfo';
  final ContactInfo? initialContactInfo;
  final int? editIndex;

  @override
  State<AddContactInfoView> createState() => _AddContactInfoViewState();
}

class _AddContactInfoViewState extends State<AddContactInfoView> {
  String selectedPlatform = '';
  late final TextEditingController handleController;
  late final TextEditingController urlController;
  bool _isAutoFilling = false;

  final List<String> platforms = const [
    'Facebook',
    'Instagram',
    'LinkedIn',
    'Email',
    'Phone',
    'other Links',
  ];

  @override
  void initState() {
    final initial = widget.initialContactInfo;
    selectedPlatform = initial?.platform ?? '';
    handleController = TextEditingController(text: initial?.handle ?? '');
    urlController = TextEditingController(text: initial?.url ?? '');
    handleController.addListener(_onAnyFieldChanged);
    urlController.addListener(_onUrlChanged);
    super.initState();
  }

  @override
  void dispose() {
    handleController.removeListener(_onAnyFieldChanged);
    urlController.removeListener(_onUrlChanged);
    handleController.dispose();
    urlController.dispose();
    super.dispose();
  }

  bool get _canSubmit =>
      selectedPlatform.trim().isNotEmpty &&
      handleController.text.trim().isNotEmpty &&
      urlController.text.trim().isNotEmpty;

  void _onAnyFieldChanged() {
    if (!mounted) return;
    setState(() {});
  }

  void _onUrlChanged() {
    if (_isAutoFilling) return;
    final parsed = _parseContactInfo(urlController.text);
    if (parsed != null) {
      var didChange = false;
      if (selectedPlatform.trim().isEmpty) {
        selectedPlatform = parsed.platform;
        didChange = true;
      }
      if (handleController.text.trim().isEmpty) {
        _isAutoFilling = true;
        handleController.text = parsed.handle;
        handleController.selection = TextSelection.collapsed(
          offset: handleController.text.length,
        );
        _isAutoFilling = false;
        didChange = true;
      }
      if (didChange) {
        setState(() {});
        return;
      }
    }
    _onAnyFieldChanged();
  }

  _ParsedContactInfo? _parseContactInfo(String rawInput) {
    final input = rawInput.trim();
    if (input.isEmpty) return null;

    final emailMatch = RegExp(
      r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
    ).firstMatch(input);
    if (emailMatch != null) {
      final handle = input.split('@').first;
      return _ParsedContactInfo(platform: 'Email', handle: handle);
    }

    final phoneMatch = RegExp(
      r'^\+?[0-9][0-9\-\s\(\)]{5,}$',
    ).firstMatch(input);
    if (phoneMatch != null) {
      return _ParsedContactInfo(platform: 'Phone', handle: input);
    }

    final normalized = input.startsWith('http://') ||
            input.startsWith('https://')
        ? input
        : 'https://$input';
    final uri = Uri.tryParse(normalized);
    if (uri == null || uri.host.isEmpty) return null;

    final host = uri.host.toLowerCase().replaceFirst('www.', '');
    final segments =
        uri.pathSegments.where((s) => s.trim().isNotEmpty).toList();

    if (_endsWithHost(host, 'instagram.com')) {
      final handle = _firstSegment(segments);
      if (handle != null) {
        return _ParsedContactInfo(platform: 'Instagram', handle: handle);
      }
    }

    if (_endsWithHost(host, 'facebook.com') || _endsWithHost(host, 'fb.com')) {
      if (segments.isNotEmpty && segments.first == 'profile.php') {
        final id = uri.queryParameters['id'];
        if (id != null && id.trim().isNotEmpty) {
          return _ParsedContactInfo(platform: 'Facebook', handle: id.trim());
        }
      }
      final handle = _firstSegment(segments);
      if (handle != null) {
        return _ParsedContactInfo(platform: 'Facebook', handle: handle);
      }
    }

    if (_endsWithHost(host, 'linkedin.com')) {
      final handle = _linkedInHandle(segments);
      if (handle != null) {
        return _ParsedContactInfo(platform: 'LinkedIn', handle: handle);
      }
    }

    return null;
  }

  bool _endsWithHost(String host, String domain) =>
      host == domain || host.endsWith('.$domain');

  String? _firstSegment(List<String> segments) {
    if (segments.isEmpty) return null;
    final raw = segments.first.trim();
    if (raw.isEmpty) return null;
    return raw.startsWith('@') ? raw.substring(1) : raw;
  }

  String? _linkedInHandle(List<String> segments) {
    if (segments.isEmpty) return null;
    final inIndex = segments.indexOf('in');
    if (inIndex != -1 && segments.length > inIndex + 1) {
      return segments[inIndex + 1];
    }
    final companyIndex = segments.indexOf('company');
    if (companyIndex != -1 && segments.length > companyIndex + 1) {
      return segments[companyIndex + 1];
    }
    return _firstSegment(segments);
  }

  void _onDone() {
    final info = ContactInfo(
      handle: handleController.text.trim(),
      platform: selectedPlatform.trim(),
      url: urlController.text.trim(),
    );
    final cubit = context.read<EditProfileCubit>();
    final index = widget.editIndex;
    if (index != null) {
      cubit.updateContactInfo(index, info);
    } else {
      cubit.addContactInfo(info);
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            EditProfileAppBar(
              titel: 'Add contact info',
              withDoneButton: true,
              canSubmitOverride: _canSubmit,
              onDone: _canSubmit ? _onDone : null,
            ),
            Padding(
              padding: const EdgeInsetsGeometry.symmetric(horizontal: 20),
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColorsFromTheme.editProfileContainer(context),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    EditProfilePopupField(
                      title: 'Platform',
                      value: selectedPlatform,
                      items: platforms,
                      onSelected: (item) {
                        setState(() {
                          selectedPlatform = item;
                        });
                      },
                    ),
                    Divider(height: 1),
                    EditProfileTextField(
                      title: 'Handle',
                      initialValue: handleController.text,
                      controller: handleController,
                      hintText: 'Enter your username',
                    ),
                    Divider(height: 1),
                    EditProfileTextField(
                      title: 'Url',
                      initialValue: urlController.text,
                      controller: urlController,
                      hintText: 'Enter your account Url ',
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

class _ParsedContactInfo {
  const _ParsedContactInfo({
    required this.platform,
    required this.handle,
  });

  final String platform;
  final String handle;
}
