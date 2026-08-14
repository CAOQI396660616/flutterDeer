import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_deer/login/login_router.dart';
import 'package:flutter_deer/routers/fluro_navigator.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// VoiceVibe 声浪登录页。
///
/// 页面根据 Figma 节点 `3:9` 实现，作为 Deer 登录模块中的独立设计体验页。
/// 登录、验证码和第三方授权均为本地交互演示，不会请求真实服务端。
class VoiceVibeLoginPage extends StatefulWidget {
  const VoiceVibeLoginPage({super.key});

  @override
  State<VoiceVibeLoginPage> createState() => _VoiceVibeLoginPageState();
}

class _VoiceVibeLoginPageState extends State<VoiceVibeLoginPage> {
  static const Color _backgroundColor = Color(0xFFFEF7FF);
  static const Color _primaryColor = Color(0xFF6750A4);
  static const Color _surfaceColor = Color(0xFFE7E0EC);
  static const Color _secondarySurfaceColor = Color(0xFFE8DEF8);
  static const Color _onSurfaceColor = Color(0xFF1C1B1F);
  static const Color _secondaryTextColor = Color(0xFF49454F);

  final TextEditingController _phoneController = TextEditingController(text: '+86 138-0000-0000');
  final TextEditingController _codeController = TextEditingController(text: '6849');

