import 'package:flutter/material.dart';
import 'package:flutter_deer/login/page/complete_profile_ai_page.dart';

class CompleteProfileGenderPage extends StatefulWidget {
  const CompleteProfileGenderPage({super.key});

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
                onPressed: () => Navigator.pop(context),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Sosyal cinsiyetinizi seçin?',
                          style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.w600),
                        ),
                      ),
                      const SizedBox(height: 52),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          _GenderChoice(
                            label: 'Erkek',
                            selected: _gender == 'male',
                            onTap: () => setState(() => _gender = 'male'),
                          ),
                          _GenderChoice(
                            label: 'Kadın',
                            selected: _gender == 'female',
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
                        : () => Navigator.push<void>(
                            context,
                            MaterialPageRoute<void>(builder: (_) => CompleteProfileAiPage(gender: _gender!)),
                          ),
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
  const _GenderChoice({required this.label, required this.selected, required this.onTap});
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      width: 138,
      height: 138,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: selected ? Colors.white : Colors.white.withOpacity(.18),
        border: Border.all(color: selected ? Colors.white : Colors.white54),
        boxShadow: selected ? const <BoxShadow>[BoxShadow(color: Color(0x55000000), blurRadius: 12)] : null,
      ),
      alignment: Alignment.center,
      child: Text(label, style: TextStyle(color: selected ? const Color(0xFF14AEB5) : Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
    ),
  );
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
