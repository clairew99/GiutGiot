class ClothesForMonth {
  List<Coordinates>? coordinates;
  String? startOfWeek;
  String? endOfTwoWeeks;

  ClothesForMonth({this.coordinates, this.startOfWeek, this.endOfTwoWeeks});

  ClothesForMonth.fromJson(Map<String, dynamic> json) {
    if (json['coordinates'] != null) {
      coordinates = <Coordinates>[];
      json['coordinates'].forEach((v) {
        coordinates!.add(new Coordinates.fromJson(v));
      });
    }
    startOfWeek = json['startOfWeek'];
    endOfTwoWeeks = json['endOfTwoWeeks'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.coordinates != null) {
      data['coordinates'] = this.coordinates!.map((v) => v.toJson()).toList();
    }
    data['startOfWeek'] = this.startOfWeek;
    data['endOfTwoWeeks'] = this.endOfTwoWeeks;
    return data;
  }
}

class Coordinates {
  String? topColor;
  String? bottomColor;
  String? date;
  String? pose;

  Coordinates({this.topColor, this.bottomColor, this.date, this.pose});

  Coordinates.fromJson(Map<String, dynamic> json) {
    topColor = json['topColor'];
    bottomColor = json['bottomColor'];
    date = json['date'];
    pose = json['pose'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['topColor'] = this.topColor;
    data['bottomColor'] = this.bottomColor;
    data['date'] = this.date;
    data['pose'] = this.pose;
    return data;
  }
}

// dio 수정이다 이 자식아~