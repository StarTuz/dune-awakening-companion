# Best Practices — Dune Awakening Companion App

These guidelines are enforced by Qodo Merge during PR reviews.
Suggestions that violate these patterns are tagged **Organization best practice**.

---

Pattern 1: All new model fields must be included in copyWith, toJson, fromJson, toMap, and fromMap.

Example code before:
```dart
class Base {
  final String id;
  final String name;
  final int newField; // added

  Base copyWith({String? id, String? name}) { // missing newField
    return Base(id: id ?? this.id, name: name ?? this.name);
  }
}
```

Example code after:
```dart
class Base {
  final String id;
  final String name;
  final int newField;

  Base copyWith({String? id, String? name, int? newField}) {
    return Base(
      id: id ?? this.id,
      name: name ?? this.name,
      newField: newField ?? this.newField,
    );
  }
}
```

---

Pattern 2: All user-facing strings must use AppLocalizations, never hardcoded English.

Example code before:
```dart
Text('No characters yet. Add one to get started.')
```

Example code after:
```dart
Text(AppLocalizations.of(context)!.noCharactersYet)
```

---

Pattern 3: Repository classes must be the only code that directly accesses the database. No raw SQL or db.query calls in providers, screens, or services.

Example code before:
```dart
class BaseNotifier extends StateNotifier<AsyncValue<List<Base>>> {
  Future<void> loadBases() async {
    final db = await AppDatabase.instance.database;
    final maps = await db.query('bases'); // direct DB access in provider
  }
}
```

Example code after:
```dart
class BaseNotifier extends StateNotifier<AsyncValue<List<Base>>> {
  final BaseRepository _repository;
  Future<void> loadBases() async {
    final bases = await _repository.getAll(); // goes through repository
  }
}
```

---

Pattern 4: New features should include at least one unit or widget test. PRs that add new logic without any test coverage should be flagged.

---

Pattern 5: Async operations in providers and services should use try/catch with proper error state handling via AsyncValue.error.

Example code before:
```dart
Future<void> loadData() async {
  state = const AsyncValue.loading();
  final data = await _repository.getAll(); // no error handling
  state = AsyncValue.data(data);
}
```

Example code after:
```dart
Future<void> loadData() async {
  try {
    state = const AsyncValue.loading();
    final data = await _repository.getAll();
    state = AsyncValue.data(data);
  } catch (e, stack) {
    state = AsyncValue.error(e, stack);
  }
}
```

---

Pattern 6: Prefer const constructors for stateless Flutter widgets and widget parameters where possible.

Example code before:
```dart
return SizedBox(height: 16);
```

Example code after:
```dart
return const SizedBox(height: 16);
```
