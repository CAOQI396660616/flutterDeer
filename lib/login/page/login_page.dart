import 'package:flutter/foundation.dart';
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

  bool get _canSignIn => _acceptedTerms;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(color: const Color(0xFF14C9D0)),
          Opacity(
            opacity: .28,
            child: Image.asset(
              'assets/images/login_social/bg_login.png',
              fit: BoxFit.cover,
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
                          asset: 'ic_login_google.png',
                          label: 'Google ile Giriş',
                          onPressed: _canSignIn ? () => _showUnavailable(context) : null,
                        ),
                        const SizedBox(height: 16),
                        _SocialButton(
                          asset: 'ic_login_facebook.png',
                          label: 'Facebook ile Giriş',
                          onPressed: _canSignIn ? () => _showUnavailable(context) : null,
                        ),
                        const SizedBox(height: 16),
                        _SocialButton(
                          asset: 'ic_login_email.png',
                          label: 'Kolay Giriş',
                          onPressed: _canSignIn ? () => Navigator.pushNamed(context, '/login/smsLogin') : null,
                        ),
                        const SizedBox(height: 28),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            _SmallLoginButton(
                              icon: Icons.lock_outline,
                              label: 'Hesap\nŞifresi',
                              enabled: _canSignIn,
                              onPressed: _canSignIn ? () => _showUnavailable(context) : null,
                            ),
                            if (defaultTargetPlatform == TargetPlatform.iOS) ...<Widget>[
                              const SizedBox(width: 18),
                              _SmallLoginButton(
                                icon: Icons.apple,
                                label: 'Apple',
                                enabled: _canSignIn,
                                onPressed: _canSignIn ? () => _showUnavailable(context) : null,
                              ),
                            ],
                          ],
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
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 24),
    child: SizedBox(
      height: 60,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: onPressed == null ? Colors.white.withOpacity(.38) : Colors.white,
          foregroundColor: const Color(0xFF1F2529),
          elevation: 0,
          shape: const StadiumBorder(),
          padding: const EdgeInsets.symmetric(horizontal: 18),
        ),
        child: Row(
          children: <Widget>[
            Image.asset('assets/images/login_social/$asset', width: 22, height: 22),
            Expanded(child: Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500))),
            const SizedBox(width: 22),
          ],
        ),
      ),
    ),
  );
}

class _SmallLoginButton extends StatelessWidget {
  const _SmallLoginButton({required this.icon, required this.label, required this.enabled, required this.onPressed});
  final IconData icon;
  final String label;
  final bool enabled;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: 58,
    child: Column(
      children: <Widget>[
        InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(30),
          child: CircleAvatar(
            radius: 27,
            backgroundColor: Colors.white.withOpacity(enabled ? .18 : .08),
            child: Icon(icon, size: 22, color: Colors.white.withOpacity(enabled ? .95 : .45)),
          ),
        ),
        const SizedBox(height: 4),
        Text(label, textAlign: TextAlign.center, style: TextStyle(color: Colors.white.withOpacity(enabled ? .9 : .45), fontSize: 10, height: 1.1)),
      ],
    ),
  );
}
