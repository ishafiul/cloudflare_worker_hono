import 'dart:async';

/// A countdown timer class that provides a stream of countdown values.
class Countdown {
  late StreamController<int> _controller;
  late Timer _timer;
  final int _countdownDuration;

  /// Constructs a [Countdown] instance with the specified countdown duration.
  ///
  /// The [countdownDuration] parameter represents the initial countdown duration
  /// in seconds.
  Countdown(this._countdownDuration);

  /// Gets the countdown stream that emits countdown values.
  ///
  /// The countdown stream emits updated countdown values every second.
  Stream<int> get count {
    return _controller.stream;
  }

  /// Starts the countdown timer and returns the countdown stream.
  ///
  /// The countdown stream emits updated countdown values every second until
  /// it reaches zero. After reaching zero, the stream is closed.
  Stream<int> start() {
    _controller = StreamController<int>();
    int secondsRemaining = _countdownDuration;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      secondsRemaining--;
      _controller.add(secondsRemaining);

      if (secondsRemaining == 0) {
        timer.cancel();
        _controller.close();
      }
    });

    return _controller.stream;
  }

  /// Stops the countdown timer and closes the countdown stream if active.
  ///
  /// If the countdown timer is currently active, this method cancels the timer
  /// and closes the countdown stream.
  void stop() {
    if (_timer.isActive) {
      _timer.cancel();
      _controller.close();
    }
  }
}
