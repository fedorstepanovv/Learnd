import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:learnd/enums/enums.dart';
import 'package:meta/meta.dart';

part 'bottom_nav_bar_state.dart';

class BottomNavBarCubit extends Cubit<BottomNavBarState> {
  BottomNavBarCubit() : super(BottomNavBarState(selectedItem: BottomNavItem.search));
  void updateSelectedItem(BottomNavItem item) {
    if(item != state.selectedItem) {
      emit(BottomNavBarState(selectedItem: item));
    }
  }
}
