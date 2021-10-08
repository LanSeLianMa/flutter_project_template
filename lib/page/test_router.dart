import 'package:flutter/material.dart';
import 'package:flutter_project_template/common/utils/permission/permission_manager.dart';
import 'package:flutter_project_template/common/utils/viewmodel/viewmodel_provider.dart';
import 'package:flutter_project_template/common/widget/my_button.dart';
import 'package:flutter_project_template/config/main/env/my_home_page.dart';
import 'package:flutter_project_template/router/routers.dart';

import 'home/home_page01.dart';
import 'home/home_page02.dart';
import 'list_refresh_load.dart';
import 'order/order_page01.dart';
import 'order/order_page02.dart';

class TestRouter extends StatefulWidget {
  const TestRouter({Key? key}) : super(key: key);

  @override
  State<TestRouter> createState() => _TestRouterState();
}

class _TestRouterState extends State<TestRouter> {
  @override
  void initState() {
    super.initState();
    PermissionManager().getPermissions(
      types: [
        PermissionType.camera,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: MyButton(
                textContent: '跳转HomePage01页面',
                onTap: () {
                  Routers.push(
                    HomePage01.path,
                    context,
                    parameter: {'model': TestModel()},
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: MyButton(
                textContent: '跳转HomePage02页面',
                onTap: () {
                  Routers.push(HomePage02.path, context);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: MyButton(
                textContent: '跳转OrderPage01页面',
                onTap: () {
                  Routers.push(
                    OrderPage01.path,
                    context,
                    parameter: {'model': TestModel()},
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: MyButton(
                textContent: '跳转OrderPage02页面',
                onTap: () {
                  Routers.push(OrderPage02.path, context);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: MyButton(
                textContent: '跳转ListRefreshLoad页面',
                onTap: () {
                  Routers.push(
                    ViewModelProvider.path,
                    context,
                    parameter: {'widget': const ListRefreshLoad()},
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: MyButton(
                textContent: '返回登录页面',
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MyHomePage()),
                      ModalRoute.withName('')); //不要写 null
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TestModel {
  String name = '张三';

  @override
  String toString() {
    return 'TestModel{name: $name}';
  }
}
