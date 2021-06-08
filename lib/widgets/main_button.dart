import 'package:flutter/material.dart';
import 'package:learnd/config/color_pallete.dart';

class MainButton extends StatelessWidget {
  final Function onTap;
  final String text;

  const MainButton({Key key, @required this.onTap, @required this.text})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(ColorPallete.lightButtonColor),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(17),
          ),
        ),
      ),
      onPressed: onTap,
      child: Text(
        text,
        style: const TextStyle(color: ColorPallete.darkTextColor),
      ),
    );
  }
}
