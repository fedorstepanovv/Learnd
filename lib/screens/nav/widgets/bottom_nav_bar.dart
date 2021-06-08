import 'package:flutter/material.dart';
import 'package:learnd/config/color_pallete.dart';
import 'package:learnd/enums/enums.dart';

class BottomNavBar extends StatelessWidget {
  final Map<BottomNavItem, IconData> items;
  final BottomNavItem selectedItem;
  final Function(int) onTap;
  const BottomNavBar({Key key, this.items, this.selectedItem, this.onTap})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: ColorPallete.backgroundColor,
      selectedItemColor: Colors.white,
      
      showSelectedLabels: false,
      showUnselectedLabels: false,
      onTap: onTap,
      unselectedItemColor: Colors.grey,
      currentIndex: BottomNavItem.values.indexOf(selectedItem),
        items: items
            .map((item, icon) => MapEntry(
                item.toString(),
                BottomNavigationBarItem(
                    label: '',
                    icon: Icon(
                      icon,
                      size: 30.0,
                    ))))
            .values
            .toList());
  }
}
