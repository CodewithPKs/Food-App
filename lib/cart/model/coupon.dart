class Coupon {
  final String title;
  final String descrition;
  final double minimumAmount;
  final double discountPercentage;
  final double discountAmount;
  final int count;

  Coupon({
    required this.title,
    required this.descrition,
    required this.minimumAmount,
    required this.discountPercentage,
    required this.discountAmount,
    required this.count
  });

  Coupon copyWith({
    String? title,
    String? descrition,
    double? minimumAmount,
    double? discountPercentage,
    double? discountAmount,
    int? count,
  }) {
    return Coupon(
      title: title ?? this.title,
      descrition: descrition ?? this.descrition,
      minimumAmount: minimumAmount ?? this.minimumAmount,
      discountPercentage: discountPercentage ?? this.discountPercentage,
      discountAmount: discountAmount ?? this.discountAmount,
      count: count ?? this.count,
    );
  }
}
