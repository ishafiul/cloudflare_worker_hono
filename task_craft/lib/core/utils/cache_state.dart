/// A simple cache for storing and managing the state of BLoC instances.
class BlocStateCache {
  /// The maximum number of BLoC states the cache can hold.
  final int capacity;
  final _cache = <Type, dynamic>{};

  /// Constructs a [BlocStateCache] with an optional [capacity] parameter.
  ///
  /// The [capacity] determines the maximum number of BLoC states the cache can hold.
  BlocStateCache({this.capacity = 1});

  /// Stores the provided [state] in the cache.
  ///
  /// If the cache already contains the state, it is removed and then added again
  /// to mark it as the most recently used item.
  void store<T>(T state) {
    if (_cache.containsKey(T)) {
      _cache.remove(T);
    }

    // If the cache is over capacity, remove the least recently used item
    if (_cache.length >= capacity) {
      _cache.remove(_cache.keys.first);
    }

    _cache[T] = state;
  }

  /// Retrieves and returns the most recently accessed state of type [T].
  ///
  /// If the state exists in the cache, it is removed and then re-inserted,
  /// marking it as the most recently accessed.
  T? retrieve<T>() {
    final state = _cache.remove(T);
    if (state != null) {
      _cache[T] = state;
    }
    return state as T?;
  }

  /// Clears the cache entry for the specified state type [T].
  void clear<T>() {
    _cache.remove(T);
  }

  /// Clears all entries in the cache.
  void clearAll() {
    _cache.clear();
  }
}
