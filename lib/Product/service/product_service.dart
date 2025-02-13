import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/query_collection/ShopifyCollectionQuery/collectionQuery.dart';
import '../model/product_model.dart';
import '../model/variant_model.dart';

class ProductService {

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  // FirebaseStorage storage = FirebaseStorage.instance;

  Future<List<VariantModel>> fetchVariantData(String productId) async {
    try {

      const String apiUrl = 'https://3d6a19.myshopify.com/admin/api/2024-04/graphql.json';
      const String accessToken = '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';

      final String query = '''
    query GetProductWithVariants(\$id: ID!) {
      product(id: \$id) {
        id
        title
        variants(first: 10) {
          edges {
            node {
              id
              title
              price
              compareAtPrice
              inventoryQuantity
              metafields(first: 10) {
                edges {
                  node {
                    namespace
                    key
                    value
                    type
                  }
                }
              }
            }
          }
        }
      }
    }
    ''';

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'X-Shopify-Access-Token': accessToken,
        },
        body: jsonEncode({
          'query': query,
          'variables': {'id': productId}
        }),
      );

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);

        log('Response Body for variants - ${response.body}');

        final List<dynamic> variantEdges = responseBody['data']['product']['variants']['edges'] ?? [];

        List<Map<String, dynamic>> variantMaps = variantEdges.map((edge) {
          final node = edge['node'];
          return {
            'id': node['id'] ?? '',
            'title': node['title'] ?? '',
            'price': node['price'] ?? '',
            'compareAtPrice': node['compareAtPrice'] ?? '',
            'inventoryQuantity': node['inventoryQuantity'] ?? '',
            'metafields': node['metafields'],
          };
        }).toList();

        List<VariantModel> variants = variantMaps
            .map((jsonMap) => VariantModel.fromJson(jsonMap))
            .toList();

        // log('Variants fetched: ${jsonEncode(variantMaps)}');
        // log('Parsed Varants: ${jsonEncode(variants)}');

        return variants;
      } else {
        log('Failed to load product variants with status code: ${response.statusCode}');
        return [];
      }
    } catch (e, stace) {
      log("Error while fetching variants :(");
      log('Error is - $e');
      log('Error Stace - $stace');
      return [];
    }
  }
  
  Future<Map<String, dynamic>> fetchRecommendedProductCollectionId() async {
    try {
      
      DocumentSnapshot<Map<String, dynamic>> snapshot = await firestore.collection('DynamicSection').doc('Recommended Products').get();

      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data()!;

        final frequentlyData = data['frequently'];
        final popularData = data['popular'];

        return {
          'frequently': frequentlyData,
          'popular': popularData,
        };
      }

      return {};

    } catch(e, stace) {
      log('Error Fetching Recommended Product Collection Id..!!');
      log('Error - $e\nStace - $stace');
      return {};
    }
  }

  Future<Map<String, dynamic>> fetchRecommendedProducts(String collectionId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String languageCode = prefs.getString('language_code').toString();
    try {
      Map<String, dynamic> data = await fetchCategory(collectionId, 10, 6, 6, languageCode);
      return data;
    } catch (error) {
      log("Error fetching data: $error");
      return {};
    }
  }


  Future<bool> deleteProductReview({
    required String productId,
    required String reviewId,
  }) async {
    try {

      log('Deleting Product Review with Product Id - $productId and Review Id - $reviewId');

      await firestore.collection('Product Reviews').doc(productId).collection('Reviews').doc(reviewId).delete();

      log('Review Deleted :) ');

      return true;

    } catch (e, stace) {
      log("Error deleting Review..!!\n$e\n$stace");
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> fetchFAQs(String productId) async {
    try {

      QuerySnapshot<Map<String, dynamic>> snapshot = await firestore.collection('DynamicSection').doc('FAQ').collection('FAQ Data').get();

      List<Map<String, dynamic>> faq = [];

      for (var doc in snapshot.docs) {
        if (doc.exists) {
          Map<String, dynamic> data = doc.data();
          faq.add(data);
        }
      }

      log('All FAQs - $faq');

      faq = faq.where((data) {
        String id = data['productId'] ?? '';
        return id == '' || id == productId;
      }).toList();

      return faq;

    } catch(e, stace) {
      log('Error Fetching FAQs - $e\n$stace');
      return [];
    }
  }


  Future<Product?> fetchProductData({
    required String productId,
    required String locale,
  }) async {

    log('Fetching Product Data for Id - $productId');

    final String url = 'https://3d6a19.myshopify.com/admin/api/2024-04/graphql.json';
    final String accessToken = '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';

    final Map<String, dynamic> variables = {
      'product_id': "gid://shopify/Product/$productId",
      'locale': locale,
      'imgLength': 6,
      'varLength': 6,
    };

    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'X-Shopify-Access-Token': accessToken,
    };

    final String query = '''
    query TranslatedProduct(\$product_id: ID!, \$locale: String!, \$imgLength: Int!, \$varLength: Int!) {
      product(id: \$product_id) {
        title
        tags
        description
        translations(locale: \$locale) {
          key
          value
        }
        images(first: \$imgLength) {
          edges {
            node {
              src
            }
          }
        }
        status
        variants(first: \$varLength) {
          edges {
            node {
              price
              title
              compareAtPrice
              id
            }
          }
        }
      }
    }
    ''';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode({
          'query': query,
          'variables': variables
        }),
      );

      if (response.statusCode == 200) {

        final Map<String, dynamic> data = jsonDecode(response.body);

        final Map<String, dynamic> productData = data['data']['product'];

        final String title = productData['translations'].firstWhere((translation) => translation['key'] == 'title', orElse: () => {'value': productData['title']})['value'];

        final String description = productData['translations'].firstWhere((translation) => translation['key'] == 'body_html', orElse: () => {'value': productData['description']})['value'];

        final List<String> imageUrls = productData['images']['edges'].map<String>((edge) => edge['node']['src'] as String).toList();

        final List variantEdges = productData['variants']['edges'];

        final List<VariantModel> variants = variantEdges.map((edge) {
          final node = edge['node'];
          return VariantModel(
            id: node['id'] ?? '',
            title: node['title'] ?? '',
            price: node['price'] ?? '',
            compareAtPrice: node['compareAtPrice'] ?? '',
            inventoryQuantity: node['inventoryQuantity'] ?? '',
          );
        }).toList();

        Product product = Product(
          productId: 'gid://shopify/Product/$productId',
          productName: title,
          productDescription: description,
          price: variants.first.price!,
          mrp: variants.first.compareAtPrice!,
          imageSrc: imageUrls.first,
          images: imageUrls,
          variants: variants,
          collectionId: '',
          category: '',
        );

        return product;

      } else {
        log('Failed to fetch product data: ${response.body}');
        return null;
      }
    } catch (e, stace) {
      log('An error occurred while fetching product data :- $e\n$stace');
      return null;
    }
  }
}


