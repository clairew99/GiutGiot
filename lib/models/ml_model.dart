import 'package:tflite_flutter/tflite_flutter.dart';

// 240802 SHJ: 자세모델 탑재 페이지
Future<Interpreter> loadModel(String modelFile) async {
  try {
    Interpreter interpreter = await Interpreter.fromAsset(modelFile);
    print('Model loaded successfully'); // 모델이 성공적으로 로드
    return interpreter;
  } catch (e) {
    print('Failed to load model: $e');
    rethrow;
  }
}

void predict(List<List<double>> array, Interpreter interpreter, int maxIndexCount, Function(int, int) onPrediction) {
  try {
    int threshold = 30;
    for (int i = 0; i < 9; i++) {
      List<double> tArray = [];
      for (int j = 0; j < 128; j++) {
        tArray.add(array[j][i]);
      }
      for (int k = 0; k < 128; k++) {
        array[k][i] = tArray[k];
      }
    }
    List<List<List<double>>> input = [array];
    List<List<double>> output = List.generate(1, (index) => List.generate(4, (index) => 0.0));
    print('Running interpreter...');
    interpreter.run(input, output);
    print('Prediction output: $output'); // 예측 결과를 로그로 출력

    var max = output[0].reduce((current, next) => current > next ? current : next);
    int maxIndex = output[0].indexWhere((element) => element == max) + 1;

    if (maxIndex == 3) {
      maxIndexCount++;
      if (maxIndexCount >= threshold) {
        maxIndex = 4;
      }
    } else {
      maxIndexCount = 0;
    }

    onPrediction(maxIndex, maxIndexCount);
    print('Predicted activity index: $maxIndex, maxIndexCount: $maxIndexCount'); // 예측된 활동 인덱스를 로그로 출력
  } catch (e) {
    print('Prediction failed: $e');
  }
}

String getActivityText(int? maxIndex) {
  if (maxIndex == 1) {
    return 'Walking';
  }
  if (maxIndex == 2) {
    return 'Stationary';
  }
  if (maxIndex == 3) {
    return 'Stationary';
  }
  if (maxIndex == 4) {
    return 'Stationary';
  }
  return 'Unknown';
}
