import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_deer/login/models/login_user.dart';
import 'package:flutter_deer/login/store/login_user_store.dart';
import 'package:flutter_deer/login/widgets/remote_avatar.dart';
import 'package:flutter_deer/res/constant.dart';
import 'package:flutter_deer/routers/routers.dart';
import 'package:sp_util/sp_util.dart';

class CompleteProfileAiPage extends StatefulWidget {
  const CompleteProfileAiPage({super.key, required this.gender, this.onBack, this.onComplete});
  final String gender;
  final VoidCallback? onBack;
  final VoidCallback? onComplete;

  @override
  State<CompleteProfileAiPage> createState() => _CompleteProfileAiPageState();
}

class _CompleteProfileAiPageState extends State<CompleteProfileAiPage> {
  late final TextEditingController _roomController;
  late final TextEditingController _birthdayController;
  late final TextEditingController _inviteController;

  @override
  void initState() {
    super.initState();
    _roomController = TextEditingController(text: 'Çay Sohbet Odaları');
    _birthdayController = TextEditingController(text: '2003-11-09');
    _inviteController = TextEditingController();
  }

  @override
  void dispose() {
    _roomController.dispose();
    _birthdayController.dispose();
    _inviteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final LoginUser? user = LoginUserStore.currentUser;
    return PopScope<void>(
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Image.asset('assets/images/login_social/bg_login_page.jpg', fit: BoxFit.cover),
            Positioned.fill(
              child: IgnorePointer(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 9, sigmaY: 9),
                  child: Container(color: const Color(0x24101820)),
                ),
              ),
            ),
            SafeArea(
              child: Column(
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: const Icon(Icons.chevron_left, color: Colors.white, size: 30),
                      onPressed: widget.onBack ?? () => Navigator.pop(context),
                    ),
                  ),
                  Expanded(
                    child: LayoutBuilder(
                      builder: (BuildContext context, BoxConstraints constraints) =>
                          SingleChildScrollView(
                        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                        padding: EdgeInsets.fromLTRB(
                            24, 8, 24, MediaQuery.viewInsetsOf(context).bottom + 32),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(minHeight: constraints.maxHeight - 16),
                          child: Column(
                            children: <Widget>[
                              const Text(
                                'Yapay zeka sosyal profilinizi oluşturuyor',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 23, fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(height: 30),
                              _ProfileAvatar(user: user),
                              const SizedBox(height: 28),
                              _ProfileField(controller: _roomController, hintText: 'Sohbet odası'),
                              const SizedBox(height: 14),
                              _ProfileField(
                                  controller: _birthdayController,
                                  hintText: 'Doğum tarihi',
                                  keyboardType: TextInputType.datetime),
                              const SizedBox(height: 14),
                              _ProfileField(
                                  controller: _inviteController,
                                  hintText: 'Davet kodu (İsteğe bağlı)'),
                              const SizedBox(height: 28),
                              _ContinueButton(onPressed: _complete),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _complete() {
    SpUtil.putString(Constant.profileGender, widget.gender);
    SpUtil.putString(Constant.profileBirthday, _birthdayController.text);
    SpUtil.putString(Constant.profileInviteCode, _inviteController.text);
    SpUtil.putBool(Constant.profileCompleted, true);
    if (widget.onComplete != null) {
      widget.onComplete!();
      return;
    }
    Navigator.of(context).pushNamedAndRemoveUntil(Routes.home, (_) => false);
  }
}

class _ProfileAvatar extends StatelessWidget {
  const _ProfileAvatar({required this.user});
  final LoginUser? user;

  @override
  Widget build(BuildContext context) => Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          Container(
            width: 132,
            height: 132,
            padding: const EdgeInsets.all(2),
            decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
            child: ClipOval(
              child: user == null
                  ? Image.asset(RemoteAvatar.placeholderAsset, fit: BoxFit.cover)
                  : RemoteAvatar(imageUrl: user!.avatar),
            ),
          ),
          const Positioned(
            right: -8,
            bottom: 2,
            child: CircleAvatar(
                radius: 18,
                backgroundColor: Colors.white24,
                child: Icon(Icons.refresh, color: Colors.white, size: 20)),
          ),
        ],
      );
}

class _ProfileField extends StatelessWidget {
  const _ProfileField(
      {required this.controller, required this.hintText, this.keyboardType = TextInputType.text});
  final TextEditingController controller;
  final String hintText;
  final TextInputType keyboardType;

  @override
  Widget build(BuildContext context) => Container(
        height: 54,
        padding: const EdgeInsets.symmetric(horizontal: 22),
        decoration: BoxDecoration(
            color: Colors.white.withOpacity(.18),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: Colors.white54)),
        child: TextField(
          controller: controller,
          keyboardType: keyboardType,
          style: const TextStyle(color: Colors.white, fontSize: 16),
          textAlign: TextAlign.center,
          decoration: InputDecoration(
              hintText: hintText,
              hintStyle: const TextStyle(color: Colors.white70),
              border: InputBorder.none),
        ),
      );
}

class _ContinueButton extends StatelessWidget {
  const _ContinueButton({required this.onPressed});
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onPressed,
        child: const CircleAvatar(
            radius: 31,
            backgroundColor: Colors.white,
            child: Icon(Icons.arrow_forward, color: Color(0xFF14AEB5), size: 32)),
      );
}
