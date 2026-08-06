import 'package:flutter/material.dart';

class HomeTopBar extends StatelessWidget {
  const HomeTopBar(
      {super.key,
      required this.selected,
      required this.indicatorProgress,
      required this.onChanged});

  final int selected;
  final double indicatorProgress;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) => Row(
        children: <Widget>[
          SizedBox(
            width: 150,
            height: 38,
            child: Stack(
              clipBehavior: Clip.none,
              children: <Widget>[
                Positioned(
                  left: 14 + (indicatorProgress * 87),
                  bottom: 5,
                  width: 27,
                  height: 8,
                  child: const IgnorePointer(
                    child: CustomPaint(painter: _TopTabIndicatorPainter()),
                  ),
                ),
                Row(
                  children: <Widget>[
                    SizedBox(
                        width: 55,
                        child: _TopTab(
                            label: 'Aile', selected: selected == 0, onTap: () => onChanged(0))),
                    const SizedBox(width: 22),
                    SizedBox(
                        width: 73,
                        child: _TopTab(
                            label: 'Odalar', selected: selected == 1, onTap: () => onChanged(1))),
                  ],
                ),
              ],
            ),
          ),
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
        child: Text(label,
            style: TextStyle(
                color: selected ? Colors.white : Colors.white60,
                fontSize: 22,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w400)),
      );
}

/// A native brush-style indicator. Replace this with Image.asset when a
/// designer-provided indicator image is available.
class _TopTabIndicatorPainter extends CustomPainter {
  const _TopTabIndicatorPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = const Color(0xFF14D8D4)
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 3.5
      ..style = PaintingStyle.stroke;
    final Path path = Path()
      ..moveTo(3, size.height * .58)
      ..quadraticBezierTo(size.width * .33, size.height * .15, size.width * .62, size.height * .52)
      ..quadraticBezierTo(size.width * .82, size.height * .78, size.width - 2, size.height * .38);
    canvas.drawPath(path, paint);

    final Paint highlight = Paint()
      ..color = const Color(0xAA70FFF3)
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 1.4;
    canvas.drawLine(
        Offset(8, size.height * .75), Offset(size.width - 8, size.height * .55), highlight);
  }

  @override
  bool shouldRepaint(covariant _TopTabIndicatorPainter oldDelegate) => false;
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
          child: CircleAvatar(
              radius: 24,
              backgroundColor: Colors.white.withOpacity(.1),
              child: Icon(icon, color: Colors.white70, size: 20)),
        ),
      );
}
