import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> fetchCategory(
    String search,
    int product,
    int imgLength,
    int varLength,
    String locale
    ) async {
  final url = 'https://3d6a19.myshopify.com/admin/api/2024-04/graphql.json';

  final String bodyHtmlField = locale == 'en' ? 'bodyHtml' : '';

  final String query = '''
  query TranslationsAndLocalizations {
    collection(id: "gid://shopify/Collection/$search") {
      title
      products(first: $product) {
        edges {
          node {
            id
            title
            tags
            description
            $bodyHtmlField
            translations(locale: "$locale") {
              key
              value
            }
            images(first: $imgLength) {
              edges {
                node {
                  src
                }
              }
            }
            status
            variants(first: $varLength) {
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
      }
    }
  }
''';

  final Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'X-Shopify-Access-Token': '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',
  };

  try {
    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode({'query': query}),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
       //log('API DATA - $data');
      return data;
    } else {
      log('Error fetching data for home screen: ${response.statusCode}');
      return {};
    }
  } catch (error, stackTrace) {
    log('Exception fetching data for home screen: $error\n$stackTrace');
    return {};
  }
}

