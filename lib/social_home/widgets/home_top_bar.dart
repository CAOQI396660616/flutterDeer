import 'package:flutter/material.dart';

class HomeTopBar extends StatelessWidget {
  const HomeTopBar({super.key, required this.selected, required this.onChanged});

  final int selected;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) => Row(
    children: <Widget>[
      _TopTab(label: 'Aile', selected: selected == 0, onTap: () => onChanged(0)),
      const SizedBox(width: 22),
      _TopTab(label: 'Odalar', selected: selected == 1, onTap: () => onChanged(1)),
      const Spacer(),
      _CircleAction(icon: Icons.search, label: 'Ara', onTap: () {}),
      const SizedBox(width: 12),
      _CircleAction(icon: Icons.leaderboard_outlined, label: 'Sıralama', onTap: () {}),
    ],
  );
}

class _TopTab extends StatelessWidget {
  const _TopTab({required this.label, required this.selected, required this.onTap});
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(label, style: TextStyle(color: selected ? Colors.white : Colors.white60, fontSize: 22, fontWeight: selected ? FontWeight.w600 : FontWeight.w400)),
        const SizedBox(height: 5),
        AnimatedContainer(duration: const Duration(milliseconds: 180), width: selected ? 54 : 0, height: 5, decoration: const ShapeDecoration(color: Color(0xFF14D8D4), shape: StadiumBorder())),
      ],
    ),
  );
}

class _CircleAction extends StatelessWidget {
  const _CircleAction({required this.icon, required this.label, required this.onTap});
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Tooltip(
    message: label,
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: CircleAvatar(radius: 24, backgroundColor: Colors.white.withOpacity(.1), child: Icon(icon, color: Colors.white70, size: 20)),
    ),
  );
}
