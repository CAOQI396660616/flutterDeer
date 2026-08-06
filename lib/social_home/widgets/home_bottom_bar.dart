import 'package:flutter/material.dart';

class HomeBottomBar extends StatelessWidget {
  const HomeBottomBar({super.key, required this.currentIndex, required this.onTap});
  final int currentIndex;
  final ValueChanged<int> onTap;

  static const List<String> _labels = <String>['Video', 'Parti', 'Meydan', 'Sohbet', 'Hediye'];

  @override
  Widget build(BuildContext context) => SafeArea(
    top: false,
    minimum: const EdgeInsets.fromLTRB(12, 0, 12, 10),
    child: Container(
      height: 78,
      decoration: BoxDecoration(
        color: const Color(0xCC16191D),
        borderRadius: BorderRadius.circular(40),
        border: Border.all(color: Colors.white.withOpacity(.14)),
        boxShadow: const <BoxShadow>[BoxShadow(color: Color(0x55000000), blurRadius: 14, offset: Offset(0, 5))],
      ),
      child: Row(
        children: List<Widget>.generate(_labels.length, (int index) => Expanded(child: _NavItem(index: index, selected: currentIndex == index, onTap: () => onTap(index)))),
      ),
    ),
  );
}

class _NavItem extends StatelessWidget {
  const _NavItem({required this.index, required this.selected, required this.onTap});
  final int index;
  final bool selected;
  final VoidCallback onTap;

  static const List<IconData> _icons = <IconData>[Icons.ondemand_video, Icons.celebration_outlined, Icons.apps_outlined, Icons.chat_bubble_outline, Icons.card_giftcard_outlined];
  static const List<String> _labels = <String>['Video', 'Parti', 'Meydan', 'Sohbet', 'Hediye'];

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(36),
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOutCubic,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          AnimatedContainer(
            duration: const Duration(milliseconds: 260),
            curve: Curves.easeOutBack,
            width: selected ? 48 : 42,
            height: selected ? 48 : 42,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: selected ? const LinearGradient(colors: <Color>[Color(0xFF72F0D5), Color(0xFF1BCBD3)], begin: Alignment.topLeft, end: Alignment.bottomRight) : null,
              color: selected ? null : Colors.white.withOpacity(.08),
              boxShadow: selected ? const <BoxShadow>[BoxShadow(color: Color(0x6614D8D4), blurRadius: 10)] : null,
            ),
            child: Icon(_icons[index], color: selected ? Colors.white : Colors.white.withOpacity(.28), size: selected ? 26 : 22),
          ),
          const SizedBox(height: 2),
          Text(_labels[index], style: TextStyle(color: selected ? Colors.white : Colors.white.withOpacity(.34), fontSize: 9, fontWeight: selected ? FontWeight.w600 : FontWeight.w400)),
        ],
      ),
    ),
  );
}
