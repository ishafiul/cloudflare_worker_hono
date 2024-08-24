import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:task_craft/core/utils/app_state_collection_isar.dart';

/// The `DB` class represents the database configuration and initialization for Isar.
///
/// This class is annotated with `@singleton` to ensure a single instance throughout the application.
class DB {
  /// The Isar instance for the local database.
  late Future<Isar> local;

  /// The constructor for the [DB] class.
  ///
  /// Initializes the local Isar database by calling the [_open] method.
  DB() {
    local = openDB();
  }

  /// Asynchronous method to open and configure the local Isar database.
  ///
  /// This method retrieves the application documents directory and opens the Isar database
  /// with the specified [AppStateSchema] and directory path.
  Future<Isar> openDB() async {
    final dir = await getApplicationDocumentsDirectory();
    if (Isar.instanceNames.isEmpty) {
      return await Isar.open(
        [
          AppStateSchema,
        ],
        directory: dir.path,
      );
    }

    return Future.value(Isar.getInstance());
  }

  Future<void> closeDB() async {
    final db = await local;
    await db.writeTxn(() => db.clear());
  }
}
