import 'package:flutter/material.dart';

class HomeBottomBar extends StatelessWidget {
  const HomeBottomBar({super.key, required this.currentIndex, required this.onTap});
  final int currentIndex;
  final ValueChanged<int> onTap;

  static const List<String> _labels = <String>['Ana Sayfa', 'Meydan', 'Sohbet', 'Profil'];

  @override
  Widget build(BuildContext context) => SafeArea(
    top: false,
    minimum: const EdgeInsets.fromLTRB(12, 0, 12, 20),
    child: SizedBox(
      height: 88,
      child: Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          // The capsule is a single translucent surface. The page remains
          // visible through it, while icons are rendered in a separate layer.
          Positioned(
            left: 0,
            right: 0,
            bottom: 4,
            height: 60,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: const Color(0x6616191D),
                borderRadius: BorderRadius.circular(40),
                border: Border.all(color: Colors.white.withOpacity(.18)),
                boxShadow: const <BoxShadow>[BoxShadow(color: Color(0x55000000), blurRadius: 14, offset: Offset(0, 5))],
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: 78,
            child: Row(
              children: List<Widget>.generate(
                _labels.length,
                (int index) => Expanded(
                  child: SizedBox(
                    height: 78,
                    child: ClipRect(child: _NavItem(index: index, selected: currentIndex == index, onTap: () => onTap(index))),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class _NavItem extends StatelessWidget {
  const _NavItem({required this.index, required this.selected, required this.onTap});
  final int index;
  final bool selected;
  final VoidCallback onTap;

  static const List<IconData> _icons = <IconData>[Icons.home_outlined, Icons.apps_outlined, Icons.chat_bubble_outline, Icons.person_outline];
  static const List<String> _labels = <String>['Ana Sayfa', 'Meydan', 'Sohbet', 'Profil'];

  @override
  Widget build(BuildContext context) => Material(
    type: MaterialType.transparency,
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(36),
      child: SizedBox(
        height: 78,
        child: Center(
          // Keep the icon and label inside a fixed-height box. The selected
          // icon changes visually, not the layout constraints of the item.
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(
                width: 48,
                height: 48,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 180),
                  transitionBuilder: (Widget child, Animation<double> animation) => FadeTransition(opacity: animation, child: child),
                  child: Container(
                    key: ValueKey<bool>(selected),
                    width: selected ? 48 : 42,
                    height: selected ? 48 : 42,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: selected ? const LinearGradient(colors: <Color>[Color(0xFF72F0D5), Color(0xFF1BCBD3)], begin: Alignment.topLeft, end: Alignment.bottomRight) : null,
                      boxShadow: selected ? const <BoxShadow>[BoxShadow(color: Color(0x6614D8D4), blurRadius: 10)] : null,
                    ),
                    child: Icon(_icons[index], color: selected ? Colors.white : Colors.white.withOpacity(.28), size: selected ? 26 : 22),
                  ),
                ),
              ),
              const SizedBox(height: 2),
              Text(_labels[index], style: TextStyle(color: selected ? Colors.white : Colors.white.withOpacity(.34), fontSize: 9, fontWeight: selected ? FontWeight.w600 : FontWeight.w400)),
            ],
          ),
        ),
      ),
    ),
  );
}
