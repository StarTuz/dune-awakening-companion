import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/quest_provider.dart';

/// Processes due quest reminders when the app starts or returns to foreground.
class QuestReminderLifecycle extends ConsumerStatefulWidget {
  const QuestReminderLifecycle({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<QuestReminderLifecycle> createState() =>
      _QuestReminderLifecycleState();
}

class _QuestReminderLifecycleState extends ConsumerState<QuestReminderLifecycle>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) => _process());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _process();
    }
  }

  Future<void> _process() async {
    final repo = ref.read(questRepositoryProvider);
    final svc = ref.read(questReminderServiceProvider);
    await svc.processDueReminders(repo);
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
