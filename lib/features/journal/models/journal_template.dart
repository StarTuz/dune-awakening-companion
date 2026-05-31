import '../../../l10n/app_localizations.dart';

/// A starter scaffold for a new journal entry. Templates pre-fill the editor
/// with a localized title, Markdown body and tags; the user can edit freely.
/// See `docs/RESEARCH_RPG_JOURNAL_NOTES.md` (Phase 4).
class JournalTemplate {
  const JournalTemplate({
    required this.label,
    required this.title,
    required this.body,
    this.tags = const [],
  });

  final String label;
  final String title;
  final String body;
  final List<String> tags;

  /// All built-in templates, localized for the current context.
  static List<JournalTemplate> all(AppLocalizations l10n) => [
        JournalTemplate(
          label: l10n.journalTemplateSessionLog,
          title: l10n.journalTemplateSessionLog,
          body: l10n.journalTemplateSessionBody,
          tags: const ['session'],
        ),
        JournalTemplate(
          label: l10n.journalTemplateLoreNote,
          title: l10n.journalTemplateLoreNote,
          body: l10n.journalTemplateLoreBody,
          tags: const ['lore'],
        ),
        JournalTemplate(
          label: l10n.journalTemplateCharacterArc,
          title: l10n.journalTemplateCharacterArc,
          body: l10n.journalTemplateArcBody,
          tags: const ['arc'],
        ),
      ];
}
