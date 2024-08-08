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
      field: (json['field'] as num?)?.toDouble() ?? 0.0,
      // field가 null인 경우 기본값 0.0 (에러 처리를 위함) - 정진영(24.08.05)
    );
  }
}
