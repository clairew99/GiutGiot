class RequestClothesDto {
  bool? isTop;
  String? color;
  String? type;
  String? category;
  String? pattern;

  RequestClothesDto(
      {this.isTop, this.color, this.type, this.category, this.pattern});

  RequestClothesDto.fromJson(Map<String, dynamic> json) {
    isTop = json['isTop'];
    color = json['color'];
    type = json['type'];
    category = json['category'];
    pattern = json['pattern'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isTop'] = this.isTop;
    data['color'] = this.color;
    data['type'] = this.type;
    data['category'] = this.category;
    data['pattern'] = this.pattern;
    return data;
  }
}

// dio 수정이다 이 자식아~
