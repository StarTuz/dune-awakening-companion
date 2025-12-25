import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'migrations/migration_001_initial.dart';
import 'migrations/migration_002_add_server_fields.dart';
import 'migrations/migration_003_add_tax_fields.dart';
import 'migrations/migration_004_add_portraits.dart';
import 'migrations/migration_005_add_notification_history.dart';

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
      version: 5,
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
      documentsDirectory = Directory('${appDataDir.path}/dune-awakening-companion');
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
    });
  }
}
