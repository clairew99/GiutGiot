import 'package:sensors/sensors.dart';
import 'dart:async';
// 240802 SHJ: 센서데이터 전처리
void initializeSensors(List<StreamSubscription<dynamic>> streamSubscriptions, Function(List<double>?, List<double>?, List<double>?) onData) {
  streamSubscriptions.add(accelerometerEvents.listen((AccelerometerEvent event) {
    onData(<double>[event.x, event.y, event.z], null, null);
  }));
  streamSubscriptions.add(gyroscopeEvents.listen((GyroscopeEvent event) {
    onData(null, <double>[event.x, event.y, event.z], null);
  }));
  streamSubscriptions.add(userAccelerometerEvents.listen((UserAccelerometerEvent event) {
    onData(null, null, <double>[event.x, event.y, event.z]);
  }));
}

void addToArrayState(List<double>? accelerometerValues, List<double>? gyroscopeValues, List<double>? userAccelerometerValues, List<List<double>> array, Function onUpdate) {
  if (accelerometerValues != null && gyroscopeValues != null && userAccelerometerValues != null) {
    array.add([
      accelerometerValues[0], accelerometerValues[1], accelerometerValues[2],
      gyroscopeValues[0], gyroscopeValues[1], gyroscopeValues[2],
      userAccelerometerValues[0], userAccelerometerValues[1], userAccelerometerValues[2]
    ]);
    onUpdate();
  }
}

void startRecordingTimer(List<List<double>> array, Function addToArray, Function predict, Function onUpdate, Timer? timer) {
  timer = Timer.periodic(Duration(milliseconds: 20), (timer) {
    if (array.length < 128) {
      addToArray();
    }
    if (array.length == 128) {
      timer.cancel();
      predict();
      array.clear();
      startRecordingTimer(array, addToArray, predict, onUpdate, timer);
    }
    onUpdate();
  });
}
