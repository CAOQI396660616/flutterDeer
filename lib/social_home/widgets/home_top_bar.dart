import 'package:flutter/material.dart';

class HomeTopBar extends StatelessWidget {
  const HomeTopBar(
      {super.key,
      required this.selected,
      required this.indicatorProgress,
      required this.onWelcomeTap,
      required this.onChanged});

  final int selected;
  final double indicatorProgress;
  final VoidCallback onWelcomeTap;
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
                  bottom: 8,
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
          _CircleAction(icon: Icons.leaderboard_outlined, label: 'Sıralama', onTap: onWelcomeTap),
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
        child: Center(
          child: Text(label,
              style: TextStyle(
                  color: selected ? Colors.white : Colors.white60,
                  fontSize: 22,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w400)),
        ),
      );
}

/// A native brush-style indicator. Replace this with Image.asset when a
/// designer-provided indicator image is available.
class _TopTabIndicatorPainter extends CustomPainter {
  const _TopTabIndicatorPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..shader = const LinearGradient(
        colors: <Color>[Color(0xFFFFD54F), Color(0xFFFF7A00)],
      ).createShader(Offset.zero & size)
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 3.5
      ..style = PaintingStyle.stroke;
    final Path path = Path()
      ..moveTo(3, size.height * .62)
      ..quadraticBezierTo(size.width * .28, size.height * .15, size.width * .55, size.height * .52)
      ..quadraticBezierTo(size.width * .78, size.height * .82, size.width - 2, size.height * .48);
    canvas.drawPath(path, paint);
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
