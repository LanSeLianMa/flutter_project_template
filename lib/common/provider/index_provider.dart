import 'package:flutter/material.dart';

class IndexProvider with ChangeNotifier {
  int _index = 0;
  late PageController pageController;

  int get index => _index;

  set index(int value) {
    _index = value;
    pageController.jumpToPage(_index);
  }

  IndexProvider(){
    pageController = PageController(initialPage: _index);
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

}