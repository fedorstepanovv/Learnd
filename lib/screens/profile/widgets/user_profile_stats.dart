import 'package:flutter/material.dart';
import 'package:learnd/config/color_pallete.dart';
import 'package:learnd/screens/profile/widgets/widgets.dart';

class UserProfileStats extends StatelessWidget {
  final username;
  final isCurrentUser;
  const UserProfileStats({
    Key key,
    @required this.username,
    @required this.isCurrentUser,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          username,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600,letterSpacing: 0.5,color: ColorPallete.lightButtonColor),
        ),
        SizedBox(height: 2,),
        ProfileButton(
          isCurrentUser: isCurrentUser,
        ),
      ],
    );
  }
}
