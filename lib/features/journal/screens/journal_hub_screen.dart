import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:dune_awakening_companion/l10n/app_localizations.dart';

import '../../characters/models/character.dart';
import '../../characters/providers/character_provider.dart';
import '../../quest_journal/screens/quest_journal_screen.dart';
import 'character_journal_tab.dart';

/// Top-level Journal hub: hosts the Quest Journal and the per-character
/// Chronicle side by side, so the Chronicle is two taps from anywhere
/// instead of buried inside the character Progress dialog.
class JournalHubScreen extends StatelessWidget {
  const JournalHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.navJournal),
          bottom: TabBar(
            tabs: [
              Tab(text: l10n.journalQuestsTab),
              Tab(text: l10n.journalTabTitle),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            QuestJournalScreen(showAppBar: false),
            _ChronicleTab(),
          ],
        ),
      ),
    );
  }
}

/// Chronicle tab: a character picker over [CharacterJournalTab], defaulting
/// to the first character so the journal is immediately usable.
class _ChronicleTab extends ConsumerStatefulWidget {
  const _ChronicleTab();

  @override
  ConsumerState<_ChronicleTab> createState() => _ChronicleTabState();
}

class _ChronicleTabState extends ConsumerState<_ChronicleTab> {
  String? _selectedCharacterId;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final charactersAsync = ref.watch(charactersProvider);

    return charactersAsync.when(
      data: (characters) {
        if (characters.isEmpty) {
          return Center(child: Text(l10n.noCharactersMessage));
        }
        final selected = characters.firstWhere(
          (c) => c.id == _selectedCharacterId,
          orElse: () => characters.first,
        );
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: DropdownButtonFormField<String>(
                value: selected.id,
                decoration: InputDecoration(
                  labelText: l10n.journalCharacterLabel,
                  border: const OutlineInputBorder(),
                ),
                items: [
                  for (final Character c in characters)
                    DropdownMenuItem(value: c.id, child: Text(c.name)),
                ],
                onChanged: (value) =>
                    setState(() => _selectedCharacterId = value),
              ),
            ),
            Expanded(
              // Key forces a fresh tab state (search, tag filter) per character.
              child: CharacterJournalTab(
                key: ValueKey(selected.id),
                character: selected,
              ),
            ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('${l10n.error}: $error')),
    );
  }
}
