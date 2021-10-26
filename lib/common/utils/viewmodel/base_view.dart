import 'package:flutter/material.dart';

///
/// 页面 基类
///
abstract class BaseView extends StatefulWidget {
  /// app bar title
  String get title => '';

  /// app bar automaticallyImplyLeading
  bool get automaticallyImplyLeading => true;

  /// 是否自动创建 AppBar
  bool get automaticallyImplyAppBar => true;

  BaseView({Key? key}) : super(key: key);
}

abstract class BaseViewState<T extends BaseView> extends State<T> {
  Color get backgroundColor => Colors.white;

  void onTap() {
    clearFocus();
  }

  void clearFocus() {
    FocusScope.of(context).unfocus();
  }

  /// bottomNavigationBar
  Widget? get bottomNavigationBar => null;

  /// 页面 builder
  Widget buildPage(BuildContext context);

  /// app bar action builder
  List<Widget>? actionBuilder(BuildContext context) {
    return null;
  }

  /// App bar
  PreferredSizeWidget? get appBar => null;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Scaffold(
        appBar: widget.automaticallyImplyAppBar
            ? AppBar(
          title: Text(
              widget.title,
              style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 18)),
          elevation: 1,
          centerTitle: true,
          leading: widget.automaticallyImplyLeading ? RaisedButton(
              child: Text('test'),
              onPressed: (){}) : null,
          backgroundColor: backgroundColor,
        )
            : appBar,
        body: buildPage(context),
        backgroundColor: backgroundColor,
        bottomNavigationBar: bottomNavigationBar,
      ),
    );
  }
}

abstract class BaseKeepAlivePageState<T extends BaseView> extends BaseViewState<T> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GestureDetector(
      onTap: onTap,
      child: Scaffold(
        appBar: widget.automaticallyImplyAppBar
            ? AppBar(
          title: Text(widget.title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
          centerTitle: true,
          leading: widget.automaticallyImplyLeading ? RaisedButton(
              child: Text('test'),
              onPressed: (){}) : null,
          backgroundColor: backgroundColor,
        )
            : appBar,
        body: buildPage(context),
        backgroundColor: backgroundColor,
        bottomNavigationBar: bottomNavigationBar,
      ),
    );
  }
}

