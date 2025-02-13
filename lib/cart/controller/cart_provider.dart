import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// import 'package:krishisevakendra/EventsServices/Netcore/netcore_service.dart';

import '../../common/user/model/user_model.dart';
import '../model/cart_model.dart';
import '../model/coupon.dart';
import '../model/coupon_model.dart';
import '../model/delivery_detail_model.dart';
import '../model/free_product_model.dart';
import '../model/free_variant_model.dart';
import '../model/special_discount_model.dart';
import '../service/cart_service.dart';

Map<String, dynamic> userData = {};


class CartProvider with ChangeNotifier {

  CartService cartService = CartService();

  CartProvider() {
    getCartItems();
    fetchCoupons('en');
    fetchCrops();

  }

  Future<List<CartItem>> getCartItems() async {
    _cartItems = await CartService.getCartItems();
    notifyListeners();
    return _cartItems;
  }

  bool _isPriceDetailsExpanded = true;
  bool get isPriceDetailsExpanded => _isPriceDetailsExpanded;
  void togglePriceDetailsExpansion() {
    _isPriceDetailsExpanded = !_isPriceDetailsExpanded;
    notifyListeners();
  }

  List<CartItem> _cartItems = [];
  List<CartItem> get cartItems => _cartItems;

  double _totalCartPrice = 0.0;
  double get totalCartPrice => _totalCartPrice;

  double _totalCartMRP = 0.0;
  double get totalCartMRP => _totalCartMRP;

  void updateTotalCartPrice() {

    double totalMRP = 0.0;
    double totalPrice = 0.0;

    for (var item in cartItems) {
      totalPrice += item.totalPrice;
      totalMRP += item.totalMRP;
    }

    _totalCartPrice = totalPrice;
    _totalCartMRP = totalMRP;

    notifyListeners();

    updateAppliedCouponAmount();
  }



  void addToCart({
    required CartItem item,
    required String collectionId,
    required String category,
  }) async {

    log('Item Added - ${jsonEncode(item.toMap())}');

    final index = _cartItems.indexWhere((existingItem) => existingItem.variantId == item.variantId);

    if (index != -1) {
      _cartItems[index] = _cartItems[index].copyWith(quantity: _cartItems[index].quantity + item.quantity);
    } else {
      _cartItems.add(item.copyWith(collectionId: collectionId, category: category));
    }

    await cartService.saveCartItems(_cartItems);
    updateTotalCartPrice();

    notifyListeners();
  }


  void updateAppliedCouponAmount() {
    if (appliedCoupon != null) {

      Coupon coupon = appliedCoupon!;

      if (isCouponEnabled(coupon, totalCartPrice)) {
        if (coupon.minimumAmount <= totalCartPrice || coupon.minimumAmount == 0) {
          if (coupon.discountPercentage != 0) {

            double discountAmount = coupon.discountPercentage * totalCartPrice / 100;
            setDiscountAmount(discountAmount);
            setAppliedCoupon(coupon);
          }
          else {
            double discountAmount = coupon.discountAmount;
            setDiscountAmount(discountAmount);
            setAppliedCoupon(coupon);
          }
        }
      } else {
        setDiscountAmount(0);
        setAppliedCoupon(null);
        couponTextController.clear();
      }

      notifyListeners();
    }
  }

  void removeFromCart({
    required int index,
  }) async {

    if (index != -1) {

      CartItem item = _cartItems[index];

      String productId = item.productId.split('/').last;
      String variantId = item.variantId.split('/').last;
      String category = item.category ?? '';
      String collectionId = item.collectionId ?? '';

      _cartItems.removeAt(index);

      await cartService.saveCartItems(_cartItems);

      updateTotalCartPrice();

      notifyListeners();
    }
  }

  void clearCart() async {
    _cartItems.clear();
    await cartService.saveCartItems(_cartItems);
    updateTotalCartPrice();
    // await _removeAllCartItemsFromFirebase();
    notifyListeners();
  }

  bool doesCartContains(String productId, String variantId) {
    return _cartItems.any((item) => extractId(item.productId) == extractId(productId) && extractId(item.variantId) == extractId(variantId));
  }

