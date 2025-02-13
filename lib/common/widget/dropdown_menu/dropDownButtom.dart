import 'package:flutter/material.dart';

import 'bottomSheetDropDown.dart';

class DropdownButtonWidget extends StatelessWidget {
  const DropdownButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
      ),
      child: ElevatedButton(
        onPressed: () {
          _showDropdownOptions(context);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xff07833D),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(16),bottomRight: Radius.circular(16)),
          ),
        ),
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '1 Ltr',
                style: TextStyle(fontSize: 16,color: Colors.white,fontWeight: FontWeight.bold),
              ),
              Icon(Icons.arrow_drop_down,color: Colors.white,),
            ],
          ),
        ),
      ),
    );
  }

  void _showDropdownOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return const BottomSheetWidget();
      },
    );
  }
}