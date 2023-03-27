import 'package:base_code/src/models/product/category/category.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class SliderWidget extends StatelessWidget {
  const SliderWidget({this.controller, this.listImage, Key? key})
      : super(key: key);
  final CarouselController? controller;
  final List<Category>? listImage;
  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      carouselController: controller,
      options: CarouselOptions(height: 300.0, viewportFraction: 1),
      items: listImage?.map((image) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(50))),
                child: Image.network(image.url!));
          },
        );
      }).toList(),
    );
  }
}
