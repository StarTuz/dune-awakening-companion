import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'migrations/migration_001_initial.dart';
import 'migrations/migration_002_add_server_fields.dart';
import 'migrations/migration_003_add_tax_fields.dart';
import 'migrations/migration_004_add_portraits.dart';
import 'migrations/migration_005_add_notification_history.dart';
import 'migrations/migration_006_add_progression_and_quests.dart';
import 'migrations/migration_007_add_base_notification_overrides.dart';
import 'migrations/migration_008_add_quest_reminder.dart';
import 'migrations/migration_009_add_blueprints.dart';
import 'migrations/migration_010_add_blueprint_respawn_timer.dart';
import 'migrations/migration_011_add_class_quests.dart';
import 'migrations/migration_012_add_character_skills.dart';

class AppDatabase {
  static final AppDatabase instance = AppDatabase._internal();
  static Database? _database;

  AppDatabase._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    // Initialize FFI for desktop platforms
    if (Platform.isLinux || Platform.isWindows || Platform.isMacOS) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }

    final dbPath = await _getDatabasePath();
    final db = await openDatabase(
      dbPath,
      version: 12,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
    return db;
  }

  Future<String> _getDatabasePath() async {
    Directory documentsDirectory;

    if (Platform.isAndroid) {
      documentsDirectory = await getApplicationDocumentsDirectory();
    } else if (Platform.isIOS) {
      documentsDirectory = await getApplicationDocumentsDirectory();
    } else {
      // Desktop platforms
      final appDataDir = await getApplicationSupportDirectory();
      documentsDirectory =
          Directory('${appDataDir.path}/dune-awakening-companion');
      if (!await documentsDirectory.exists()) {
        await documentsDirectory.create(recursive: true);
      }
    }

    return join(documentsDirectory.path, 'dune_companion.db');
  }

  Future<void> _onCreate(Database db, int version) async {
    // Run all migrations up to the current version
    await Migration001Initial.up(db);
    if (version >= 2) {
      await Migration002AddServerFields.up(db);
    }
    if (version >= 3) {
      await Migration003AddTaxFields.up(db);
    }
    if (version >= 4) {
      await Migration004AddPortraits.up(db);
    }
    if (version >= 5) {
      await Migration005AddNotificationHistory.up(db);
    }
    if (version >= 6) {
      await Migration006AddProgressionAndQuests.up(db);
    }
    if (version >= 7) {
      await Migration007AddBaseNotificationOverrides.up(db);
    }
    if (version >= 8) {
      await Migration008AddQuestReminder.up(db);
    }
    if (version >= 9) {
      await Migration009AddBlueprints.up(db);
    }
    if (version >= 10) {
      await Migration010AddBlueprintRespawnTimer.up(db);
    }
    if (version >= 11) {
      await Migration011AddClassQuests.up(db);
    }
    if (version >= 12) {
      await Migration012AddCharacterSkills.up(db);
    }
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await Migration002AddServerFields.up(db);
    }
    if (oldVersion < 3) {
      await Migration003AddTaxFields.up(db);
    }
    if (oldVersion < 4) {
      await Migration004AddPortraits.up(db);
    }
    if (oldVersion < 5) {
      await Migration005AddNotificationHistory.up(db);
    }
    if (oldVersion < 6) {
      await Migration006AddProgressionAndQuests.up(db);
    }
    if (oldVersion < 7) {
      await Migration007AddBaseNotificationOverrides.up(db);
    }
    if (oldVersion < 8) {
      await Migration008AddQuestReminder.up(db);
    }
    if (oldVersion < 9) {
      await Migration009AddBlueprints.up(db);
    }
    if (oldVersion < 10) {
      await Migration010AddBlueprintRespawnTimer.up(db);
    }
    if (oldVersion < 11) {
      await Migration011AddClassQuests.up(db);
    }
    if (oldVersion < 12) {
      await Migration012AddCharacterSkills.up(db);
    }
  }

  Future<void> initialize() async {
    await database; // Initialize database
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
    _database = null;
  }

  Future<void> clearAllData() async {
    final db = await database;
    await db.transaction((txn) async {
      await txn.delete('characters');
      await txn.delete('bases');
      await txn.delete('notification_history');
      await txn.delete('character_specializations');
      await txn.delete('faction_progress');
      await txn.delete('augmentations');
      await txn.delete('blueprints');
      await txn.delete('character_class_quest_steps');
      await txn.delete('character_class_quests');
      await txn.delete('quest_steps');
      await txn.delete('quests');
      await txn.delete('character_skills');
    });
  }
}
