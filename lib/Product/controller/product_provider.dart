import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';


import '../model/product_model.dart';
import '../model/product_review_model.dart';
import '../model/variant_model.dart';
import '../service/product_service.dart';

class ProductProvider with ChangeNotifier {

  ProductService productService = ProductService();

  Map<String, List<VariantModel>> _productVariants = {};

  Map<String, List<VariantModel>> get productVariants => _productVariants;

  VariantModel? _selectedVariant;

  VariantModel? get selectedVariant => _selectedVariant;

  void initCurrentVariant(VariantModel value) {
    _selectedVariant = value;
  }

  void setSelectedVariant(VariantModel value) {
    _selectedVariant = value;
    notifyListeners();
  }

  bool _isFetchingVariants = true;

  bool get isFetchingVariants => _isFetchingVariants;

  void setIsFetchingVariants(bool value) {
    _isFetchingVariants = value;
    // notifyListeners();
  }

  Future<void> fetchVariantData(String productId) async {
    setIsFetchingVariants(true);

    List<VariantModel> variantModel = await productService.fetchVariantData(
        productId);
    _productVariants[extractId(productId)] = variantModel;

    String id = variantModel[0].id.toString();
    String title = variantModel[0].title.toString();
    String price = variantModel[0].price.toString();
    String costAtPrice = variantModel[0].compareAtPrice.toString();
    String inventoryQunatity = variantModel[0].inventoryQuantity.toString();

    _selectedVariant = VariantModel(
      id: id,
      title: title,
      price: price,
      compareAtPrice: costAtPrice,
      inventoryQuantity: inventoryQunatity,
    );

    notifyListeners();

    for (var variant in variantModel) {
      String key = variant.id!;

      if (_quantity.containsKey(key)) {
        _quantity.update(key, (q) => 1);
      } else {
        _quantity[key] = 1;
      }
    }

    setIsFetchingVariants(false);
  }

  Map<String, int> _quantity = {};

  Map<String, int> get quantity => _quantity;

  bool isVariantOutOfStock(VariantModel? variant) {
    if (variant == null) {
      return true;
    }

    int availableQuantity = int.tryParse(variant.inventoryQuantity!) ?? 0;

    // log("${variant.title}'s Available Quantity = $availableQuantity");

    return availableQuantity == 0;
  }

  int increaseQuantity({String? variantId}) {
    int currentQunatity = _quantity[variantId ?? selectedVariant?.id] ?? 0;

    currentQunatity++;
    _quantity[variantId ?? selectedVariant?.id.toString() ?? ''] =
        currentQunatity;
    notifyListeners();

    return currentQunatity;
  }

  int decreaseQuantity({String? variantId}) {
    int currentQunatity = _quantity[variantId ?? selectedVariant?.id] ?? 0;

    if (currentQunatity > 1) {
      currentQunatity--;
      _quantity[variantId ?? selectedVariant?.id.toString() ?? ''] =
          currentQunatity;
      notifyListeners();
      return currentQunatity;
    }

    return -1;
  }

  void resetQuantity({required String variantId}) {
    log('Old Quantity = ${_quantity[variantId]}');
    _quantity[variantId] = 1;
    notifyListeners();
    log('Updated Quantity = ${_quantity[variantId]}');
  }

  bool _isNotifying = false;

  bool get isNotifying => _isNotifying;

  void setNotifying(bool value) {
    _isNotifying = value;
    notifyListeners();
  }

  void notifyWhenAvailable(String productTitle, String variantTitle) async {
    setNotifying(true);

    //await productService.notifyWhenAvailable(productTitle, variantTitle);

    setNotifying(false);
  }

  String calculateDiscount(double selectedVariantPrice) {
    double discountPercentage;

    if (selectedVariantPrice >= 300 && selectedVariantPrice < 900) {
      discountPercentage = 7.0;
    } else if (selectedVariantPrice >= 900 && selectedVariantPrice < 2000) {
      discountPercentage = 3.0;
    } else if (selectedVariantPrice >= 2000 && selectedVariantPrice < 5000) {
      discountPercentage = 2.0;
    } else {
      discountPercentage = 2.0;
    }
    double discountAmount = (selectedVariantPrice * discountPercentage) / 100;

    return '${discountAmount.toStringAsFixed(0)}';
  }

