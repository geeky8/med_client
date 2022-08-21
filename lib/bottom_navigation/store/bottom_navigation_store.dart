import 'package:mobx/mobx.dart';

part 'bottom_navigation_store.g.dart';

class BottomNavigationStore = _BottomNavigationStore
    with _$BottomNavigationStore;

abstract class _BottomNavigationStore with Store {
  /// current screen
  @observable
  int currentPage = 0;
}
