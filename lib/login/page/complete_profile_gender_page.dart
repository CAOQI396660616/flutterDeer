import 'package:flutter/material.dart';
import 'package:flutter_deer/login/page/complete_profile_ai_page.dart';

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
  Widget build(BuildContext context) => Scaffold(
    body: Stack(
      fit: StackFit.expand,
      children: <Widget>[
        const ColoredBox(color: Color(0xFF14C9D0)),
        Image.asset('assets/images/login_social/bg_login.png', fit: BoxFit.cover),
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
                    style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Row(
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
                    ],
                  ),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 32),
                  child: _ContinueButton(
                    enabled: _gender != null,
                    onPressed: _gender == null
                        ? null
                        : () {
                            if (widget.onNext != null) {
                              widget.onNext!(_gender!);
                              return;
                            }
                            Navigator.push<void>(context, MaterialPageRoute<void>(builder: (_) => CompleteProfileAiPage(gender: _gender!)));
                          },
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _GenderChoice extends StatelessWidget {
  const _GenderChoice({required this.label, required this.icon, required this.isMale, required this.selected, required this.activeGender, required this.onTap});
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
    final double scale = selected ? 1.12 : selectedByOther ? .86 : 1;
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
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 260),
            width: 138,
            height: 138,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: selected ? Colors.white : Colors.white.withOpacity(.18),
              border: Border.all(color: selected ? Colors.white : Colors.white54, width: selected ? 2 : 1),
              boxShadow: selected ? const <BoxShadow>[BoxShadow(color: Color(0x55000000), blurRadius: 18, spreadRadius: 2)] : null,
            ),
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(
                  icon,
                  size: selected ? 52 : 46,
                  color: selected ? const Color(0xFF14AEB5) : Colors.white,
                ),
                const SizedBox(height: 10),
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 180),
                  style: TextStyle(color: selected ? const Color(0xFF14AEB5) : Colors.white, fontSize: selected ? 19 : 18, fontWeight: FontWeight.w600),
                  child: Text(label),
                ),
              ],
            ),
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
      child: Icon(Icons.arrow_forward, color: enabled ? const Color(0xFF14AEB5) : Colors.white54, size: 32),
    ),
  );
}
