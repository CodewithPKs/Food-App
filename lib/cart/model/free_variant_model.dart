class FreeVariantModel {
  final String freeProductTitle;
  final String freeVariantTitle;
  final String freeVariantId;
  final String freeVariantQuantity;
  final String freeVariantPrice;
  final String freeVariantImage;

  FreeVariantModel({
    required this.freeProductTitle,
    required this.freeVariantTitle,
    required this.freeVariantId,
    required this.freeVariantQuantity,
    required this.freeVariantPrice,
    required this.freeVariantImage
  });

  factory FreeVariantModel.fromJson(Map<String, dynamic> map) {
    return FreeVariantModel(
      freeProductTitle: map['freeProductTitle'] != null ? map['freeProductTitle'].toString() : '',
      freeVariantTitle: map['freeVarientTitle'] != null ? map['freeVarientTitle'].toString() : '',
      freeVariantId: map['freeVariantId'] != null ? map['freeVariantId'].toString() : '',
      freeVariantQuantity: map['freeVariantQuantity'] != null ? map['freeVariantQuantity'].toString() : '',
      freeVariantPrice: map['freeVariantPrice'] != null ? map['freeVariantPrice'].toString() : '',
      freeVariantImage: map['freeVariantImage'] != null ? map['freeVariantImage'].toString() : '',
    );
  }
}