  double calculateDiscountPercentage({VariantModel? variant}) {
    double price = double.tryParse(
        variant?.price ?? selectedVariant?.price.toString() ?? '') ?? 0;
    double costAtPrice = double.tryParse(
        variant?.compareAtPrice ?? selectedVariant?.compareAtPrice.toString() ??
            '') ?? 0;

    double savedAmount = costAtPrice - price;

    return (savedAmount > 0) ? (savedAmount / costAtPrice) * 100 : 0;
  }

  bool _isFetchingRecentlyViewedProducts = false;

  bool get isFetchingRecentlyViewedProducts =>
      _isFetchingRecentlyViewedProducts;

  List<Product> _recentlyViewedProducts = [];

  List<Product> get recentlyViewedProducts => _recentlyViewedProducts;

  Future<void> fetchRecentlyViewedProducts() async {
    _isFetchingRecentlyViewedProducts = true;
    notifyListeners();

    //_recentlyViewedProducts = await productService.fetchRecentlyViewedProducts();

    _isFetchingRecentlyViewedProducts = false;
    notifyListeners();
  }

  Future<void> addRecentlyViewedProducts(String productId) async {
    int index = recentlyViewedProducts.indexWhere((product) =>
    extractId(product.productId) == productId);

    if (index != -1) {
      return;
    }

    List<String> productIds = recentlyViewedProducts.map((product) =>
        extractId(product.productId.toString())).toList();

    if (productIds.length >= 10) {
      productIds.removeLast();
    }

    productIds.add(extractId(productId));
    //await productService.addRecentlyViewedProducts(productIds: productIds);

    await fetchRecentlyViewedProducts();
  }

  String extractId(String id) {
    return id
        .split('/')
        .last;
  }

  Stream<
      List<Map<String, dynamic>>> fetchRecommendedProductCollectionId() async* {
    // Fetch Collection IDs from Firebase
    Map<String, dynamic> data = await productService
        .fetchRecommendedProductCollectionId();

    // Separate data;
    Map<String, dynamic> frequentlyData = data['frequently'] ?? {};
    Map<String, dynamic> popularData = data['popular'] ?? {};

    // Extract Collection IDs
    List<String> collectionIds = [];

    String frequently = frequentlyData['collectionId'] ?? '';
    String popular = popularData['collectionId'] ?? '';

    if (frequently != '') {
      collectionIds.add(frequently);
    }
    if (popular != '') {
      collectionIds.add(popular);
    }

    // Fetch Products from Shopify with Collection IDs
    List<Map<String, dynamic>> productData = await Future.wait(
        collectionIds.map((id) {
          return productService.fetchRecommendedProducts(id);
        }).toList());


    // Create Stream Data

    List<Map<String, dynamic>> stream = [];

    Map<String, dynamic> frequentlyProducts = {};
    Map<String, dynamic> popluarProducts = {};

    if (productData.length >= 1) {
      frequentlyProducts = {
        'data': productData[0],
        'title_en': frequentlyData['title_en'] ?? '',
        'title_hi': frequentlyData['title_hi'] ?? '',
      };

      stream.add(frequentlyProducts);
    }

    if (productData.length >= 2) {
      popluarProducts = {
        'data': productData[1],
        'title_en': popularData['title_en'] ?? '',
        'title_hi': popularData['title_hi'] ?? '',
      };

      stream.add(popluarProducts);
    }

    yield stream;
  }


  /// Product Reviews

  bool _isFetchingProductReviews = false;

  bool get isFetchingProductReviews => _isFetchingProductReviews;

  void setFetchingProductReviews(bool value) {
    _isFetchingProductReviews = value;
    notifyListeners();
  }

  Map<String, ProductReviewData> _productReviewsData = {};

  Map<String, ProductReviewData> get productReviewsData => _productReviewsData;

  void initProductReviewsData(String productId) {
    log('Init product review data with prid $productId');

    ProductReviewData productReviewData = ProductReviewData(
      productTotalRatings: 0,
      productAverageRatings: 0,
      productDetailedRatings: {
        5: 0,
        4: 0,
        3: 0,
        2: 0,
        1: 0,
      },
      reviewImages: [],
    );

    _productReviewsData[productId] = productReviewData;

    log('Product Review Data Map = ${_productReviewsData}');

    notifyListeners();
  }

  Map<String, ProductReviewModel?> _productReviews = {};

  Map<String, ProductReviewModel?> get productReviews => _productReviews;

