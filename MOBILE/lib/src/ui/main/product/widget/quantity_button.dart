import 'package:base_code/src/api/global_api.dart';
import 'package:base_code/src/models/product/product.dart';
import 'package:base_code/src/struct/app_color.dart';
import 'package:flutter/material.dart';

import '../../../../models/product/product_size/product_size.dart';

class QuantityButton extends StatefulWidget {
  QuantityButton({this.value = 1,required this.product,  this.indexProductSize , Key? key}) : super(key: key);
  int value;
  Product product;
  int? indexProductSize;

  @override
  State<QuantityButton> createState() => _QuantityButtonState();
}

class _QuantityButtonState extends State<QuantityButton> {
  @override
  Widget build(BuildContext context) {
    const Color buttonColor = AppColors.primay;
    return Container(
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              if(widget.value < 2){
                setState(() {
                  widget.value == 1;
                });
              }else{
                setState(() {
                  widget.value--;
                });
              }
            },
            icon: const Text('-'),
            iconSize: 10,
            splashRadius: 12,
          ),
          Text('${widget.value}'),
          IconButton(
            onPressed: () {
              if(widget.value > widget.product.productSizes![widget.indexProductSize!].quantity!){
                setState(() {
                  widget.value == widget.product.productSizes![widget.indexProductSize!].quantity;
                });
              }else{
                setState(() {
                    widget.value++;
                });
              }
            },
            icon: const Text('+'),
            iconSize: 10,
            splashRadius: 12,
          ),
        ],
      ),
      decoration: BoxDecoration(
          border: Border.all(color: buttonColor),
          borderRadius: BorderRadius.circular(50)),
      // style: OutlinedButton.styleFrom(
      //     side: const BorderSide(color: buttonColor),
      //     shape: const StadiumBorder(),
      //     primary: buttonColor),
    );
  }
}
