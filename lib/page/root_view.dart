import 'package:flutter/material.dart';
import 'package:flutter_project_template/common/provider/index_provider.dart';
import 'package:provider/provider.dart';

class RootView extends StatefulWidget {
  static const String path = "/";
  const RootView({Key? key}) : super(key: key);

  @override
  _RootViewState createState() => _RootViewState();
}

class _RootViewState extends State<RootView> {

  List<Widget> pages() {
    List<Widget> _totalPages = [];
    _totalPages.add(Builder(builder: (_) => const TestPage01()));
    _totalPages.add(Builder(builder: (_) => const TestPage02()));
    _totalPages.add(Builder(builder: (_) => const TestPage03()));
    return _totalPages;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<IndexProvider>(
          builder: (context, indexProvider, child) {
            return PageView(
              physics: const NeverScrollableScrollPhysics(),
              controller: indexProvider.pageController,
              children: pages(),
            );
          }
      ),
      bottomNavigationBar: Consumer<IndexProvider>(
        builder: (context, indexProvider, child) {
          return BBottomNavigationBar(myPageController: indexProvider.pageController);
        },
      )
    );
  }
}

class BBottomNavigationBar extends StatefulWidget {
  final PageController myPageController;

  const BBottomNavigationBar({Key? key, required this.myPageController}) : super(key: key);
  @override
  _BBottomNavigationBarState createState() => _BBottomNavigationBarState();
}

class _BBottomNavigationBarState extends State<BBottomNavigationBar> {
  int currentIndex = 0;
  List<String> activeIcon = [
    'assets/images/home_tabBar_icon/home_active.png',
    'assets/images/home_tabBar_icon/exchange_active.png',
    'assets/images/home_tabBar_icon/personal_active.png',
  ];
  List<String> defaultIcon = [
    'assets/images/home_tabBar_icon/home.png',
    'assets/images/home_tabBar_icon/exchange.png',
    'assets/images/home_tabBar_icon/personal.png',
  ];

  @override
  void didUpdateWidget(BBottomNavigationBar oldWidget) {
    oldWidget.myPageController.removeListener(_listener);
    widget.myPageController.addListener(_listener);
    super.didUpdateWidget(oldWidget);
  }

  void _listener() {
    var index = widget.myPageController.page!.round();
    if (currentIndex == index || !mounted) {
      return;
    }
    setState(() {
      currentIndex = index;
    });
  }

  List<BottomNavigationBarItem> items() {
    List<BottomNavigationBarItem> items = [];
    items.add(
        buildBottomNavigationBarItem(defaultIcon[0], activeIcon[0], '首页'));
    items.add(
        buildBottomNavigationBarItem(defaultIcon[1], activeIcon[1], '兑换'));
    items
      .add(buildBottomNavigationBarItem(defaultIcon[2], activeIcon[2], '我的'));
    return items;
  }

  BottomNavigationBarItem buildBottomNavigationBarItem(
      String url, String twoUrl, String title) {
    return BottomNavigationBarItem(
      icon: IW(url: url),
      activeIcon: IW(url: twoUrl),
      title: Text(title),
    );
  }

  void _onTap(int index) {
    setState(() {
      currentIndex = index;
      widget.myPageController.jumpToPage(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: BottomNavigationBar(
        items: items(),
        onTap: _onTap,
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        iconSize: 22,
        showUnselectedLabels: true,
        showSelectedLabels: true,
      ),
    );
  }
}

class IW extends StatelessWidget {
  final String url;
  const IW({Key? key, required this.url}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 0),
      height: 22,
      width: 22,
      child: Image(
        image: AssetImage(url),
        width: 22,
        height: 22,
      ),
    );
  }
}

class TestPage01 extends StatefulWidget {
  const TestPage01({Key? key}) : super(key: key);

  @override
  _TestPage01State createState() => _TestPage01State();
}

class _TestPage01State extends State<TestPage01> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Page01')),
    );
  }
}

class TestPage02 extends StatefulWidget {
  const TestPage02({Key? key}) : super(key: key);

  @override
  _TestPage02State createState() => _TestPage02State();
}

class _TestPage02State extends State<TestPage02> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Page02')),
    );
  }
}

class TestPage03 extends StatefulWidget {
  const TestPage03({Key? key}) : super(key: key);

  @override
  _TestPage03State createState() => _TestPage03State();
}

class _TestPage03State extends State<TestPage03> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Page03')),
    );
  }
}