import 'package:flutter/material.dart';
import 'package:learnd/config/color_pallete.dart';

class SearchContainer extends StatelessWidget {
  final String name;
  final Function onTap;
  const SearchContainer({
    Key key,
    @required this.name,
    @required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          color: ColorPallete.lightButtonColor,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              name,
              style: TextStyle(color: ColorPallete.darkTextColor,fontSize: 16,fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ),
    );
  }
}
