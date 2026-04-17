import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StepTrackingService {
  static const String _lastRawSensorStepsKey = 'last_raw_sensor_steps';

  final StreamController<int> _stepDeltaController =
      StreamController<int>.broadcast();

  StreamSubscription<StepCount>? _stepCountSubscription;
  SharedPreferences? _prefs;

  Stream<int> get stepDeltaStream => _stepDeltaController.stream;

  Future<void> start() async {
    _prefs ??= await SharedPreferences.getInstance();

    if (_stepCountSubscription != null) {
      return;
    }

    final granted = await _ensurePermissions();
    if (!granted) {
      debugPrint('Step tracking permission not granted.');
      return;
    }

    _stepCountSubscription = Pedometer.stepCountStream.listen(
      _handleStepCount,
      onError: (Object error) {
        debugPrint('Step tracking error: $error');
      },
      cancelOnError: false,
    );
  }

  Future<bool> _ensurePermissions() async {
    if (kIsWeb) {
      return false;
    }

    if (Platform.isAndroid) {
      final status = await Permission.activityRecognition.request();
      return status.isGranted;
    }

    // On iOS, accessing Core Motion data will trigger the system prompt
    // as long as NSMotionUsageDescription is present in Info.plist.
    return true;
  }

  Future<void> _handleStepCount(StepCount event) async {
    final prefs = _prefs ??= await SharedPreferences.getInstance();
    final rawSteps = event.steps;
    final lastRawSteps = prefs.getInt(_lastRawSensorStepsKey);

    // First reading: establish a baseline so we don't award all historical
    // steps since boot to the game.
    if (lastRawSteps == null) {
      await prefs.setInt(_lastRawSensorStepsKey, rawSteps);
      return;
    }

    // Device reboot or sensor reset: move the baseline forward without adding
    // a negative delta.
    if (rawSteps < lastRawSteps) {
      await prefs.setInt(_lastRawSensorStepsKey, rawSteps);
      return;
    }

    final delta = rawSteps - lastRawSteps;

    if (delta > 0) {
      _stepDeltaController.add(delta);
    }

    await prefs.setInt(_lastRawSensorStepsKey, rawSteps);
  }

  void dispose() {
    _stepCountSubscription?.cancel();
    _stepCountSubscription = null;
    _stepDeltaController.close();
  }
}
