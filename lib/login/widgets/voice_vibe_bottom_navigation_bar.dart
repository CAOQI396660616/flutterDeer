import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// VoiceVibe 共用底部导航栏。
///
/// 各个 tab 页面通过 [currentIndex] 标记当前页面，并由外部处理路由切换，
/// 这样导航栏的视觉和交互在首页、发现、消息、我的之间保持一致。
class VoiceVibeBottomNavigationBar extends StatelessWidget {
  const VoiceVibeBottomNavigationBar({
    required this.currentIndex,
    required this.onTap,
    super.key,
  });

  static const String _assetDir = 'assets/images/login/voice_vibe';
  static const Color _surfaceColor = Color(0xFFF7F2FA);
  static const Color _primaryColor = Color(0xFF6750A4);
  static const Color _onSurfaceColor = Color(0xFF1C1B1F);

  static const List<_BottomTabData> _tabs = <_BottomTabData>[
    _BottomTabData(label: '首页', iconAsset: '$_assetDir/voice_vibe_tab_home.svg'),
    _BottomTabData(label: '发现', iconAsset: '$_assetDir/voice_vibe_tab_compass.svg'),
    _BottomTabData(label: '消息', iconAsset: '$_assetDir/voice_vibe_tab_message.svg'),
    _BottomTabData(label: '我的', iconAsset: '$_assetDir/voice_vibe_tab_user.svg'),
  ];

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) => Container(
        decoration: const BoxDecoration(
          color: _surfaceColor,
          border: Border(top: BorderSide(color: Color(0x0F000000))),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                for (int index = 0; index < _tabs.length; index++)
                  _BottomTabItem(
                    data: _tabs[index],
                    selected: index == currentIndex,
                    onTap: () => onTap(index),
                  ),
              ],
            ),
          ),
        ),
      );
}

class _BottomTabData {
  const _BottomTabData({required this.label, required this.iconAsset});

  final String label;
  final String iconAsset;
}

class _BottomTabItem extends StatelessWidget {
  const _BottomTabItem({
    required this.data,
    required this.selected,
    required this.onTap,
  });

  final _BottomTabData data;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Semantics(
        button: true,
        selected: selected,
        label: data.label,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 3),
                  decoration: BoxDecoration(
                    color: selected ? const Color(0xFFEADDFF) : Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: SvgPicture.asset(
                    data.iconAsset,
                    width: 22,
                    height: 22,
                    colorFilter: ColorFilter.mode(
                      selected
                          ? VoiceVibeBottomNavigationBar._primaryColor
                          : VoiceVibeBottomNavigationBar._onSurfaceColor.withOpacity(0.6),
                      BlendMode.srcIn,
                    ),
                    semanticsLabel: data.label,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  data.label,
                  style: TextStyle(
                    color: selected
                        ? VoiceVibeBottomNavigationBar._primaryColor
                        : VoiceVibeBottomNavigationBar._onSurfaceColor.withOpacity(0.6),
                    fontSize: 12,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
