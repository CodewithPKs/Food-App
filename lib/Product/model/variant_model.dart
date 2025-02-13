// class VariantModel {
//   String? id;
//   String? title;
//   String? price;
//   String? compareAtPrice;
//   String? inventoryQuantity;
//   List<Metafield>? metafields;
//
//   VariantModel({
//     this.id,
//     this.title,
//     this.price,
//     this.compareAtPrice,
//     this.inventoryQuantity,
//     this.metafields,
//   });
//
//   factory VariantModel.fromJson(Map<String, dynamic> json) {
//     List<Metafield>? parsedMetafields;
//     if (json['metafields'] != null &&
//         json['metafields']['edges'] != null) {
//       parsedMetafields = (json['metafields']['edges'] as List<dynamic>)
//           .map((item) => Metafield.fromJson(item['node']))
//           .toList();
//     }
//
//     return VariantModel(
//       id: json['id']?.toString() ?? '',
//       title: json['title']?.toString() ?? '',
//       price: json['price']?.toString() ?? '',
//       compareAtPrice: json['compareAtPrice']?.toString() ?? '',
//       inventoryQuantity:
//       json['inventoryQuantity']?.toString() ?? '',
//       metafields: parsedMetafields,
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'title': title,
//       'price': price,
//       'compareAtPrice': compareAtPrice,
//       'inventoryQuantity': inventoryQuantity,
//       'metafields': metafields?.map((mf) => mf.toJson()).toList(),
//     };
//   }
// }
//
//
// class Metafield {
//   String? namespace;
//   String? key;
//   String? value;
//   String? type;
//
//   Metafield({
//     this.namespace,
//     this.key,
//     this.value,
//     this.type,
//   });
//
//   factory Metafield.fromJson(Map<String, dynamic> json) {
//     return Metafield(
//       namespace: json['namespace']?.toString() ?? '',
//       key: json['key']?.toString() ?? '',
//       value: json['value']?.toString() ?? '',
//       type: json['type']?.toString() ?? '',
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'namespace': namespace,
//       'key': key,
//       'value': value,
//       'type': type,
//     };
//   }
// }

import 'dart:convert';

class VariantModel {
  String? id;
  String? title;
  String? price;
  String? compareAtPrice;
  String? inventoryQuantity;
  List<Metafield>? metafields;

  VariantModel({
    this.id,
    this.title,
    this.price,
    this.compareAtPrice,
    this.inventoryQuantity,
    this.metafields,
  });

  factory VariantModel.fromJson(Map<String, dynamic> json) {
    List<Metafield>? parsedMetafields;

    if (json['metafields'] != null &&
        json['metafields']['edges'] is List) {
      try {
        parsedMetafields = (json['metafields']['edges'] as List)
            .map((item) => Metafield.fromJson(item['node'] as Map<String, dynamic>))
            .toList();
      } catch (e) {
        print("Error parsing metafields: $e");
        parsedMetafields = [];
      }
    }

    return VariantModel(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      price: json['price']?.toString() ?? '',
      compareAtPrice: json['compareAtPrice']?.toString() ?? '',
      inventoryQuantity: json['inventoryQuantity']?.toString() ?? '',
      metafields: parsedMetafields,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'compareAtPrice': compareAtPrice,
      'inventoryQuantity': inventoryQuantity,
      'metafields': metafields?.map((mf) => mf.toJson()).toList(),
    };
  }
}

class Metafield {
  String? namespace;
  String? key;
  dynamic value;
  String? type;

  Metafield({
    this.namespace,
    this.key,
    this.value,
    this.type,
  });

  factory Metafield.fromJson(Map<String, dynamic> json) {
    dynamic parsedValue;

    try {
      switch (json['type']) {
        case 'list.number_integer':
          if (json['value'] != null) {
            final decodedValue = jsonDecode(json['value']);
            if (decodedValue is List) {
              parsedValue = decodedValue.map((e) => int.tryParse(e.toString()) ?? 0).toList();
            } else {
              parsedValue = [];
            }
          } else {
            parsedValue = [];
          }
          break;

        case 'boolean':
          parsedValue = json['value']?.toString().toLowerCase() == 'true';
          break;

        default:
          parsedValue = json['value'];
      }
    } catch (e) {
      print("Error parsing metafield value: $e");
      parsedValue = null;
    }

    return Metafield(
      namespace: json['namespace']?.toString() ?? '',
      key: json['key']?.toString() ?? '',
      value: parsedValue,
      type: json['type']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    String serializedValue;

    try {
      if (type == 'list.number_integer' && value is List) {
        serializedValue = jsonEncode(value);
      } else {
        serializedValue = value?.toString() ?? '';
      }
    } catch (e) {
      print("Error serializing metafield value: $e");
      serializedValue = '';
    }

    return {
      'namespace': namespace,
      'key': key,
      'value': serializedValue,
      'type': type,
    };
  }
}

