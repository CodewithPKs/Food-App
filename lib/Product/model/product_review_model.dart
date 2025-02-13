import 'dart:io';

class ProductReviewModel {
  final String productId;
  final String productName;

  final String variantId;
  final String variantName;

  final String productImage;

  final List<Reviews> reviews;

  ProductReviewModel({
    required this.productId,
    required this.productName,
    required this.variantId,
    required this.variantName,
    required this.productImage,
    required this.reviews,
  });

  factory ProductReviewModel.fromJson(Map<String, dynamic> json) {
    return ProductReviewModel(
      productId: json['productId'] ?? '',
      productName: json['productName'] ?? '',
      variantId: json['variantId'] ?? '',
      variantName: json['variantName'] ?? '',
      productImage: json['productImage'] ?? '',
      reviews: (json['reviews'] as List<dynamic>? ?? [])
          .map((reviewJson) => Reviews.fromJson(reviewJson))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'productName': productName,
      'variantId': variantId,
      'variantName': variantName,
      'productImage': productImage,
      'reviews': reviews.map((review) => review.toJson()).toList(),
    };
  }

  ProductReviewModel copyWith({
    String? productId,
    String? productName,
    String? variantId,
    String? variantName,
    String? productImage,
    List<Reviews>? reviews,
  }) {
    return ProductReviewModel(
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      variantId: variantId ?? this.variantId,
      variantName: variantName ?? this.variantName,
      productImage: productImage ?? this.productImage,
      reviews: reviews ?? this.reviews,
    );
  }
}

class Reviews {

  final String id;
  final String userId;
  final String username;
  final String userProfileImage;
  final String contact;
  final String review;
  final String rating;
  final List<String> reviewImage;
  List<File>? localImages;
  final int timestamp;
  final bool isApproved;

  Reviews({
    required this.id,
    required this.userId,
    required this.username,
    required this.userProfileImage,
    required this.contact,
    required this.review,
    required this.rating,
    required this.reviewImage,
    this.localImages,
    required this.timestamp,
    required this.isApproved,
  });

  factory Reviews.fromJson(Map<String, dynamic> json) {
    return Reviews(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      username: json['username'] ?? '',
      userProfileImage: json['userProfileImage'] ?? '',
      contact: json['contact'] ?? '',
      review: json['review'] ?? '',
      rating: json['rating'] ?? '',
      reviewImage: json['reviewImage'] == null || json['reviewImage'] == '-1' ? [] :
      (json['reviewImage'] as List<dynamic>)
          .map((url) => url.toString())
          .toList(),
      timestamp: json['timestamp'] ?? 0,
      isApproved: json['isApproved'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'username': username,
      'userProfileImage': userProfileImage,
      'contact': contact,
      'review': review,
      'rating': rating,
      'reviewImage': reviewImage,
      'timestamp': timestamp,
      'isApproved': isApproved,
    };
  }

  Reviews copyWith({
    String? id,
    String? userId,
    String? username,
    String? userProfileImage,
    String? contact,
    String? review,
    String? rating,
    List<String>? reviewImage,
    int? timestamp,
    bool? isApproved,
    List<File>? localImages,
  }) {
    return Reviews(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      username: username ?? this.username,
      userProfileImage: userProfileImage ?? this.userProfileImage,
      contact: contact ?? this.contact,
      review: review ?? this.review,
      rating: rating ?? this.rating,
      reviewImage: reviewImage ?? this.reviewImage,
      localImages: localImages ?? this.localImages,
      timestamp: timestamp ?? this.timestamp,
      isApproved: isApproved ?? this.isApproved,
    );
  }
}

class ProductReviewData {

  final int productTotalRatings;
  final double productAverageRatings;
  final Map<int, int> productDetailedRatings;
  final List<String> reviewImages;

  ProductReviewData({
    required this.productTotalRatings,
    required this.productAverageRatings,
    required this.productDetailedRatings,
    required this.reviewImages
  });
}
