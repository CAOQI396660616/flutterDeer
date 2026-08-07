import 'package:flutter/material.dart';

class HomeTopBar extends StatelessWidget {
  const HomeTopBar(
      {super.key,
      required this.selected,
      required this.indicatorProgress,
      required this.onWelcomeTap,
      required this.onSearchTap,
      required this.onChanged});

  final int selected;
  final double indicatorProgress;
  final VoidCallback onWelcomeTap;
  final VoidCallback onSearchTap;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) => Row(
        children: <Widget>[
          HomeBrushTabBar(
            labels: const <String>['Aile', 'Odalar'],
            selected: selected,
            indicatorProgress: indicatorProgress,
            onChanged: onChanged,
          ),
          const Spacer(),
          HomeActionButton(
              key: const Key('home_search_action'),
              icon: Icons.search,
              label: 'Ara',
              onTap: onSearchTap),
          const SizedBox(width: 16),
          HomeActionButton(
              icon: Icons.leaderboard_outlined, label: 'Sıralama', onTap: onWelcomeTap),
        ],
      );
}

/// Ortak fırça sekmesi düzeni.
class HomeBrushTabBar extends StatelessWidget {
  const HomeBrushTabBar({
    super.key,
    required this.labels,
    required this.selected,
    required this.indicatorProgress,
    required this.onChanged,
    this.tabWidths = const <double>[55, 73],
  });

  final List<String> labels;
  final int selected;
  final double indicatorProgress;
  final ValueChanged<int> onChanged;
  final List<double> tabWidths;

  @override
  Widget build(BuildContext context) {
    const double tabGap = 22;
    const double indicatorWidth = 27;
    final double firstCenter = tabWidths[0] / 2;
    final double secondCenter = tabWidths[0] + tabGap + (tabWidths[1] / 2);
    final double indicatorLeft = firstCenter +
        ((secondCenter - firstCenter) * indicatorProgress.clamp(0.0, 1.0)) -
        (indicatorWidth / 2);
    return SizedBox(
      width: tabWidths[0] + tabGap + tabWidths[1],
      height: 38,
      child: Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          Positioned(
            left: indicatorLeft,
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
                width: tabWidths[0],
                child: _TopTab(
                  label: labels[0],
                  selected: selected == 0,
                  onTap: () => onChanged(0),
                ),
              ),
              const SizedBox(width: 22),
              SizedBox(
                width: tabWidths[1],
                child: _TopTab(
                  label: labels[1],
                  selected: selected == 1,
                  onTap: () => onChanged(1),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Ana sayfanın dört modülünde kullanılan ortak üst aksiyon butonu.
class HomeActionButton extends StatelessWidget {
  const HomeActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.baseIconSize = 24,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final double baseIconSize;

  @override
  Widget build(BuildContext context) => Tooltip(
        message: label,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          child: SizedBox(
            width: 48,
            height: 48,
            child: Center(
              child: CircleAvatar(
                radius: 16,
                backgroundColor: Colors.white.withOpacity(.10),
                child: Icon(icon, color: Colors.white70, size: baseIconSize * .8),
              ),
            ),
          ),
        ),
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
          child: Text(
            label,
            maxLines: 1,
            softWrap: false,
            style: TextStyle(
                color: selected ? Colors.white : Colors.white60,
                fontSize: 22,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w400),
          ),
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
