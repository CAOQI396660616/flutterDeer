import 'dart:async';

import 'package:flutter/material.dart';

/// Rotating promotional banner shown above the Odalar category bar.
class RoomsBanner extends StatefulWidget {
  const RoomsBanner({super.key});

  @override
  State<RoomsBanner> createState() => _RoomsBannerState();
}

class _RoomsBannerState extends State<RoomsBanner> {
  static const List<_RoomsBannerItem> _items = <_RoomsBannerItem>[
    _RoomsBannerItem(
      imageUrl:
          'https://images.unsplash.com/photo-1511632765486-a01980e01a18?auto=format&fit=crop&w=1200&q=80',
    ),
    _RoomsBannerItem(
      imageUrl:
          'https://images.unsplash.com/photo-1492684223066-81342ee5ff30?auto=format&fit=crop&w=1200&q=80',
    ),
    _RoomsBannerItem(
      imageUrl:
          'https://images.unsplash.com/photo-1529156069898-49953e39b3ac?auto=format&fit=crop&w=1200&q=80',
    ),
  ];

  late final PageController _controller;
  Timer? _timer;
  int _index = 0;

  @override
  void initState() {
    super.initState();
    _controller = PageController();
    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!mounted || !_controller.hasClients) {
        return;
      }
      final int nextIndex = (_index + 1) % _items.length;
      _controller.animateToPage(
        nextIndex,
        duration: const Duration(milliseconds: 420),
        curve: Curves.easeOutCubic,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: SizedBox(
            height: 105,
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                PageView.builder(
                  controller: _controller,
                  itemCount: _items.length,
                  onPageChanged: (int value) => setState(() => _index = value),
                  itemBuilder: (_, int index) => _RoomsBannerSlide(item: _items[index]),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 5,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List<Widget>.generate(
                      _items.length,
                      (int index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        width: index == _index ? 12 : 4,
                        height: 3,
                        decoration: BoxDecoration(
                          color: index == _index ? Colors.white : Colors.white54,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}

class _RoomsBannerSlide extends StatelessWidget {
  const _RoomsBannerSlide({required this.item});
  final _RoomsBannerItem item;

  @override
  Widget build(BuildContext context) => Image.network(
        item.imageUrl,
        fit: BoxFit.cover,
        loadingBuilder: (_, Widget child, ImageChunkEvent? loadingProgress) {
          if (loadingProgress == null) {
            return child;
          }
          return const _RoomsBannerPlaceholder();
        },
        errorBuilder: (_, __, ___) => const _RoomsBannerPlaceholder(),
      );
}

class _RoomsBannerPlaceholder extends StatelessWidget {
  const _RoomsBannerPlaceholder();

  @override
  Widget build(BuildContext context) => ColoredBox(
        color: const Color(0xFF1B1746),
        child: Center(
          child: Image.asset(
            'assets/images/splash_logo.png',
            width: 72,
            height: 72,
            fit: BoxFit.contain,
          ),
        ),
      );
}

class _RoomsBannerItem {
  const _RoomsBannerItem({required this.imageUrl});
  final String imageUrl;
}
