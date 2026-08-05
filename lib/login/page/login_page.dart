import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_deer/res/constant.dart';
import 'package:sp_util/sp_util.dart';
/// Hiplay social sign-in page.
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _acceptedTerms = true;
  bool _hasMockUser = false;

  bool get _canSignIn => _acceptedTerms;

  @override
  void initState() {
    super.initState();
    _hasMockUser = SpUtil.getBool(Constant.mockLoginUser) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    return Scaffold(
      // The phone sheet handles the keyboard inset itself. Keep the two-region
      // login page fixed so the background page cannot overflow behind it.
      resizeToAvoidBottomInset: false,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(color: const Color(0xFF14C9D0)),
          Positioned.fill(
            child: Image.asset(
              'assets/images/login_social/bg_login.png',
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: Column(
              children: <Widget>[
                // Region 1: occupies all remaining space; the brand stays centered here.
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        _buildProfileHeader(),
                      ],
                    ),
                  ),
                ),
                // Region 2: intrinsic-height content anchored to the bottom.
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      _SocialLoginGroup(
                        enabled: _canSignIn,
                        onPhonePressed: () => _showPhoneLoginSheet(context),
                        onSocialLogin: () => _mockLogin(context),
                      ),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          _SmallLoginButton(
                            icon: Icons.lock_outline,
                            label: 'Hesap\nŞifresi',
                            enabled: _canSignIn,
                            onPressed: _canSignIn ? () => _showPasswordLoginSheet(context) : null,
                          ),
                          if (defaultTargetPlatform == TargetPlatform.iOS) ...<Widget>[
                            const SizedBox(width: 18),
                            _SmallLoginButton(
                              icon: Icons.apple,
                              label: 'Apple',
                              enabled: _canSignIn,
                              onPressed: _canSignIn ? () => _mockLogin(context) : null,
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 30),
                      _TermsAgreement(
                        accepted: _acceptedTerms,
                        onTap: () => setState(() => _acceptedTerms = !_acceptedTerms),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static void _showUnavailable(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Demo giriş tamamlandı')));
  }

  Widget _buildProfileHeader() {
    if (!_hasMockUser) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Image.asset('assets/images/login_social/ic_launcher.png', width: 88, height: 88),
          const SizedBox(height: 6),
          Image.asset('assets/images/login_social/ic_packet_logo.webp', width: 86, height: 32, fit: BoxFit.contain),
        ],
      );
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Stack(
          clipBehavior: Clip.none,
          children: <Widget>[
            Container(
              width: 104,
              height: 104,
              padding: const EdgeInsets.all(1),
              decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
              child: ClipOval(child: _buildMockAvatar()),
            ),
            Positioned(
              right: -10,
              top: 4,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: <Color>[Color(0xFFFFD166), Color(0xFFFF8A5B), Color(0xFFE85D9E)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  border: Border.all(color: Colors.white, width: 1),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const <BoxShadow>[
                    BoxShadow(color: Color(0x66000000), blurRadius: 4, offset: Offset(0, 2)),
                  ],
                ),
                child: const Text('Last', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(SpUtil.getString(Constant.mockLoginUserName) ?? 'Kral Şakir', style: const TextStyle(color: Colors.white, fontSize: 20)),
      ],
    );
  }

  Widget _buildMockAvatar() {
    final String? avatarUrl = SpUtil.getString(Constant.mockLoginUserAvatarUrl);
    if (avatarUrl == null || avatarUrl.isEmpty) {
      return Image.asset('assets/images/order/icon_avatar.png', fit: BoxFit.cover);
    }
    return Image.network(
      avatarUrl,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => Image.asset('assets/images/order/icon_avatar.png', fit: BoxFit.cover),
    );
  }

  void _mockLogin(BuildContext context) {
    SpUtil.putBool(Constant.mockLoginUser, true);
    SpUtil.putString(Constant.mockLoginUserName, 'Kral Şakir');
    SpUtil.putString(Constant.mockLoginUserAvatar, 'assets/images/order/icon_avatar.png');
    SpUtil.putString(Constant.mockLoginUserAvatarUrl, 'https://randomuser.me/api/portraits/men/32.jpg');
    setState(() => _hasMockUser = true);
    _showUnavailable(context);
  }

  void _showPhoneLoginSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _PhoneLoginSheet(onMockLogin: () => _mockLogin(context)),
    );
  }

  void _showPasswordLoginSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _PasswordLoginSheet(onMockLogin: () => _mockLogin(context)),
    );
  }
}

