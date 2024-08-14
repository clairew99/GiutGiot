class ResponseSelectDayClothesDto {
  int? topId;
  String? topColor;
  String? topCategory;
  String? topType;
  String? topPattern;
  int? bottomId;
  String? bottomColor;
  String? bottomCategory;
  String? bottomType;
  String? bottomPattern;
  String? pose;

  ResponseSelectDayClothesDto(
        {this.topId,
        this.topColor,
        this.topCategory,
        this.topType,
        this.topPattern,
        this.bottomId,
        this.bottomColor,
        this.bottomCategory,
        this.bottomType,
        this.bottomPattern,
        this.pose});

  ResponseSelectDayClothesDto.fromJson(Map<String, dynamic> json) {
    topId = json['topId'];
    topColor = json['topColor'];
    topCategory = json['topCategory'];
    topType = json['topType'];
    topPattern = json['topPattern'];
    bottomId = json['bottomId'];
    bottomColor = json['bottomColor'];
    bottomCategory = json['bottomCategory'];
    bottomType = json['bottomType'];
    bottomPattern = json['bottomPattern'];
    pose = json['pose'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['topId'] = this.topId;
    data['topColor'] = this.topColor;
    data['topCategory'] = this.topCategory;
    data['topType'] = this.topType;
    data['topPattern'] = this.topPattern;
    data['bottomId'] = this.bottomId;
    data['bottomColor'] = this.bottomColor;
    data['bottomCategory'] = this.bottomCategory;
    data['bottomType'] = this.bottomType;
    data['bottomPattern'] = this.bottomPattern;
    data['pose'] = this.pose;
    return data;
  }
}

// dio 수정이다 이 자식아~
