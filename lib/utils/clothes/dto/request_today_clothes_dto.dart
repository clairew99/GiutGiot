class RequestTodayClothesDto {
  int? topId;
  int? bottomId;
  String? date;

  RequestTodayClothesDto({this.topId, this.bottomId, this.date});

  RequestTodayClothesDto.fromJson(Map<String, dynamic> json) {
    topId = json['topId'];
    bottomId = json['bottomId'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['topId'] = this.topId;
    data['bottomId'] = this.bottomId;
    data['date'] = this.date;
    return data;
  }
}

// dio 수정이다 이 자식아~