class _SocialLoginGroup extends StatelessWidget {
  const _SocialLoginGroup({required this.enabled, required this.onPhonePressed, required this.onSocialLogin});
  final bool enabled;
  final VoidCallback onPhonePressed;
  final VoidCallback onSocialLogin;

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      _SocialButton(
        asset: 'ic_login_google.png',
        label: 'Google ile Giriş',
        onPressed: enabled ? onSocialLogin : null,
      ),
      const SizedBox(height: 16),
      _SocialButton(
        asset: 'ic_login_facebook.png',
        label: 'Facebook ile Giriş',
        onPressed: enabled ? onSocialLogin : null,
      ),
      const SizedBox(height: 16),
      _SocialButton(
        label: 'Kolay Giriş',
        icon: Icons.phone,
        onPressed: enabled ? onPhonePressed : null,
      ),
    ],
  );
}

class _PhoneLoginSheet extends StatefulWidget {
  const _PhoneLoginSheet({required this.onMockLogin});
  final VoidCallback onMockLogin;

  @override
  State<_PhoneLoginSheet> createState() => _PhoneLoginSheetState();
}

class _PhoneLoginSheetState extends State<_PhoneLoginSheet> {
  final TextEditingController _phoneController = TextEditingController();
  final FocusNode _phoneFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // Let the bottom-sheet entrance animation finish before opening the keyboard.
    Future<void>.delayed(const Duration(milliseconds: 350), () {
      if (mounted) {
        _phoneFocusNode.requestFocus();
      }
    });
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _phoneFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool canContinue = _phoneController.text.isNotEmpty;
    return AnimatedPadding(
      duration: const Duration(milliseconds: 180),
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: Material(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                IconButton(
                  padding: EdgeInsets.zero,
                  alignment: Alignment.centerLeft,
                  icon: const Icon(Icons.chevron_left, color: Color(0xFF4A4A4A), size: 28),
                  onPressed: () => Navigator.pop(context),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Telefon Giriş / Kayıt',
                  style: TextStyle(fontSize: 26, color: Color(0xFF252525), fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Kayıtlı değilseniz, doğrulama SMS'i otomatik gönderilir.",
                  style: TextStyle(fontSize: 13, color: Color(0xFF777777)),
                ),
                const SizedBox(height: 24),
                Container(
                  height: 60,
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFF999999)),
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child: Row(
                    children: <Widget>[
                      const SizedBox(width: 22),
                      const Text('+90', style: TextStyle(fontSize: 16, color: Color(0xFF999999))),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 14),
                        child: Text('|', style: TextStyle(color: Color(0xFFCCCCCC), fontSize: 22)),
                      ),
                      Expanded(
                        child: TextField(
                          controller: _phoneController,
                          focusNode: _phoneFocusNode,
                          maxLength: 10,
                          keyboardType: TextInputType.phone,
                          inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                          textInputAction: TextInputAction.done,
                          onChanged: (_) => setState(() {}),
                          decoration: const InputDecoration(
                            hintText: 'Telefon numarası',
                            hintStyle: TextStyle(color: Color(0xFFAAAAAA), fontSize: 16),
                            border: InputBorder.none,
                            counterText: '',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: GestureDetector(
                    onTap: canContinue
                        ? () {
                            Navigator.pop(context);
                            widget.onMockLogin();
                          }
                        : null,
                    child: CircleAvatar(
                      radius: 30,
                      backgroundColor: canContinue ? const Color(0xFF14C9D0) : const Color(0xFFD0D0D0),
                      child: const Icon(Icons.arrow_forward, color: Colors.white, size: 32),
                    ),
                  ),
                ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

}

class _PasswordLoginSheet extends StatefulWidget {
  const _PasswordLoginSheet({required this.onMockLogin});
  final VoidCallback onMockLogin;

  @override
  State<_PasswordLoginSheet> createState() => _PasswordLoginSheetState();
}

class _PasswordLoginSheetState extends State<_PasswordLoginSheet> {
  final TextEditingController _accountController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _accountFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // Let the bottom-sheet entrance animation finish before opening the keyboard.
    Future<void>.delayed(const Duration(milliseconds: 350), () {
      if (mounted) {
        _accountFocusNode.requestFocus();
      }
    });
  }

  @override
  void dispose() {
    _accountController.dispose();
    _passwordController.dispose();
    _accountFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool canContinue = _accountController.text.isNotEmpty && _passwordController.text.isNotEmpty;
    return AnimatedPadding(
      duration: const Duration(milliseconds: 180),
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: Material(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  IconButton(
                    padding: EdgeInsets.zero,
                    alignment: Alignment.centerLeft,
                    icon: const Icon(Icons.chevron_left, color: Color(0xFF4A4A4A), size: 28),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Hesap / Şifre ile Giriş',
                    style: TextStyle(fontSize: 26, color: Color(0xFF252525), fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Hesabınızla giriş yapmak için bilgilerinizi girin.',
                    style: TextStyle(fontSize: 13, color: Color(0xFF777777)),
                  ),
                  const SizedBox(height: 24),
                  _PasswordField(
                    controller: _accountController,
                    hintText: 'Kullanıcı adı',
                    keyboardType: TextInputType.text,
                    focusNode: _accountFocusNode,
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 14),
                  _PasswordField(
                    controller: _passwordController,
                    hintText: 'Şifre',
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: GestureDetector(
                      onTap: canContinue
                          ? () {
                              Navigator.pop(context);
                              widget.onMockLogin();
                            }
                          : null,
                      child: CircleAvatar(
                        radius: 30,
                        backgroundColor: canContinue ? const Color(0xFF14C9D0) : const Color(0xFFD0D0D0),
                        child: const Icon(Icons.arrow_forward, color: Colors.white, size: 32),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

}

class _PasswordField extends StatelessWidget {
  const _PasswordField({
    required this.controller,
    required this.hintText,
    required this.keyboardType,
    required this.onChanged,
    this.focusNode,
    this.obscureText = false,
  });

  final TextEditingController controller;
  final String hintText;
  final TextInputType keyboardType;
  final ValueChanged<String> onChanged;
  final FocusNode? focusNode;
  final bool obscureText;

  @override
  Widget build(BuildContext context) => Container(
    height: 60,
    decoration: BoxDecoration(
      border: Border.all(color: const Color(0xFF999999)),
      borderRadius: BorderRadius.circular(32),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 22),
    child: SizedBox.expand(
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        obscureText: obscureText,
        keyboardType: keyboardType,
        textAlignVertical: TextAlignVertical.center,
        textInputAction: TextInputAction.next,
        onChanged: onChanged,
        decoration: InputDecoration(
          isDense: true,
          // Without a suffix icon Flutter's InputDecorator uses a shorter
          // intrinsic height, so give the account field the same vertical
          // center as the password field.
          contentPadding: EdgeInsets.only(top: obscureText ? 0 : 16),
          hintText: hintText,
          hintStyle: const TextStyle(color: Color(0xFFAAAAAA), fontSize: 16),
          border: InputBorder.none,
          suffixIcon: obscureText
              ? const SizedBox(
                  width: 48,
                  child: Center(child: Icon(Icons.lock_outline, color: Color(0xFFAAAAAA))),
                )
              : null,
        ),
      ),
    ),
  );
}

class _TermsAgreement extends StatelessWidget {
  const _TermsAgreement({required this.accepted, required this.onTap});
  final bool accepted;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
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
              color: accepted ? Colors.white : Colors.transparent,
              border: Border.all(color: Colors.white, width: 1.5),
            ),
            child: accepted ? const Icon(Icons.check, size: 12, color: Color(0xFF14C9D0)) : null,
          ),
        ),
        Text(
          'By signing up or logging in,you accept our\nTerms of service and Privacy Policy.',
          textAlign: TextAlign.left,
          style: TextStyle(color: Colors.white.withOpacity(.9), fontSize: 12, height: 1.35),
        ),
      ],
    ),
  );
}

class _SocialButton extends StatelessWidget {
  const _SocialButton({this.asset, this.icon, required this.label, required this.onPressed});
  final String? asset;
  final IconData? icon;
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
            if (icon != null)
              Icon(icon, size: 22, color: const Color(0xFF5794F2))
            else
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