  String extractId(String id) {
    return id.split('/').last;
  }

  void updateCartItemQuantity(String variantId, int quantity) async {
    final index = _cartItems.indexWhere((item) => item.variantId == variantId);
    if (index != -1) {
      _cartItems[index] = _cartItems[index].copyWith(quantity: quantity);
      await cartService.saveCartItems(_cartItems);
      updateTotalCartPrice();
      notifyListeners();
    }
  }

  // Address Data

  final TextEditingController nameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController alternateMobileController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController pincodeController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController countryController = TextEditingController();

  bool _isSavingAddress = false;
  bool get isSavingAddress => _isSavingAddress;
  void setSavingAddress(bool value) {
    _isSavingAddress = value;
    notifyListeners();
  }

  String _stateCode = '';
  String get stateCode => _stateCode;

  List<String> _selectedCrops = [];
  List<String> get selectedCrops => _selectedCrops;
  void setSelectedCrops(List<String> crops) {
    _selectedCrops = crops;
    notifyListeners();
  }

  final List<String> farmAreaList = [
    '1-5 Acre',
    '6-10 Acre',
    'Above 10 Acre',
  ];

  String? _selectedFarmArea;
  String? get selectedFarmArea => _selectedFarmArea;
  void setFarmArea(String? value) {
    _selectedFarmArea = value;
    notifyListeners();
  }

  bool _isFetchingUserAddress = false;
  bool get isFetchingUserAddress => _isFetchingUserAddress;
  void setFetchingUserAddress(bool value) {
    _isFetchingUserAddress = value;
    notifyListeners();
  }

  bool canOrderPlaced() {
    if (_userModel == null) {
      return false;
    }
    else {
      return
        (_userModel!.name != null && _userModel!.name != '') &&
        (_userModel!.contact != null && _userModel!.contact != '') &&
        (_userModel!.city != null && _userModel!.city != '') &&
        (_userModel!.state != null && _userModel!.state != '') &&
        (_userModel!.country != null && _userModel!.country != '') &&
        (_userModel!.pincode != null && _userModel!.pincode != '') &&
        (_userModel!.address != null && _userModel!.address != '');
    }
  }

  UserModel? _userModel;
  UserModel? get userModel => _userModel;




  bool _isFetchingLocationDetails = false;
  bool get isFetchingLocationDetails => _isFetchingLocationDetails;
  void setFetchingLocationDetails(bool value) {
    _isFetchingLocationDetails = value;
    notifyListeners();
  }

  // Future<void> getLocationDetails(BuildContext context, String pincode) async {
  //   setFetchingLocationDetails(true);
  //
  //   UserModel? userModel = await cartService.getLocationDetails(context, pincode);
  //   if (userModel != null) {
  //     cityController.text = userModel.city!;
  //     stateController.text = userModel.state!;
  //     countryController.text = userModel.country!;
  //     _stateCode = userModel.stateCode ?? '';
  //   }
  //
  //   setFetchingLocationDetails(false);
  // }

  // Delivery Data

  Stream<List<DeliveryDetailModel>> fetchDeliveryDetails() async* {
    Stream<List<DeliveryDetailModel>> data = await cartService.fetchDeliveryDetails();
    yield* data;
  }

  String _savedDeliveryDateTime = '';
  String get savedDeliveryDateTime => _savedDeliveryDateTime;
  void setSavedDeliveryDateTime(String value) {
    _savedDeliveryDateTime = value;
    notifyListeners();
  }

  String calculateDeliveryDate(String time) {
    if (time == '') {
      return '';
    }
    try {
      final parts = time.split('-');
      if (parts.length == 2) {
        final endDays = int.tryParse(parts[1].replaceAll(RegExp(r'\D'), ''));
        // log('End Days - $endDays');
        if (endDays != null) {
          final deliveryDate = DateTime.now().add(Duration(days: endDays));
          // log('Delivery date - $deliveryDate');
          return DateFormat('MMM d, EEE').format(deliveryDate);
        }
      }
      return 'Invalid time format';

    } catch (e) {
      return 'Invalid date';
    }
  }

