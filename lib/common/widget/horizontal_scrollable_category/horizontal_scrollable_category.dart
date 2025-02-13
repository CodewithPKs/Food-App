import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ProductItemFertilizerCategory extends StatelessWidget {

  final String image;
  final VoidCallback onTap;
  final String name;

  const ProductItemFertilizerCategory({
    super.key,
    required this.image,
    required this.onTap,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    double itemWidth = MediaQuery.of(context).size.width * 0.3;
    double itemHeight = MediaQuery.of(context).size.width * 0.25;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        // width: itemWidth,
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: Column(
                children: [
                  CachedNetworkImage(
                    imageUrl: image,
                    width: itemWidth,
                    height: itemHeight * 0.85,
                    //placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                  Text(
                    name,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
