import 'package:archilink/features/settings/presentation/views/widgets/single_action_button.dart';
import 'package:flutter/material.dart';

class RequestActions extends StatelessWidget {
  const RequestActions({
    super.key,
    required this.onAccept,
    required this.onRemove,
  });

  final VoidCallback onAccept;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SingleActionButton(label: 'Accept', onPressed: onAccept, color: Theme.of(context).colorScheme.primary,),
        const SizedBox(width: 6),
        SingleActionButton(label: 'Remove', onPressed: onRemove, color: Theme.of(context).colorScheme.primary.withAlpha(100),),
      ],
    );
  }
}

