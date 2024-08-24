import 'package:isar/isar.dart';

part 'app_state_collection_isar.g.dart';

/// The `AppState` class represents a collection in the Isar database for managing application state.
///
/// This class is annotated with `@collection` and is part of the Isar database.
@Collection()
class AppState {
  /// The unique identifier for the app state.
  Id id = Isar.autoIncrement;

  /// The user associated with the app state.
  User? user;
}

/// The `User` class represents an embedded model within the `AppState` collection.
///
/// This class is annotated with `@embedded`.
@embedded
class User {
  /// The unique identifier for the user.
  String? id;

  /// The access token associated with the user.
  String? accessToken;

  /// The refresh token associated with the user.
  String? deviceUuid;
}
