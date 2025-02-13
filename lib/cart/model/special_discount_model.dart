class SpecialDiscountOfferModel {
  final String buttonText;
  final String cancelText;
  final String couponName;
  final String discountPercentage;
  final String discountText;
  final bool isVisible;
  final String title;

  SpecialDiscountOfferModel({
    required this.buttonText,
    required this.cancelText,
    required this.couponName,
    required this.discountPercentage,
    required this.discountText,
    required this.isVisible,
    required this.title,
  });

  factory SpecialDiscountOfferModel.fromJson(Map<String, dynamic> map) {
    return SpecialDiscountOfferModel(
      buttonText: map['buttonText'] ?? '',
      cancelText: map['cancelText'] ?? '',
      couponName: map['coupanName'] ?? '',
      discountPercentage: map['discountPercentage'] ?? '',
      discountText: map['discountText'] ?? '',
      isVisible: map['isVisible'] ?? false,
      title: map['title'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'buttonText': buttonText,
      'cancelText': cancelText,
      'coupanName': couponName,
      'discountPercentage': discountPercentage,
      'discountText': discountText,
      'isVisible': isVisible,
      'title': title,
    };
  }
}
