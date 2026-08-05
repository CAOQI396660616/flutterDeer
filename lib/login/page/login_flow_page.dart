import 'package:flutter/material.dart';
import 'package:flutter_deer/login/page/complete_profile_ai_page.dart';
import 'package:flutter_deer/login/page/complete_profile_gender_page.dart';
import 'package:flutter_deer/login/page/login_page.dart';
import 'package:flutter_deer/routers/routers.dart';

/// Keeps login and profile completion inside one route.
class LoginFlowPage extends StatefulWidget {
  const LoginFlowPage({super.key});

  @override
  State<LoginFlowPage> createState() => _LoginFlowPageState();
}

class _LoginFlowPageState extends State<LoginFlowPage> {
  final PageController _pageController = PageController();
  String? _gender;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goTo(int page) {
    _pageController.animateToPage(page, duration: const Duration(milliseconds: 420), curve: Curves.easeOutCubic);
  }

  @override
  Widget build(BuildContext context) => PageView(
    controller: _pageController,
    physics: const NeverScrollableScrollPhysics(),
    children: <Widget>[
      LoginPage(onLoginComplete: (_) => _goTo(1)),
      CompleteProfileGenderPage(
        onBack: () => _goTo(0),
        onNext: (gender) {
          setState(() => _gender = gender);
          _goTo(2);
        },
      ),
      CompleteProfileAiPage(
        gender: _gender ?? 'male',
        onBack: () => _goTo(1),
        onComplete: () => Navigator.of(context).pushNamedAndRemoveUntil(Routes.home, (_) => false),
      ),
    ],
  );
}
