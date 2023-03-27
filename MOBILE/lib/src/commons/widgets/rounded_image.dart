import 'package:base_code/src/struct/app_color.dart';
import 'package:flutter/material.dart';

class RoundedImage extends StatelessWidget {
  const RoundedImage(
      {this.radius = 50,
      this.width = 150,
      this.height = 150,
      required this.url,
      Key? key})
      : super(key: key);
  final double radius;
  final double width;
  final double height;
  final String url;
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: Image.network(
        url,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: width,
            height: height,
            color: AppColors.pink,
          );
        },
      ),
    );
  }
}
