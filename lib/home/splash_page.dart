import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_deer/demo/demo_page.dart';
import 'package:flutter_deer/login/login_router.dart';
import 'package:flutter_deer/login/store/login_user_store.dart';
import 'package:flutter_deer/routers/fluro_navigator.dart';
import 'package:flutter_deer/routers/routers.dart';
import 'package:flutter_deer/util/app_navigator.dart';
import 'package:flutter_deer/util/device_utils.dart';
import 'package:flutter_deer/util/theme_utils.dart';
import 'package:flutter_deer/widgets/load_image.dart';
import 'package:quick_actions/quick_actions.dart';
import 'package:sp_util/sp_util.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  StreamSubscription<dynamic>? _subscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      /// 两种初始化方案，另一种见 main.dart
      /// 两种方法各有优劣
      await SpUtil.getInstance();
      await Device.initDeviceInfo();
      _initSplash();
    });

    if (Device.isAndroid) {
      const QuickActions quickActions = QuickActions();
      quickActions.initialize((String shortcutType) async {
        if (shortcutType == 'demo') {
          AppNavigator.pushReplacement(context, const DemoPage());
          _subscription?.cancel();
        }
      });
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  void _initSplash() {
    _goLogin();
  }

  void _goLogin() {
    NavigatorUtils.push(
        context, LoginUserStore.currentUser == null ? LoginRouter.loginPage : Routes.home,
        replace: true);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        color: context.backgroundColor,
        child: const Center(
          child: SizedBox(
            width: 180.0,
            height: 180.0,
            child: LoadAssetImage(
              'splash_logo',
              fit: BoxFit.contain,
            ),
          ),
        ));
  }
}