  String calculateDeliveryTime({
    required String customerPincode,
    required List<DeliveryDetailModel> deliveryDetails
  }) {
    int pincode = int.tryParse(customerPincode) ?? 0;

    // log('6-digit Pin code - $pincode');

    for (var deliveryDetail in deliveryDetails) {

      int startingPin = int.parse(deliveryDetail.startingPin!);
      int endingPin = int.parse(deliveryDetail.endingPin!);

      if (pincode >= startingPin && pincode <= endingPin) {
        return deliveryDetail.time!;
      }
    }

    return '';
  }

  // Crop Data
  bool _isFetingCrops = false;
  bool get isFetingCrops => _isFetingCrops;
  void setFetchingCrops(bool value) {
    _isFetingCrops = value;
    notifyListeners();
  }

  List<String> _cropList = [];
  List<String> get cropList => _cropList;

  List<String> _cropListHi = [];
  List<String> get cropListHi => _cropListHi;

  Future<void> fetchCrops() async {
    setFetchingCrops(true);
    Map<String, List<String>> crops = await cartService.fetchCrops();
    if (crops.isNotEmpty) {
      _cropList = crops['cropList'] ?? [];
      _cropListHi = crops['cropListHi'] ?? [];
      notifyListeners();
    }
    setFetchingCrops(false);
  }

  // Free Product

  bool _isFreeProductSelected = false;
  bool get isFreeProductSelected => _isFreeProductSelected;
  void setFreeProductSelected(bool value) {
    _isFreeProductSelected = value;
    notifyListeners();
  }

  FreeVariantModel? _freeVariant;
  FreeVariantModel? get freeVariant => _freeVariant;

  FreeProductModel? _freeProduct;
  FreeProductModel? get freeProduct => _freeProduct;

  Future<void> fetchFreeProduct() async {
    _freeProduct = await cartService.fetchFreeProduct();
    if (_freeProduct != null) {
      _freeVariant = await cartService.fetchProductData(_freeProduct!.id);
    }
    notifyListeners();
  }

  SpecialDiscountOfferModel? _specialDiscountOffer;
  SpecialDiscountOfferModel? get specialDiscountOffer => _specialDiscountOffer;

  // Special Offer
  bool _isSpecialDiscountApply = false;
  bool get isSpecialDiscountApply => _isSpecialDiscountApply;
  void setSpecialDiscountApply(bool value) {
    _isSpecialDiscountApply = value;
    _discountAmount = 0.0;
    notifyListeners();
  }

  // Coupon Data
  TextEditingController singleProductCouponTextController = TextEditingController();
  TextEditingController couponTextController = TextEditingController();

  String _specialDiscountDocName = '';
  String get specialDiscountDocName => _specialDiscountDocName;

  Future<void> fetchSpecialDiscountOffer(BuildContext context, String specialDiscountDocName) async {
    _specialDiscountOffer = await cartService.fetchSpecialDiscountOffer(context, specialDiscountDocName);

    _specialDiscountDocName = specialDiscountDocName;

    print('special discount : $specialDiscountDocName');
    notifyListeners();
  }

  bool _isApplyingCoupon = false;
  bool get isApplyingCoupon => _isApplyingCoupon;
  void setApplyingCoupon(bool value) {
    _isApplyingCoupon = value;
    notifyListeners();
  }

  CartItem? _cartItem;
  CartItem? get cartItem => _cartItem;
  void setCartItem(CartItem? item) {
    _cartItem = item;
    notifyListeners();
  }

  void decreaseProductQuantity() async {
    if (cartItem != null) {
      if (cartItem!.quantity > 1) {
        int quantity = cartItem!.quantity - 1;
        _cartItem = cartItem!.copyWith(quantity: quantity);
        notifyListeners();
        updateSingleProductCoupon();
      }
    }
  }

  void increaseProductQuantity() async {
    if (cartItem != null) {
      int quantity = cartItem!.quantity + 1;
      _cartItem = cartItem!.copyWith(quantity: quantity);
      notifyListeners();
      updateSingleProductCoupon();
    }
  }

