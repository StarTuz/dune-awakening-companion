import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:dune_awakening_companion/l10n/app_localizations.dart';

import '../models/base_calculator_plan.dart';
import '../models/base_calculator_portable_plan.dart';
import '../models/base_calculator_state.dart';
import '../providers/base_calculator_plan_provider.dart';
import 'base_calculator_share_dialog.dart';

Future<void> copyBaseCalculatorShareCode({
  required BuildContext context,
  required WidgetRef ref,
  required BaseCalculatorPortablePlan portable,
}) async {
  final l10n = AppLocalizations.of(context)!;
  final io = ref.read(baseCalculatorPlanIoServiceProvider);
  final code = io.encodeShareCode(portable);
  await Clipboard.setData(ClipboardData(text: code));
  if (!context.mounted) return;
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(l10n.baseCalculatorShareCodeCopied)),
  );
}

Future<void> exportBaseCalculatorPortableJson({
  required BuildContext context,
  required WidgetRef ref,
  required BaseCalculatorPortablePlan portable,
}) async {
  final l10n = AppLocalizations.of(context)!;
  final io = ref.read(baseCalculatorPlanIoServiceProvider);
  final path = await io.exportPortableJson(portable);
  if (!context.mounted || path == null) return;
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(l10n.baseCalculatorPlanExported)),
  );
}

Future<void> importBaseCalculatorPortableJson({
  required BuildContext context,
  required WidgetRef ref,
}) async {
  final l10n = AppLocalizations.of(context)!;
  final io = ref.read(baseCalculatorPlanIoServiceProvider);
  try {
    final portable = await io.importPortableJson();
    if (!context.mounted || portable == null) return;
    ref.read(baseCalculatorPlanEditorProvider).loadPortablePlan(portable);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.baseCalculatorPlanImported)),
    );
  } on FormatException {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.baseCalculatorShareCodeInvalid)),
    );
  } catch (_) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.baseCalculatorShareCodeInvalid)),
    );
  }
}

BaseCalculatorPortablePlan portableFromState(BaseCalculatorState state) {
  return BaseCalculatorPortablePlan.fromState(state);
}

BaseCalculatorPortablePlan portableFromPlan(BaseCalculatorPlan plan) {
  return BaseCalculatorPortablePlan.fromPlan(plan);
}
