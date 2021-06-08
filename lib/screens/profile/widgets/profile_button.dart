import 'package:flutter/material.dart';
import 'package:learnd/config/color_pallete.dart';
import 'package:learnd/screens/edit_profile/edit_profile_screen.dart';

class ProfileButton extends StatelessWidget {
  final bool isCurrentUser;

  const ProfileButton({Key key, @required this.isCurrentUser})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isCurrentUser
        ? TextButton(
            style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(ColorPallete.darkTextColor),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ))),
            onPressed: () {
              Navigator.of(context).pushNamed(EditProfileScreen.routeName,
                  arguments: EditProfileScreenArgs(context: context));
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical:0,horizontal: 14),
              child: Text('Edit Profile',style: TextStyle(color: ColorPallete.lightButtonColor,fontSize: 14)),
            ),
          )
        : TextButton(
            child: Text('Go chat'),
            onPressed: () {},
          );
  }
}
