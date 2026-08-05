import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
/// Hiplay social sign-in page.
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _acceptedTerms = true;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(color: const Color(0xFF14C9D0)),
          Opacity(
            opacity: .14,
            child: Image.asset(
              'assets/images/login_social/bg_login.png',
              fit: BoxFit.cover,
              color: Colors.white,
              colorBlendMode: BlendMode.srcIn,
            ),
          ),
          SafeArea(
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                final double logoTop = constraints.maxHeight * .19;
                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight),
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: logoTop),
                        Image.asset(
                          'assets/images/login_social/ic_launcher.png',
                          width: 88,
                          height: 88,
                        ),
                        const SizedBox(height: 6),
                        Image.asset(
                          'assets/images/login_social/ic_packet_logo.webp',
                          width: 86,
                          height: 32,
                          fit: BoxFit.contain,
                        ),
                        SizedBox(height: constraints.maxHeight * .09),
                        _SocialButton(
                          asset: 'ic_login_facebook.png',
                          label: 'Sign in with Facebook',
                          onPressed: () => _showUnavailable(context),
                        ),
                        const SizedBox(height: 16),
                        _SocialButton(
                          asset: 'ic_login_google.png',
                          label: 'Sign in with Google',
                          onPressed: () => _showUnavailable(context),
                        ),
                        const SizedBox(height: 16),
                        _SocialButton(
                          asset: 'ic_login_email.png',
                          label: 'Sign in with Email',
                          onPressed: () => Navigator.pushNamed(context, '/login/smsLogin'),
                        ),
                        SizedBox(height: constraints.maxHeight * .12),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 32),
                          child: GestureDetector(
                            onTap: () => setState(() => _acceptedTerms = !_acceptedTerms),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(top: 1, right: 5),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 150),
                                    width: 16,
                                    height: 16,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: _acceptedTerms ? Colors.white : Colors.transparent,
                                      border: Border.all(color: Colors.white, width: 1.5),
                                    ),
                                    child: _acceptedTerms
                                        ? const Icon(Icons.check, size: 12, color: Color(0xFF14C9D0))
                                        : null,
                                  ),
                                ),
                                Text(
                                  'By signing up or logging in,you accept our\nTerms of service and Privacy Policy.',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(color: Colors.white.withOpacity(.9), fontSize: 12, height: 1.35),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  static void _showUnavailable(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Sign-in service is not configured yet')));
  }
}

class _SocialButton extends StatelessWidget {
  const _SocialButton({required this.asset, required this.label, required this.onPressed});
  final String asset;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 46,
    width: double.infinity,
    child: ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1F2529),
        elevation: 0,
        shape: const StadiumBorder(),
        padding: const EdgeInsets.symmetric(horizontal: 14),
      ),
      child: Row(
        children: <Widget>[
          Image.asset('assets/images/login_social/$asset', width: 22, height: 22),
          Expanded(child: Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500))),
          const SizedBox(width: 22),
        ],
      ),
    ),
  );
}
