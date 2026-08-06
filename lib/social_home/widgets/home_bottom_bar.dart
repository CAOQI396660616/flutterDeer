// ignore_for_file: always_put_control_body_on_new_line

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class HomeBottomBar extends StatefulWidget {
  const HomeBottomBar({super.key, required this.currentIndex, required this.onTap});

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  State<HomeBottomBar> createState() => _HomeBottomBarState();
}

class _HomeBottomBarState extends State<HomeBottomBar> {
  static const int _tabCount = 4;
  int? _pendingIndex;

  @override
  Widget build(BuildContext context) => SafeArea(
        top: false,
        minimum: const EdgeInsets.fromLTRB(12, 0, 12, 20),
        child: SizedBox(
          height: 88,
          child: Stack(
            clipBehavior: Clip.none,
            children: <Widget>[
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
                    boxShadow: const <BoxShadow>[
                      BoxShadow(color: Color(0x55000000), blurRadius: 14, offset: Offset(0, 5))
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 10,
                height: 78,
                child: Row(
                  children: List<Widget>.generate(
                    _tabCount,
                    (int index) => Expanded(
                      child: SizedBox(
                        height: 78,
                        child: ClipRect(
                          child: _NavItem(
                            index: index,
                            selected: widget.currentIndex == index,
                            animate: _pendingIndex == index,
                            onTap: () => _handleTap(index),
                            onAnimationComplete: () => _completeTap(index),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  void _handleTap(int index) {
    if (index == widget.currentIndex && _pendingIndex == null) return;
    setState(() => _pendingIndex = index);
    // 先立即切换页面，Lottie 只负责播放点击反馈，不阻塞 Tab 内容切换。
    widget.onTap(index);
  }

  void _completeTap(int index) {
    if (!mounted || _pendingIndex != index) return;
    setState(() => _pendingIndex = null);
  }
}

class _NavItem extends StatefulWidget {
  const _NavItem(
      {required this.index,
      required this.selected,
      required this.animate,
      required this.onTap,
      required this.onAnimationComplete});

  final int index;
  final bool selected;
  final bool animate;
  final VoidCallback onTap;
  final VoidCallback onAnimationComplete;

  @override
  State<_NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<_NavItem> with SingleTickerProviderStateMixin {
  static const List<String> _icons = <String>[
    'assets/images/social_home/icon_tab_1_a.png',
    'assets/images/social_home/icon_tab_2_a.png',
    'assets/images/social_home/icon_tab_3_a.png',
    'assets/images/social_home/icon_tab_4_a.png',
  ];
  static const List<String> _labels = <String>['Ana Sayfa', 'Meydan', 'Sohbet', 'Profil'];

  late final AnimationController _controller = AnimationController(vsync: this);
  bool _compositionLoaded = false;

  @override
  void initState() {
    super.initState();
    _controller.addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed) widget.onAnimationComplete();
    });
  }

  @override
  void didUpdateWidget(covariant _NavItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.animate && !oldWidget.animate) _playAnimation();
    if (!widget.animate && oldWidget.animate) _controller.reset();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: widget.onTap,
        behavior: HitTestBehavior.opaque,
        child: SizedBox(
          height: 78,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(
                  width: 48,
                  height: 48,
                  child: widget.animate
                      ? Lottie.asset('assets/lottie/tab_main.json',
                          controller: _controller, repeat: false, onLoaded: _onCompositionLoaded)
                      : SizedBox(
                          width: 32,
                          height: 32,
                          child: Opacity(
                            opacity: widget.selected ? 1.0 : .2,
                            child: Image.asset(_icons[widget.index], fit: BoxFit.contain),
                          ),
                        ),
                ),
                const SizedBox(height: 2),
                Text(
                  _labels[widget.index],
                  style: TextStyle(
                    color: widget.selected ? Colors.white : Colors.white.withOpacity(.2),
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  void _playAnimation() {
    if (!_compositionLoaded) return;
    _controller
      ..reset()
      ..forward();
  }

  void _onCompositionLoaded(LottieComposition composition) {
    _compositionLoaded = true;
    _controller.duration = composition.duration;
    if (widget.animate) _playAnimation();
  }
}
