class Cloth {
  final int clothesId;
  final bool isTop;
  final String color;
  final String category;
  final String type;
  final String pattern;
  final int memory;

  Cloth({
    required this.clothesId,
    required this.isTop,
    required this.color,
    required this.category,
    required this.type,
    required this.pattern,
    required this.memory,
  });

  // JSON 데이터를 Cloth 객체로 변환하는 팩토리 생성자
  factory Cloth.fromJson(Map<String, dynamic> json) {
    return Cloth(
      clothesId: json['clothesId'],
      isTop: json['isTop'],
      color: json['color'],
      category: json['category'],
      type: json['type'],
      pattern: json['pattern'],
      memory: json['memory'],
    );
  }
  // 이미지 url 작성 후 저장
  String get clothPath {
    return 'clothes/${isTop ? "top" : "bottom"}_${category}_${type}_${pattern}_${color}.png';
  }
}



