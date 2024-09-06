import 'package:task_craft/core/utils/app_state_collection_isar.dart';

/// The `IAppStateService` interface defines methods for managing application state.
abstract class IAppStateService {
  /// Retrieves the user access token from the local storage.
  Future<String?> getUserAccessToken();

  /// Retrieves the user refresh token from the local storage.
  Future<String?> getUserRefreshToken();

  /// Retrieves the user ID from the local storage.
  Future<String?> getUserID();

  /// Updates the user access token in the local storage.
  Future<void> updateUserID(String accessToken);

  /// Clears all stored data in the local storage.
  Future<void> clearAll();

  /// Updates the user access token in the local storage.
  Future<void> updateAccessToken(String accessToken);

  /// Initializes the local database with the provided [user] and returns the [AppState].
  Future<AppState?> initLocalDbUser(User user);

  /// Checks if the user is logged in.
  Future<bool> isLoggedIn();

  /// Updates the user refresh token in the local storage.
  Future<void> updateDeviceUuid(String accessToken);

  Future<bool> isDbInitialized();
}
