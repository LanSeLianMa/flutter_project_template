import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project_template/common/utils/viewmodel/viewmodel_provider.dart';
import 'package:flutter_project_template/common/widget/my_button.dart';
import 'package:flutter_project_template/generated/l10n.dart';
import 'package:flutter_project_template/page/list_refresh_load.dart';
import 'package:flutter_project_template/page/login.dart';
import 'package:flutter_project_template/page/root_view.dart';
import 'package:flutter_project_template/page/test_bugly.dart';
import 'package:flutter_project_template/router/routers.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MyButton(
              textContent: S.of(context).login,
              onTap: () {
                Navigator.push<void>(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => const Login(),
                  ),
                );
              },
            ),
            MyButton(
              textContent: '测试FlutterBugly',
              onTap: () {
                Navigator.push<void>(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => const TestBugly(),
                  ),
                );
              },
            ),
            Container(
              width: 200.w,
              height: 50.h,
              color: Colors.cyan,
              alignment: Alignment.center,
              child: Text(
                '测试：flutter_screenutil',
                style: TextStyle(fontSize: 16.sp,fontWeight: FontWeight.w600),
              ),
            ),
            Container(
              width: 1.sw, // 填充屏幕宽度
              height: 50.h,
              color: Colors.deepOrangeAccent,
              alignment: Alignment.center,
              child: Text(
                '测试：flutter_screenutil',
                style: TextStyle(fontSize: 16.sp),
              ),
            ),
            MyButton(
              textContent: '底部导航',
              onTap: () {
                Navigator.push<void>(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => const RootView(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
