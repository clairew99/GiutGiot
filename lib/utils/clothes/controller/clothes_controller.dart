import 'package:GIUTGIOT/utils/clothes/dto/clothes_for_date.dart';
import 'package:GIUTGIOT/utils/clothes/clothes_request_manager.dart';
import 'package:GIUTGIOT/utils/clothes/dto/response_select_clothes_dto.dart';
import 'package:get/get.dart';


class ClothesController extends GetxController{
  final currentClothes = <Coordinates?>[].obs;  // 현재 날짜와 관련된 옷 데이터를 객체로 저장
  final selectDayClothes = null.obs;            // 특정 날짜에 선택된 옷 데이터를 저장
  final selectedTopColor = "".obs;              // 선택된 상의 색상을 저장
  final selectedBottomColor = "".obs;           // 선택된 하의 색상을 저장
  final baseDate = DateTime.now().obs;          // 기준 날짜를 저장, 초기값 = 현재 날짜
  final selectedClothes = <ResponseSelectDayClothesDto?>[].obs;


  // getMonthlyClothes(date)를 호출하여 월별 옷 데이터를 가져오고
  // 결과가 null 아니면 currentClothes 변수에 데이터를 저장
  Future<void> getCurrentClothes(DateTime date) async {
    final clothesForMonth = await getMonthlyClothes(date);
    if (clothesForMonth != null){
      currentClothes.value = clothesForMonth.coordinates!;
    }
  }


  //TODO: 추후 추가해야함
  //선택한 날짜의 옷 데이터를 가져옴
  Future<ResponseSelectDayClothesDto?> getSelectDayClothes(DateTime date) async {
    // DTO 객체를 생성하지 않고 날짜만 전달
    final selectedClothes = await saveSelecteddayClothes(date);

    if (selectedClothes != null) {
      // 데이터를 가져온 후 터미널에 출력
      print('상의');
      print('Top Category: ${selectedClothes.topCategory}');
      print('Top Type: ${selectedClothes.topType}');
      print('Top Color: ${selectedClothes.topColor}');
      print('Top Pattern: ${selectedClothes.topPattern}');


      print('하의');
      print('Bottom Category: ${selectedClothes.bottomCategory}');
      print('Bottom Type: ${selectedClothes.bottomType}');
      print('Bottom Color: ${selectedClothes.bottomColor}');
      print('Bottom Pattern: ${selectedClothes.bottomPattern}');
      print('Pose: ${selectedClothes.pose}');


      // 선택한 옷 데이터를 리스트에 추가 (혹은 대체)
      this.selectedClothes.clear(); // 기존 데이터를 지우고
      this.selectedClothes.add(selectedClothes); // 새 데이터를 추가

      // 가져온 데이터 반환
      return selectedClothes;
      
    } else {
      print('No data received for the selected date');
    }
  }




  // 사용자가 모션버튼으로 선택한 상의 색상과 하의 색상
  Future<void> setSelectedClothesColor(String topColor, String bottomColor) async {
    selectedTopColor.value = topColor;
    selectedBottomColor.value = bottomColor;
  }

  // 기준 날짜를 설정
  Future<void> setBaseDate(DateTime date) async {
    baseDate.value = date;
  }


}