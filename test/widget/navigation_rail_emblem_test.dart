import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dune_awakening_companion/core/providers/emblem_provider.dart';
import 'package:dune_awakening_companion/core/services/image_service.dart';
import 'package:dune_awakening_companion/shared/navigation/navigation_rail_emblem.dart';
import 'package:dune_awakening_companion/l10n/app_localizations.dart';

/// 1x1 transparent PNG.
final _tinyPng = base64Decode(
  'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJ'
  'AAAADUlEQVR42mNkYPhfDwAChwGA60e6kgAAAABJRU5ErkJggg==',
);

Widget _build(EmblemState state, {bool extended = true, VoidCallback? onTap}) {
  return ProviderScope(
    overrides: [
      emblemProvider.overrideWith(
        (ref) => EmblemNotifier.forTest(ImageService(), state),
      ),
    ],
    child: MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: NavigationRailEmblem(
          extended: extended,
          onTap: onTap ?? () {},
        ),
      ),
    ),
  );
}

void main() {
  testWidgets('shows the bundled Jerboa by default', (tester) async {
    await tester.pumpWidget(_build(const EmblemState()));
    await tester.pump();

    final image = tester.widget<Image>(find.byType(Image));
    expect(image.image, isA<AssetImage>());
    expect(
      (image.image as AssetImage).assetName,
      NavigationRailEmblem.defaultAsset,
    );
  });

  testWidgets('shows a custom emblem from file when set', (tester) async {
    // Synchronous IO: real async IO never completes under FakeAsync.
    final dir = Directory.systemTemp.createTempSync('emblem_test');
    addTearDown(() => dir.deleteSync(recursive: true));
    final file = File('${dir.path}/custom_emblem.png');
    file.writeAsBytesSync(_tinyPng);

    await tester.pumpWidget(
      _build(EmblemState(customPath: file.path, revision: 1)),
    );
    await tester.pump();

    final image = tester.widget<Image>(find.byType(Image));
    expect(image.image, isA<FileImage>());
    expect((image.image as FileImage).file.path, file.path);
  });

  testWidgets('tapping the emblem fires the callback', (tester) async {
    var tapped = false;
    await tester.pumpWidget(
      _build(const EmblemState(), onTap: () => tapped = true),
    );
    await tester.pump();

    await tester.tap(find.byType(InkWell));
    expect(tapped, isTrue);
  });

  testWidgets('sizes itself for the collapsed rail', (tester) async {
    await tester.pumpWidget(_build(const EmblemState(), extended: false));
    await tester.pump();

    final size = tester.getSize(find.byType(NavigationRailEmblem));
    expect(size.width, 80.0);
  });
}
