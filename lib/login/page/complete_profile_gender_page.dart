import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_deer/login/page/complete_profile_ai_page.dart';
import 'package:lottie/lottie.dart';

class CompleteProfileGenderPage extends StatefulWidget {
  const CompleteProfileGenderPage({super.key, this.onBack, this.onNext});
  final VoidCallback? onBack;
  final ValueChanged<String>? onNext;

  @override
  State<CompleteProfileGenderPage> createState() => _CompleteProfileGenderPageState();
}

class _CompleteProfileGenderPageState extends State<CompleteProfileGenderPage> {
  String? _gender;

  @override
  Widget build(BuildContext context) => PopScope<void>(
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    IconButton(
                      icon: const Icon(Icons.chevron_left, color: Colors.white, size: 30),
                      onPressed: widget.onBack ?? () => Navigator.pop(context),
                    ),
                    const SizedBox(height: 30),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: Center(
                        child: Text(
                          'Sosyal cinsiyetinizi seçin?',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white, fontSize: 25, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    const SizedBox(height: 58),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          _GenderChoice(
                            label: 'Erkek',
                            icon: Icons.male,
                            isMale: true,
                            selected: _gender == 'male',
                            activeGender: _gender,
                            onTap: () => setState(() => _gender = 'male'),
                          ),
                          _GenderChoice(
                            label: 'Kadın',
                            icon: Icons.female,
                            isMale: false,
                            selected: _gender == 'female',
                            activeGender: _gender,
                            onTap: () => setState(() => _gender = 'female'),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 56),
                    Center(
                      child: _ContinueButton(
                        enabled: _gender != null,
                        onPressed: _gender == null
                            ? null
                            : () {
                                if (widget.onNext != null) {
                                  widget.onNext!(_gender!);
                                  return;
                                }
                                Navigator.push<void>(
                                    context,
                                    MaterialPageRoute<void>(
                                        builder: (_) => CompleteProfileAiPage(gender: _gender!)));
                              },
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
}

class _GenderChoice extends StatelessWidget {
  const _GenderChoice(
      {required this.label,
      required this.icon,
      required this.isMale,
      required this.selected,
      required this.activeGender,
      required this.onTap});
  final String label;
  final IconData icon;
  final bool isMale;
  final bool selected;
  final String? activeGender;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final bool hasSelection = activeGender != null;
    final bool selectedByOther = hasSelection && !selected;
    final double scale = selected
        ? 1.12
        : selectedByOther
            ? .86
            : 1;
    final double horizontalShift = selected
        ? (isMale ? .08 : -.08)
        : selectedByOther
            ? (isMale ? -.04 : .04)
            : 0;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedSlide(
        offset: Offset(horizontalShift, 0),
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeOutCubic,
        child: AnimatedScale(
          scale: scale,
          duration: const Duration(milliseconds: 320),
          curve: Curves.easeOutBack,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              AnimatedContainer(
                duration: const Duration(milliseconds: 260),
                width: 138,
                height: 138,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: selected ? Colors.white24 : Colors.white.withOpacity(.12),
                  border: Border.all(
                      color: selected ? Colors.white : Colors.white54, width: selected ? 2 : 1),
                  boxShadow: selected
                      ? const <BoxShadow>[
                          BoxShadow(color: Color(0x55000000), blurRadius: 18, spreadRadius: 2)
                        ]
                      : null,
                ),
                clipBehavior: Clip.antiAlias,
                child: Transform.scale(
                  scale: 1.35,
                  child: Lottie.asset(
                    isMale ? 'assets/lottie/man.json' : 'assets/lottie/woman.json',
                    fit: BoxFit.contain,
                    repeat: true,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: selected ? Colors.white24 : Colors.white.withOpacity(.12),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: Colors.white38),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(icon,
                        size: selected ? 28 : 25,
                        color: selected ? const Color(0xFF14AEB5) : Colors.white),
                    const SizedBox(width: 7),
                    AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 180),
                      style: TextStyle(
                          color: selected ? const Color(0xFF14AEB5) : Colors.white,
                          fontSize: selected ? 17 : 16,
                          fontWeight: FontWeight.w600),
                      child: Text(label),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ContinueButton extends StatelessWidget {
  const _ContinueButton({required this.enabled, required this.onPressed});
  final bool enabled;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onPressed,
        child: CircleAvatar(
          radius: 31,
          backgroundColor: enabled ? Colors.white : Colors.white24,
          child: Icon(Icons.arrow_forward,
              color: enabled ? const Color(0xFF14AEB5) : Colors.white54, size: 32),
        ),
      );
}
