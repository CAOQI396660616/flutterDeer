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
  int _currentPage = 0;
  String? _gender;

  void _goTo(int page) {
    if (_currentPage == page) {
      return;
    }
    setState(() => _currentPage = page);
  }

  @override
  Widget build(BuildContext context) => Stack(
    fit: StackFit.expand,
    children: <Widget>[
      _buildStage(0, LoginPage(onLoginComplete: (_) => _goTo(1))),
      _buildStage(
        1,
        CompleteProfileGenderPage(
          onBack: () => _goTo(0),
          onNext: (gender) {
            setState(() {
              _gender = gender;
              _currentPage = 2;
            });
          },
        ),
      ),
      _buildStage(
        2,
        CompleteProfileAiPage(
          gender: _gender ?? 'male',
          onBack: () => _goTo(1),
          onComplete: () => Navigator.of(context).pushNamedAndRemoveUntil(Routes.home, (_) => false),
        ),
      ),
    ],
  );

  Widget _buildStage(int page, Widget child) => IgnorePointer(
    ignoring: _currentPage != page,
    child: AnimatedOpacity(
      opacity: _currentPage == page ? 1 : 0,
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeInOut,
      child: child,
    ),
  );
}
