import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:dune_awakening_companion/l10n/app_localizations.dart';

import '../providers/base_calculator_plan_provider.dart';
import '../services/base_calculator_plan_io_service.dart';

final baseCalculatorPlanIoServiceProvider =
    Provider<BaseCalculatorPlanIoService>((ref) {
  return BaseCalculatorPlanIoService();
});

Future<bool?> showBaseCalculatorImportShareDialog({
  required BuildContext context,
  required WidgetRef ref,
}) {
  return showDialog<bool>(
    context: context,
    builder: (context) => const _ImportShareDialog(),
  );
}

class _ImportShareDialog extends ConsumerStatefulWidget {
  const _ImportShareDialog();

  @override
  ConsumerState<_ImportShareDialog> createState() => _ImportShareDialogState();
}

class _ImportShareDialogState extends ConsumerState<_ImportShareDialog> {
  final _controller = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _import() {
    final l10n = AppLocalizations.of(context)!;
    final io = ref.read(baseCalculatorPlanIoServiceProvider);
    try {
      final portable = io.decodeShareCode(_controller.text);
      ref.read(baseCalculatorPlanEditorProvider).loadPortablePlan(portable);
      if (!mounted) return;
      Navigator.of(context).pop(true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.baseCalculatorPlanImported)),
      );
    } on FormatException {
      setState(() => _error = l10n.baseCalculatorShareCodeInvalid);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AlertDialog(
      title: Text(l10n.baseCalculatorImportShareCodeTitle),
      content: TextField(
        controller: _controller,
        decoration: InputDecoration(
          labelText: l10n.baseCalculatorImportShareCode,
          hintText: l10n.baseCalculatorImportShareCodeHint,
          errorText: _error,
        ),
        maxLines: 4,
        autofocus: true,
        onChanged: (_) {
          if (_error != null) setState(() => _error = null);
        },
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          onPressed: _import,
          child: Text(l10n.baseCalculatorLoadPlan),
        ),
      ],
    );
  }
}
