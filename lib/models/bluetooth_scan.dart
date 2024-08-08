import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'dart:async';
import 'dart:io' show Platform;

class DeviceModel {
  BluetoothDevice device;
  String name;
  DeviceIdentifier id;
  bool isConnected;
  bool isPhone;
  String modelNumber;

  DeviceModel({
    required this.device,
    required this.name,
    required this.id,
    required this.isConnected,
    required this.isPhone,
    required this.modelNumber,
  });

  factory DeviceModel.fromScanResult(ScanResult result) {
    String deviceName = result.device.name.isEmpty ? result.advertisementData.localName : result.device.name;
    deviceName = deviceName.isEmpty ? "Unknown" : deviceName;

    return DeviceModel(
      device: result.device,
      name: deviceName,
      id: result.device.id,
      isConnected: false,
      isPhone: false,  // 초기값은 false, 나중에 확인
      modelNumber: "Unknown",  // 초기값, 나중에 읽어옴
    );
  }

  String get idString => id.toString();

  @override
  String toString() {
    return 'DeviceModel{name: $name, id: $idString, isConnected: $isConnected, isPhone: $isPhone, modelNumber: $modelNumber}';
  }
}

class BluetoothScanner {
  final List<DeviceModel> scannedDevices = [];
  StreamSubscription<List<ScanResult>>? _scanSubscription;
  Timer? _scanTimer;
  bool _isInitialized = false;
  bool _isScanning = false;

  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      await _enableBluetooth();
      _isInitialized = true;
    } catch (e) {
      print('Failed to initialize Bluetooth: $e');
    }
  }

  Future<void> _enableBluetooth() async {
    if (await FlutterBluePlus.adapterState.first == BluetoothAdapterState.off) {
      if (Platform.isAndroid) {
        try {
          await FlutterBluePlus.turnOn();
        } catch (e) {
          print('Failed to turn on Bluetooth: $e');
          rethrow;
        }
      } else {
        print('Please turn on Bluetooth manually');
        throw Exception('Bluetooth is off and cannot be turned on automatically on this platform');
      }
    }
    await FlutterBluePlus.adapterState.where((state) => state == BluetoothAdapterState.on).first;
  }

  Future<void> startScanning() async {
    if (!_isInitialized) {
      await initialize();
    }
    if (!_isScanning) {
      _scanTimer = Timer.periodic(Duration(seconds: 10), (_) => _performScan());
      _isScanning = true;
    }
  }

  Future<void> _performScan() async {
    if (await FlutterBluePlus.isScanning.first) {
      print('Already scanning');
      return;
    }

    print('Starting scan');

    try {
      _scanSubscription = FlutterBluePlus.onScanResults.listen(
            (results) async {
          for (ScanResult r in results) {
            DeviceModel deviceModel = DeviceModel.fromScanResult(r);
            if (!scannedDevices.any((device) => device.id == deviceModel.id)) {
              try {
                await _readDeviceInfo(deviceModel);
                scannedDevices.add(deviceModel);
                print(deviceModel);
              } catch (e) {
                print('Failed to read device info: ${deviceModel.name} (${deviceModel.id}): $e');
              }
            }
          }
        },
        onError: (e) => print('Error during scan: $e'),
      );

      FlutterBluePlus.cancelWhenScanComplete(_scanSubscription!);

      await FlutterBluePlus.startScan(timeout: Duration(seconds: 4));
      await FlutterBluePlus.isScanning.where((val) => val == false).first;

      print('Scan complete. Devices found: ${scannedDevices.length}');
      for (var device in scannedDevices) {
        print(device.toString());
      }
    } catch (e) {
      print('Error during Bluetooth scan: $e');
    }
  }

  Future<void> _readDeviceInfo(DeviceModel deviceModel) async {
    try {
      await deviceModel.device.connect();
      List<BluetoothService> services = await deviceModel.device.discoverServices();
      for (BluetoothService service in services) {
        if (service.uuid == Guid('0000180a-0000-1000-8000-00805f9b34fb')) {
          for (BluetoothCharacteristic c in service.characteristics) {
            if (c.uuid == Guid('00002a24-0000-1000-8000-00805f9b34fb')) {
              List<int> value = await c.read();
              deviceModel.modelNumber = String.fromCharCodes(value);
              deviceModel.isPhone = _isPhone(deviceModel.modelNumber);
              break;
            }
          }
        }
      }
    } finally {
      await deviceModel.device.disconnect();
    }
  }

  bool _isPhone(String modelNumber) {
    const phonePatterns = [
      "iPhone", // Apple
      "Galaxy", // Samsung
      // 필요에 따라 다른 제조사의 패턴을 추가할 수 있습니다.
    ];
    for (var pattern in phonePatterns) {
      if (modelNumber.contains(pattern)) {
        return true;
      }
    }
    return false;
  }

  void stopScanning() {
    _scanTimer?.cancel();
    _scanTimer = null;
    FlutterBluePlus.stopScan();
    _isScanning = false;
  }

  List<DeviceModel> getPhoneDevices() {
    return scannedDevices.where((device) => device.isPhone).toList();
  }

  List<String> getPhoneDeviceIds() {
    return getPhoneDevices().map((device) => device.idString).toList();
  }
}

// 사용 예시
void main() async {
  BluetoothScanner scanner = BluetoothScanner();
  await scanner.startScanning();

  // 스캔이 완료될 때까지 대기
  await Future.delayed(Duration(seconds: 15));

  List<DeviceModel> phoneDevices = scanner.getPhoneDevices();
  List<String> phoneDeviceIds = scanner.getPhoneDeviceIds();

  print('Found phone devices:');
  for (var device in phoneDevices) {
    print('Name: ${device.name}, ID: ${device.idString}, Model: ${device.modelNumber}');
  }

  scanner.stopScanning();
}