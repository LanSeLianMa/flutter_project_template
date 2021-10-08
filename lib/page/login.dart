import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_project_template/common/http/http_manager.dart';
import 'package:flutter_project_template/page/test_router.dart';

import '../common/hiv/hiv_manager.dart';
import '../common/hiv/hiv_name.dart';
import '../common/token/token_model.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController accountController = TextEditingController()
    ..text = '18767169172';

  TextEditingController passwordController = TextEditingController()
    ..text = '202001';

  CancelToken? cancelToken;

  @override
  void initState() {
    super.initState();
    cancelToken = CancelToken();
  }

  login() async {
    await HttpManager().request(
        cancelToken: cancelToken,
        initData: true,
        type: RequestType.post,
        api: 'api/v2/logins/code',
        parameter: {
          'tel': accountController.text,
          'code': passwordController.text
        },
        successCallback: (result) {
          TokenModel token = TokenModel().toJson(result.data);
          HivManager.saveDataLocal<TokenModel>(token, HivName.tokenModel);
          Navigator.push<void>(
            context,
            MaterialPageRoute<void>(
              builder: (BuildContext context) => const TestRouter(),
            ),
          );
        });
  }

  @override
  void dispose() {
    accountController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, //输入框抵住键盘，防止键盘弹出 导致超出屏幕
      body: Center(
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height / 5),
            Image.asset('assets/images/login/logo.png'),
            const SizedBox(height: 40),
            Container(
              height: 56,
              margin: const EdgeInsets.symmetric(horizontal: 32),
              decoration: BoxDecoration(
                  color: const Color.fromRGBO(240, 240, 240, 1),
                  borderRadius: BorderRadius.circular(30)),
              constraints: const BoxConstraints(maxWidth: 400),
              child: TextField(
                controller: accountController,
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.black,
                ),
                decoration: const InputDecoration(
                  hintText: '请输入账号',
                  hintStyle: TextStyle(
                      fontSize: 15, color: Color.fromRGBO(144, 147, 153, 1)),
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                  contentPadding: EdgeInsets.only(left: 30, right: 30, top: 35),
                ),
                inputFormatters: [
                  WhitelistingTextInputFormatter(RegExp("^[1-9][0-9]{0,10}"))
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              height: 56,
              margin: const EdgeInsets.symmetric(horizontal: 32),
              decoration: BoxDecoration(
                  color: const Color.fromRGBO(240, 240, 240, 1),
                  borderRadius: BorderRadius.circular(30)),
              constraints: const BoxConstraints(maxWidth: 400),
              child: TextField(
                controller: passwordController,
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.black,
                ),
                decoration: const InputDecoration(
                  hintText: '请输入验证码',
                  hintStyle: TextStyle(
                      fontSize: 15, color: Color.fromRGBO(144, 147, 153, 1)),
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                  contentPadding: EdgeInsets.only(left: 30, right: 30, top: 35),
                ),
                inputFormatters: [
                  WhitelistingTextInputFormatter(RegExp("^[1-9][0-9]{0,5}"))
                ],
              ),
            ),
            const SizedBox(height: 38),
            InkWell(
              onTap: login,
              child: Container(
                height: 48,
                margin: const EdgeInsets.symmetric(horizontal: 52),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: const [
                      BoxShadow(color: Color.fromRGBO(255, 70, 40, 1)),
                      BoxShadow(color: Color.fromRGBO(247, 44, 44, 1))
                    ]),
                constraints: const BoxConstraints(maxWidth: 300),
                alignment: Alignment.center,
                child: const Text('登录',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        letterSpacing: 1,
                        fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