  Timer? _countdownTimer;
  bool _acceptedTerms = true;
  int _countdownSeconds = 59;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    _startCountdown();
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _phoneController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  /// 启动验证码倒计时，并在计时结束后恢复获取验证码入口。
  void _startCountdown() {
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (_countdownSeconds == 0) {
        timer.cancel();
        return;
      }
      setState(() => _countdownSeconds--);
    });
  }

  /// 重新开始 59 秒的验证码倒计时。
  void _restartCountdown() {
    setState(() => _countdownSeconds = 59);
    _startCountdown();
  }

  /// 校验本地演示输入，通过后进入 VoiceVibe 首页。
  void _submitLogin() {
    if (!_acceptedTerms) {
      _showMessage('请先阅读并同意用户协议和隐私政策');
      return;
    }
    if (_phoneController.text.trim().isEmpty || _codeController.text.trim().isEmpty) {
      _showMessage('请输入手机号码和验证码');
      return;
    }
    NavigatorUtils.push(context, LoginRouter.voiceVibeHomePage);
  }

  /// 显示页面内轻量反馈，避免演示操作静默失败。
  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: _backgroundColor,
        body: SafeArea(
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) => SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    children: <Widget>[
                      _buildBrandHeader(),
                      _buildBanner(),
                      _buildLoginForm(),
                      const Spacer(),
                      _buildSocialLoginArea(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );

  Widget _buildBrandHeader() => Padding(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
        child: Column(
          children: <Widget>[
            Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(28)),
                gradient: LinearGradient(
                  colors: <Color>[Color(0xFF6750A4), Color(0xFF9A82E9)],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: SvgPicture.asset(
                  'assets/images/login/voice_vibe/voice_vibe_waveform.svg',
                  semanticsLabel: 'VoiceVibe 声浪图标',
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'VoiceVibe 声浪',
              style: TextStyle(
                color: _primaryColor,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              '用声音遇见温暖的灵魂',
              style: TextStyle(color: Color(0xFF625B71), fontSize: 14),
            ),
          ],
        ),
      );

  Widget _buildBanner() => Padding(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Image.asset(
            'assets/images/login/voice_vibe/voice_vibe_banner.png',
            height: 160,
            width: double.infinity,
            fit: BoxFit.cover,
            semanticLabel: 'VoiceVibe 声波插画',
          ),
        ),
      );

  Widget _buildLoginForm() => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _VoiceVibeTextField(
              controller: _phoneController,
              label: '手机号码',
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Expanded(
                  child: _VoiceVibeTextField(
                    controller: _codeController,
                    label: '验证码',
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 12),
                FilledButton(
                  onPressed: _countdownSeconds == 0 ? _restartCountdown : null,
                  style: FilledButton.styleFrom(
                    backgroundColor: _secondarySurfaceColor,
                    disabledBackgroundColor: _secondarySurfaceColor,
                    foregroundColor: const Color(0xFF1D192B),
                    disabledForegroundColor: const Color(0xFF1D192B),
                    minimumSize: const Size(120, 48),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                  child: Text(
                    _countdownSeconds == 0 ? '获取验证码' : '重新获取 (${_countdownSeconds}s)',
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: () => setState(() => _acceptedTerms = !_acceptedTerms),
              borderRadius: BorderRadius.circular(4),
              child: Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 8),
                child: Row(
                  children: <Widget>[
                    SizedBox(
                      width: 18,
                      height: 18,
                      child: _acceptedTerms
                          ? SvgPicture.asset(
                              'assets/images/login/voice_vibe/voice_vibe_checked.svg',
                              semanticsLabel: '已同意用户协议',
                            )
                          : const Icon(Icons.check_box_outline_blank,
                              color: _primaryColor, size: 20),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: <Widget>[
                          const Text('我已阅读并同意 ',
                              style: TextStyle(color: _secondaryTextColor, fontSize: 12)),
                          _AgreementLink(label: '用户协议', onTap: () => _showMessage('用户协议暂未配置')),
                          const Text(' 和 ',
                              style: TextStyle(color: _secondaryTextColor, fontSize: 12)),
                          _AgreementLink(label: '隐私政策', onTap: () => _showMessage('隐私政策暂未配置')),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            FilledButton(
              onPressed: _submitLogin,
              style: FilledButton.styleFrom(
                backgroundColor: _primaryColor,
                minimumSize: const Size.fromHeight(48),
                shape: const StadiumBorder(),
              ),
              child: const Text(
                '立即登录 / 注册',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      );

  Widget _buildSocialLoginArea() => Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 12),
        child: Column(
          children: <Widget>[
            const Row(
              children: <Widget>[
                Expanded(child: Divider(color: Color(0xFFE8E0EA))),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Text('第三方登录', style: TextStyle(color: _secondaryTextColor, fontSize: 12)),
                ),
                Expanded(child: Divider(color: Color(0xFFE8E0EA))),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _SocialLoginButton(
                  backgroundColor: const Color(0xFFEDF7ED),
                  semanticLabel: '微信登录',
                  icon: SvgPicture.asset(
                    'assets/images/login/voice_vibe/voice_vibe_wechat.svg',
                    width: 24,
                    height: 24,
                  ),
                  onTap: () => _showMessage('微信登录暂未配置'),
                ),
                const SizedBox(width: 24),
                _SocialLoginButton(
                  backgroundColor: const Color(0xFFF4F4F4),
                  semanticLabel: 'Apple 登录',
                  icon: SvgPicture.asset(
                    'assets/images/login/voice_vibe/voice_vibe_apple.svg',
                    width: 24,
                    height: 24,
                  ),
                  onTap: () => _showMessage('Apple 登录暂未配置'),
                ),
              ],
            ),
            const SizedBox(height: 28),
            Container(
              width: 134,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.25),
                borderRadius: BorderRadius.circular(99),
              ),
            ),
          ],
        ),
      );
}

/// Figma 样式的带标签文本输入框。
class _VoiceVibeTextField extends StatelessWidget {
  const _VoiceVibeTextField({
    required this.controller,
    required this.label,
    required this.keyboardType,
  });

  final TextEditingController controller;
  final String label;
  final TextInputType keyboardType;

  @override
  Widget build(BuildContext context) => Container(
        height: 72,
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
        decoration: const BoxDecoration(
          color: _VoiceVibeLoginPageState._surfaceColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
          border:
              Border(bottom: BorderSide(color: _VoiceVibeLoginPageState._primaryColor, width: 2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              label,
              style: const TextStyle(
                color: _VoiceVibeLoginPageState._primaryColor,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            Expanded(
              child: TextField(
                controller: controller,
                keyboardType: keyboardType,
                style:
                    const TextStyle(color: _VoiceVibeLoginPageState._onSurfaceColor, fontSize: 16),
                decoration: const InputDecoration(border: InputBorder.none, isDense: true),
              ),
            ),
          ],
        ),
      );
}

/// 协议文本链接，保持与普通文案一致的行内布局。
class _AgreementLink extends StatelessWidget {
  const _AgreementLink({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Text(
          label,
          style: const TextStyle(
            color: _VoiceVibeLoginPageState._primaryColor,
            fontSize: 12,
            decoration: TextDecoration.underline,
          ),
        ),
      );
}

/// 第三方登录圆形入口，统一管理点击反馈和无障碍标签。
class _SocialLoginButton extends StatelessWidget {
  const _SocialLoginButton({
    required this.backgroundColor,
    required this.semanticLabel,
    required this.icon,
    required this.onTap,
  });

  final Color backgroundColor;
  final String semanticLabel;
  final Widget icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Semantics(
        button: true,
        label: semanticLabel,
        child: Ink(
          width: 48,
          height: 48,
          decoration: BoxDecoration(color: backgroundColor, shape: BoxShape.circle),
          child: InkWell(
            onTap: onTap,
            customBorder: const CircleBorder(),
            child: Center(child: icon),
          ),
        ),
      );
}