  void calculateProductReviewedData(ProductReviewModel productReviews,
      List<dynamic> selectedImages) {
    Map<int, int> productDetailedRatings = {};

    double totalRatings = 0.0;
    for (var review in productReviews.reviews) {
      double rating = double.tryParse(review.rating) ?? 0;

      totalRatings += rating;

      int key = rating.round();
      if (key > 5) key = 5;
      if (key < 1) key = 1;

      if (productDetailedRatings.containsKey(key)) {
        int oldRating = productDetailedRatings[key] ?? 0;
        oldRating++;
        productDetailedRatings[key] = oldRating;
      }
      else {
        productDetailedRatings[key] = 1;
      }
    }

    int productTotalRatings = totalRatings.round();
    double productAverageRatings = (totalRatings /
        productReviews.reviews.length).roundToDouble();

    ProductReviewData productReviewData = ProductReviewData(
      productTotalRatings: productTotalRatings,
      productAverageRatings: productAverageRatings,
      productDetailedRatings: productDetailedRatings,
      reviewImages: selectedImages is List<String> ? selectedImages : [],
    );

    _productReviewsData[productReviews.productId] = productReviewData;
  }

  List<String> verifyAndSelectReviewImages(ProductReviewModel productReviews) {
    List<String> selectedImages = [];

    List<Reviews> allImages = productReviews.reviews.where((review) =>
    review.reviewImage.isNotEmpty).toList();

    for (var review in allImages) {
      List<String> images = review.reviewImage;
      for (var image in images) {
        selectedImages.add(image);
      }
    }

    return selectedImages;
  }




  /// Review Writing Data

  TextEditingController reviewController = TextEditingController();

  List<File> _reviewImages = [];

  List<File> get reviewImages => _reviewImages;

  void addReviewImage(File image) {
    if (_reviewImages.length < 3) {
      _reviewImages.add(image);
      notifyListeners();
    }
  }

  void removeReviewImage(int index) {
    if (index < _reviewImages.length) {
      _reviewImages.removeAt(index);
      notifyListeners();
    }
  }

  double _ratings = 3.0;

  double get ratings => _ratings;

  void setRatings(double value) {
    _ratings = value;
    notifyListeners();
  }

  bool _isSavingReview = false;

  bool get isSavingReview => _isSavingReview;

  void setSavingReview(bool value) {
    _isSavingReview = value;
    notifyListeners();
  }


  Future<bool> deleteProductReview({
    required String productId,
    required String reviewId,
  }) async {
    _productReviews[productId]!.reviews.removeWhere((review) =>
    review.id == reviewId);
    calculateProductReviewedData(_productReviews[productId]!,
        verifyAndSelectReviewImages(_productReviews[productId]!));
    notifyListeners();

    bool isDeleted = await productService.deleteProductReview(
        productId: productId, reviewId: reviewId);

    return isDeleted;
  }

  void resetReviewWritingDetails() {
    reviewController.clear();
    _reviewImages.clear();
    _ratings = 3.0;
    notifyListeners();
  }

  /// ---------------------- PRODUCT REVIEW ENDS ---------------------- ///

  Stream<List<Map<String, dynamic>>> fetchFAQs(String productId) async* {
    List<Map<String, dynamic>> data = await productService.fetchFAQs(productId);

    log("Frequently Asked Questions - $data");

    yield data;
  }

  bool _fetchingSimilarProducts = false;

  bool get fetchingSimilarProducts => _fetchingSimilarProducts;

  Map<String, List<Product>> _similarProducts = {};

  Map<String, List<Product>> get similarProducts => _similarProducts;

  String _bannerImageUrl = '';

  String get bannerImageUrl => _bannerImageUrl;






// double getWeightInKg(String? title) {
//   if (title == null || title.trim().isEmpty) {
//     return 0;
//   }
//
//   final lowerTitle = title.trim().toLowerCase();
//
//   final regex = RegExp(r'(\d+(\.\d+)?)(?:\s*)(ton|kg)');
//   final match = regex.firstMatch(lowerTitle);
//
//   if (match == null) {
//     return 0;
//   }
//
//   final numericStr = match.group(1) ?? '0';
//   final unitStr = match.group(3)?.toLowerCase() ?? '';
//
//   final numericValue = double.tryParse(numericStr) ?? 0;
//
//   if (unitStr.contains('ton')) {
//     return numericValue * 1000;
//   } else {
//     return numericValue;
//   }
// }
}