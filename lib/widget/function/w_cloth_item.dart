// cloth_item.dart
class ClothItem {
  final int clothesId;
  final bool isTop;
  final String color;
  final String type;
  final String category;
  final String pattern;
  final double field;

  ClothItem({
    required this.clothesId,
    required this.isTop,
    required this.color,
    required this.type,
    required this.category,
    required this.pattern,
    required this.field,
  });

  factory ClothItem.fromJson(Map<String, dynamic> json) {
    return ClothItem(
      clothesId: json['clothes_id'],
      isTop: json['is_top'],
      color: json['color'],
      type: json['type'],
      category: json['category'],
      pattern: json['pattern'],
      field: (json['Field'] as num).toDouble(), // 대소문자 주의, num을 double로 변환
    );
  }
}
