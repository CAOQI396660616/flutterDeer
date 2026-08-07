import 'package:flutter/material.dart';
import 'package:flutter_deer/login/models/login_user.dart';
import 'package:flutter_deer/login/store/login_user_store.dart';

class ProfileEditPage extends StatefulWidget {
  const ProfileEditPage({super.key});

  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  late final TextEditingController _nicknameController;
  late final TextEditingController _signatureController;

  @override
  void initState() {
    super.initState();
    final user = LoginUserStore.currentUser;
    _nicknameController = TextEditingController(text: user?.nickname ?? 'Emre Yılmaz');
    _signatureController = TextEditingController();
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    _signatureController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: const Color(0xFF12152B),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          elevation: 0,
          title: const Text('Profili düzenle'),
          actions: <Widget>[
            TextButton(onPressed: _save, child: const Text('Kaydet')),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          children: <Widget>[
            _EditField(
              controller: _nicknameController,
              label: 'Kullanıcı adı',
              hint: 'Kullanıcı adını gir',
            ),
            const SizedBox(height: 18),
            _EditField(
              controller: _signatureController,
              label: 'İmza',
              hint: 'Kendin hakkında birkaç kelime yaz',
              maxLines: 3,
            ),
          ],
        ),
      );

  void _save() {
    final user = LoginUserStore.currentUser;
    if (user == null || _nicknameController.text.trim().isEmpty) {
      return;
    }
    LoginUserStore.save(LoginUser(
      id: user.id,
      nickname: _nicknameController.text.trim(),
      avatar: user.avatar,
      loginMethod: user.loginMethod,
      lastLoginAt: user.lastLoginAt,
    ));
    Navigator.of(context).pop();
  }
}

class _EditField extends StatelessWidget {
  const _EditField({
    required this.controller,
    required this.label,
    required this.hint,
    this.maxLines = 1,
  });

  final TextEditingController controller;
  final String label;
  final String hint;
  final int maxLines;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            maxLines: maxLines,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: Colors.white38),
              filled: true,
              fillColor: Colors.white.withOpacity(.1),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      );
}