  void updateSingleProductCoupon() {
    if (cartItem != null && singleProductAppliedCoupon != null) {

      Coupon coupon = singleProductAppliedCoupon!;

      if (isCouponEnabled(coupon, cartItem!.totalPrice)) {
        if (coupon.minimumAmount <= cartItem!.totalPrice || coupon.minimumAmount == 0) {
          if (coupon.discountPercentage != 0) {

            double discountAmount = coupon.discountPercentage * cartItem!.totalPrice / 100;
            setSingleProductDiscountAmount(discountAmount);
            setSingleProductAppliedCoupon(coupon);
          }
          else {
            double discountAmount = coupon.discountAmount;
            setSingleProductDiscountAmount(discountAmount);
            setSingleProductAppliedCoupon(coupon);
          }
        }
      } else {
        setSingleProductDiscountAmount(0);
        setSingleProductAppliedCoupon(null);
        singleProductCouponTextController.clear();
      }

      notifyListeners();
    }
  }

  double _singleProductDiscountAmount = 0.0;
  double get singleProductDiscountAmount => _singleProductDiscountAmount;
  void setSingleProductDiscountAmount(double value) {
    _singleProductDiscountAmount = value;
    notifyListeners();
  }

  Coupon? _singleProductAppliedCoupon;
  Coupon? get singleProductAppliedCoupon => _singleProductAppliedCoupon;
  void setSingleProductAppliedCoupon(Coupon? coupon) {
    if (coupon != null) {
      singleProductCouponTextController.text = coupon.title;
    }
    _singleProductAppliedCoupon = coupon;
    notifyListeners();
  }

  double _discountAmount = 0.0;
  double get discountAmount => _discountAmount;
  void setDiscountAmount(double value) {
    _discountAmount = value;
    _isSpecialDiscountApply = false;
    notifyListeners();
  }

  Coupon? _appliedCoupon;
  Coupon? get appliedCoupon => _appliedCoupon;
  void setAppliedCoupon(Coupon? coupon) {
    if (coupon != null) {
      couponTextController.text = coupon.title;
    }
    _appliedCoupon = coupon;
    notifyListeners();
  }

  bool isCouponEnabled(Coupon coupon, double amount) {

    double afterDiscountAmount = 0;

    if (coupon.discountPercentage != 0) {
      afterDiscountAmount = coupon.discountPercentage * amount / 100;
    }
    else {
      afterDiscountAmount = coupon.discountAmount;
    }

    afterDiscountAmount = amount - afterDiscountAmount;
    
    bool isEnabled = coupon.minimumAmount <= amount && afterDiscountAmount > 0;
    
    return isEnabled;
  }

  Coupon? getNearestCoupon() {

    double nearestDifference = double.infinity;
    Coupon? nearestCoupon;

    coupons.forEach((coupon) {
      double minAmount = coupon.minimumAmount;
      double difference = minAmount - totalCartPrice;

      if (difference >= 0 && difference < nearestDifference) {
        nearestDifference = difference;
        nearestCoupon = coupon;
      }
    });

    return nearestCoupon;
  }

  double calculateProgress() {
    Coupon? nearestCoupon = getNearestCoupon();
    double minAmount = nearestCoupon?.minimumAmount ?? 1;
    return (totalCartPrice / minAmount).clamp(0.0, 1.0);
  }

  bool isAllCouponUnlocked() {
    return coupons.every((coupon) => totalCartPrice >= coupon.minimumAmount);
  }

  bool _isFetchingCoupons = false;
  bool get isFetchingCoupons => _isFetchingCoupons;
  void setFetchingCoupons(bool value) {
    _isFetchingCoupons = value;
    notifyListeners();
  }

  List<Coupon> _allCoupons = [];
  List<Coupon> get allCoupons => _allCoupons;

  List<Coupon> _coupons = [];
  List<Coupon> get coupons => _coupons;

  List<Map<String, String>> _couponDescription = [];
  List<Map<String, String>> get couponDescription => _couponDescription;

