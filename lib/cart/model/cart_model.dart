class CartItem {

  final String title;
  final String productId;
  final String variant;
  final String variantId;
  final double price;
  final double mrp;
  final String imageSrc;
  final String? collectionId;
  final String? category;
  int quantity;

  CartItem({
    required this.productId,
    required this.title,
    required this.variantId,
    required this.price,
    required this.mrp,
    required this.imageSrc,
    required this.variant,

    this.collectionId,
    this.category,

    this.quantity = 1,
  });

  double get totalMRP => quantity * mrp;
  double get totalPrice => quantity * price;


  Map<String, dynamic> toJson() {
    return {
      'variant_id': variantId.split('/').last,
      'quantity': quantity,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'title': title,
      'variantId': variantId,
      'quantity': quantity,
      'price': price,
      'mrp': mrp,
      'imageSrc': imageSrc,
      'variant': variant,
      'category': category,
      'collectionId': collectionId,
    };
  }

  Map<String, dynamic> toPayload() {

    String prid = productId.split('/').last;
    String vid = variantId.split('/').last;

    return {
      'prid': int.tryParse(prid) ?? prid,
      'title': title,
      'variant_id': int.tryParse(vid) ?? vid,
      'quantity': quantity,
      'price': price,
      'mrp': mrp,
      'imageSrc': imageSrc,
      'variant': variant,
      'category': category,
      'collectionId': int.tryParse(collectionId ?? '') ?? collectionId,
      'brand': "Katyayani Organics",
      'currency': "INR",
    };
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      productId: json['productId'] ?? '',
      title: json['title'] ?? '',
      variantId: json['variantId'] ?? '',
      quantity: json['quantity'] ?? 1,
      price: json['price'] ?? 0.0,
      mrp: json['mrp'] ?? 0.0,
      imageSrc: json['imageSrc'] ?? '',
      variant: json['variant'] ?? '',
      category: json['category'] ?? '',
      collectionId: json['collectionId'] ?? ''
    );
  }


  CartItem copyWith({
    String? productId,
    String? title,
    String? variantId,
    int? quantity,
    double? price,
    double? mrp,
    String? imageSrc,
    String? variant,
    String? collectionId,
    String? category,
  }) {
    return CartItem(
      productId: productId ?? this.productId,
      title: title ?? this.title,
      variantId: variantId ?? this.variantId,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      mrp: mrp ?? this.mrp,
      imageSrc: imageSrc ?? this.imageSrc,
      variant: variant ?? this.variant,
      collectionId: collectionId ?? this.collectionId,
      category: category ?? this.category,
    );
  }
}
