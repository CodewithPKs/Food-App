class FreeProductModel {

  final bool active;
  final int comparePrice;
  final String dialogHeading;
  final String dialogTitle;
  final String heading;
  final String id;
  final String recommendPrompt;
  final String recommendPrompt2;
  final String title;

  FreeProductModel({
    required this.active,
    required this.comparePrice,
    required this.dialogHeading,
    required this.dialogTitle,
    required this.heading,
    required this.id,
    required this.recommendPrompt,
    required this.recommendPrompt2,
    required this.title,
  });

  factory FreeProductModel.fromJson(Map<String, dynamic> map) {
    return FreeProductModel(
      active: map['active'] ?? false,
      comparePrice: map['comparePrice'] ?? 0,
      dialogHeading: map['dialogHeading'] ?? '',
      dialogTitle: map['dialogTitle'] ?? '',
      heading: map['heading'] ?? '',
      id: map['id'] ?? '',
      recommendPrompt: map['recommendPrompt'] ?? '',
      recommendPrompt2: map['recommendPrompt2'] ?? '',
      title: map['title'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'active': active,
      'comparePrice': comparePrice,
      'dialogHeading': dialogHeading,
      'dialogTitle': dialogTitle,
      'heading': heading,
      'id': id,
      'recommendPrompt': recommendPrompt,
      'recommendPrompt2': recommendPrompt2,
      'title': title,
    };
  }
}
