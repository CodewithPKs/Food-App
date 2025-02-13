

import 'package:untitled/Product/model/variant_model.dart';

class Product {

  final String productId;
  final String productName;
  final String productDescription;
  final String price;
  final String mrp;
  final String imageSrc;

  final List<String> images;
  final List<VariantModel> variants;

  final String collectionId;
  final String category;

  Product({
    required this.productId,
    required this.productName,
    required this.productDescription,
    required this.price,
    required this.mrp,
    required this.imageSrc,
    required this.images,
    required this.variants,
    required this.collectionId,
    required this.category,
  });

  factory Product.fromJson(Map<String, dynamic> json) {

    final List<String> imageUrls = json['images'].map<String>((image) => image.toString()).toList();

    final List<VariantModel> variants = json['variants'].map<VariantModel>((variant) {
      return VariantModel(
        id: variant['id'] ?? '',
        title: variant['title'] ?? '',
        price: variant['price'] ?? '',
        compareAtPrice: variant['compareAtPrice'] ?? '',
        inventoryQuantity: variant['inventoryQuantity'] ?? '',
      );
    }).toList();

    Product product = Product(
      productId: json['id'] ?? '',
      productName: json['title'] ?? '',
      productDescription: '',
      price: json['price'] ?? '',
      mrp: json['costAtPrice'] ?? '',
      imageSrc: imageUrls.first,
      images: imageUrls,
      variants: variants,
      collectionId: json['collectionId'] ?? '',
      category: json['category'] ?? '',
    );

    return product;
  }



  Product copyWith({
    String? productId,
    String? productName,
    String? productDescription,
    String? price,
    String? mrp,
    String? imageSrc,
    List<String>? images,
    List<VariantModel>? variants,
    String? collectionId,
    String? category,
  }) {
    return Product(
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      productDescription: productDescription ?? this.productDescription,
      price: price ?? this.price,
      mrp: mrp ?? this.mrp,
      imageSrc: imageSrc ?? this.imageSrc,
      images: images ?? this.images,
      variants: variants ?? this.variants,
      collectionId: collectionId ?? this.collectionId,
      category: category ?? this.category,
    );
  }
}
