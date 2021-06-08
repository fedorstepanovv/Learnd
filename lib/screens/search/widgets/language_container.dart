import 'package:flutter/material.dart';

class LanguageContainer extends StatelessWidget {
  final String language;

  const LanguageContainer({Key key, @required this.language}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(7),
          child: Container(
            color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Text(language,style: TextStyle(fontSize: 17,color: Colors.black),),
        ),
      ),
    );
  }
}