  Future<void> fetchCoupons(String languageCode) async {

    setFetchingCoupons(true);

    List<dynamic> response = await Future.wait([
      cartService.fetchCoupons(),
      cartService.fetchCouponDescription(languageCode),
    ]);

    List<CouponModel> coupons = response[0];

    // Coupon Descriptions
    _couponDescription = response[1];

    notifyListeners();

    await createCoupons(coupons);

    log('Coupons Created :)');

    setFetchingCoupons(false);
  }

  Future<void> createCoupons(List<CouponModel> coupons) async {

    log('Creating Coupon..');

    List<Coupon> allCoupons = [];

    List<Coupon> validCoupons = [];

    for (var coupon in coupons) {
      List<String> summary = coupon.summary.split('•');
      String data = summary[0].replaceAll(',', '');

      RegExp regex;
      Match? match;

      // Discount Perentage
      double discountPercentage = 0;
      regex = RegExp(r'(\d+)% off');
      match = regex.firstMatch(data);
      if (match != null) {
        String percentageValue = match.group(1)!;
        discountPercentage = double.parse(percentageValue);
      }

      // Discount Rupees
      double discountAmount = 0.0;
      regex = RegExp(r'₹([\d.]+) off');
      match = regex.firstMatch(data);
      if (match != null) {
        String rupeesValue = match.group(1)!;
        discountAmount = double.parse(rupeesValue);
      }

      // Minimum Amount
      double minimumAmount = 1;
      if (summary.length > 1) {
        data = summary[1].replaceAll(',', '');
        regex = RegExp(r'₹([\d.]+)');
        match = regex.firstMatch(data);
        if (match != null) {
          String minimumValue = match.group(1)!;
          minimumAmount = double.parse(minimumValue);
        }
      }

      String description = coupon.summary;

      for (var desc in couponDescription) {
        if (coupon.title == desc['title']) {
          description = desc['desc'] ?? coupon.summary;
        }
      }

      Coupon newCoupon = Coupon(
        title: coupon.title,
        descrition: description,
        minimumAmount: minimumAmount,
        discountPercentage: discountPercentage,
        discountAmount: discountAmount,
        count: 0,
      );

      allCoupons.add(newCoupon);
    }

    List<Coupon> finalCoupons = await Future.wait(
      allCoupons.map((coupon) async {
        int count = await cartService.fetchCouponCount(coupon.title);
        Coupon finalCoupon = coupon.copyWith(count: count);
        return finalCoupon;
      }).toList()
    );

    for (var coupon in finalCoupons) {
      if (!coupon.title.startsWith('FBT') && !coupon.title.startsWith('KO')) {
        validCoupons.add(coupon);
      }
    }

    _allCoupons = allCoupons;
    _coupons = validCoupons;

    notifyListeners();
  }

  // Payment Data

  bool _isPaying = false;
  bool get isPaying => _isPaying;
  void setPaying(bool value) {
    _isPaying = value;
    notifyListeners();
  }

  double calculateAddableCoin(double totalCartPrice) {
    if (totalCartPrice > 0 && totalCartPrice <= 500) {
      return totalCartPrice / 10;
    } else if (totalCartPrice > 500 && totalCartPrice <= 2000) {
      return totalCartPrice / 10;
    } else if (totalCartPrice > 2000 && totalCartPrice <= 5000) {
      return totalCartPrice / 20;
    } else if (totalCartPrice > 5000) {
      return totalCartPrice / 18;
    } else {
      return 0;
    }
  }

  Future<void> sendPaymentFailedData({
    required String number,
    required String paymentID,
    required double amount,
    required String error
  }) async {
    await cartService.sendPaymentFailedData(number: number, paymentID: paymentID, amount: amount, error: error);
  }

  String? _countingText;
  String? get countingText => _countingText;

  String? _countingImage;
  String? get countingImage => _countingImage;

  void setCountingData(String text, String image) {
    _countingText = text;
    _countingImage = image;
    notifyListeners();
  }

  Stream<Map<String, dynamic>> fetchCustomCounting() async* {
    DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance.collection('DynamicSection').doc('CustomCounting').get();
    if (snapshot.exists) {
      yield snapshot.data()!;
    }
  }

}

// metafields(first: 10) {
// edges {
// node {
// namespace
// key
// value
// type
// }
// }
// }

