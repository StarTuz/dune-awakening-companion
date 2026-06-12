import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers/emblem_provider.dart';

import 'package:dune_awakening_companion/l10n/app_localizations.dart';

/// App emblem shown at the top of the desktop navigation rail.
///
/// Displays the user's custom emblem when one is set, otherwise the bundled
/// Jerboa mark. Tapping it navigates home (dashboard).
class NavigationRailEmblem extends ConsumerWidget {
  const NavigationRailEmblem({
    super.key,
    required this.extended,
    required this.onTap,
  });

  final bool extended;
  final VoidCallback onTap;

  /// Keep in sync with NavigationRailFooter: the rail passes unbounded width
  /// constraints to leading/trailing widgets, so the emblem sizes itself.
  static const _extendedWidth = 200.0;
  static const _collapsedWidth = 80.0;

  static const _extendedEmblemSize = 72.0;
  static const _collapsedEmblemSize = 40.0;

  static const defaultAsset = 'assets/emblem/jerboa.png';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final emblem = ref.watch(emblemProvider);
    final size = extended ? _extendedEmblemSize : _collapsedEmblemSize;

    final Widget image = emblem.isCustom
        ? Image.file(
            File(emblem.customPath!),
            key: ValueKey('emblem-custom-${emblem.revision}'),
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) =>
                Image.asset(defaultAsset, fit: BoxFit.contain),
          )
        : Image.asset(defaultAsset, fit: BoxFit.contain);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      width: extended ? _extendedWidth : _collapsedWidth,
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Tooltip(
        message: l10n.navDashboard,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              height: size,
              alignment: Alignment.center,
              child: image,
            ),
          ),
        ),
      ),
    );
  }
}
