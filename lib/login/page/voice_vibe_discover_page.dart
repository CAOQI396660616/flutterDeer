import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_deer/login/data/voice_vibe_discover_data.dart';
import 'package:flutter_deer/login/login_router.dart';
import 'package:flutter_deer/login/models/voice_vibe_discover_model.dart';
import 'package:flutter_deer/login/page/voice_vibe_live_room_page.dart';
import 'package:flutter_deer/login/widgets/voice_vibe_bottom_navigation_bar.dart';
import 'package:flutter_deer/routers/fluro_navigator.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// VoiceVibe 声浪发现页。
///
/// 页面根据 Figma 节点 `3:291` 实现，提供搜索、分类标签切换、
/// 当下最热现场网格与人气红人列表。所有交互均为本地演示。
class VoiceVibeDiscoverPage extends StatefulWidget {
  const VoiceVibeDiscoverPage({super.key});

  @override
  State<VoiceVibeDiscoverPage> createState() => _VoiceVibeDiscoverPageState();
}

class _VoiceVibeDiscoverPageState extends State<VoiceVibeDiscoverPage> {
  static const Color _backgroundColor = Color(0xFFFEF7FF);
  static const Color _primaryColor = Color(0xFF6750A4);
  static const Color _surfaceColor = Color(0xFFF7F2FA);
  static const Color _outlineColor = Color(0xFFE7E0EC);
  static const Color _secondaryContainerColor = Color(0xFFEADDFF);
  static const Color _onSurfaceColor = Color(0xFF1C1B1F);
  static const Color _secondaryTextColor = Color(0xFF49454F);
  static const Color _liveColor = Color(0xFFFF0055);
  static const Color _onlineColor = Color(0xFF00BC35);

  static const String _assetDir = 'assets/images/login/voice_vibe';

  int _selectedChipIndex = 0;
  static const int _selectedTabIndex = 1;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
  }

  /// 切换标签筛选。
  void _selectChip(int index) {
    if (_selectedChipIndex == index) {
      return;
    }
    setState(() => _selectedChipIndex = index);
    _showMessage('已切换到「${VoiceVibeDiscoverData.chips[index]}」分类');
  }

  /// 显示页面内轻量反馈，避免演示操作静默失败。
  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  void _selectTab(int index) {
    if (index == _selectedTabIndex) {
      return;
    }
    final String? target = <int, String>{
      0: LoginRouter.voiceVibeHomePage,
      2: LoginRouter.voiceVibeMessagePage,
      3: LoginRouter.voiceVibeProfilePage,
    }[index];
    if (target != null) {
      NavigatorUtils.push(context, target, replace: true);
    }
  }

  void _openRoom(VoiceVibeDiscoverGridCard card) {
    NavigatorUtils.push(
      context,
      VoiceVibeLiveRoomPage.routePath(
        title: card.title,
        coverAsset: card.coverAsset,
        hostName: card.hostLine.replaceFirst('Host: ', '').split(' · ').first,
        listenerLabel: card.hostLine.split(' · ').last,
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: _backgroundColor,
        body: SafeArea(
          bottom: false,
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              _buildSearchBar(),
              _buildChips(),
              _buildTrendingSection(),
              _buildHostsSection(),
            ],
          ),
        ),
        bottomNavigationBar: VoiceVibeBottomNavigationBar(
          currentIndex: _selectedTabIndex,
          onTap: _selectTab,
        ),
      );

  Widget _buildSearchBar() => Padding(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: const BoxDecoration(
            color: _surfaceColor,
            borderRadius: BorderRadius.all(Radius.circular(100)),
          ),
          child: Row(
            children: <Widget>[
              SvgPicture.asset(
                '$_assetDir/voice_vibe_discover_search.svg',
                width: 18,
                height: 18,
                semanticsLabel: '搜索',
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  VoiceVibeDiscoverData.searchHint,
                  style: TextStyle(
                    color: _secondaryTextColor.withOpacity(0.6),
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  Widget _buildChips() => Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: <Widget>[
            for (int index = 0; index < VoiceVibeDiscoverData.chips.length; index++)
              _FilterChip(
                label: VoiceVibeDiscoverData.chips[index],
                selected: index == _selectedChipIndex,
                onTap: () => _selectChip(index),
              ),
          ],
        ),
      );

  Widget _buildTrendingSection() => Padding(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              '当下最热现场',
              style: TextStyle(
                color: _onSurfaceColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Column(
              children: <Widget>[
                for (int row = 0; row < 2; row++)
                  Padding(
                    padding: EdgeInsets.only(bottom: row == 0 ? 12 : 0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: _TrendingGridCard(
                            card: VoiceVibeDiscoverData.trendingCards[row * 2],
                            onTap: () => _openRoom(VoiceVibeDiscoverData.trendingCards[row * 2]),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _TrendingGridCard(
                            card: VoiceVibeDiscoverData.trendingCards[row * 2 + 1],
                            onTap: () =>
                                _openRoom(VoiceVibeDiscoverData.trendingCards[row * 2 + 1]),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ],
        ),
      );

  Widget _buildHostsSection() => Padding(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              '人气红人',
              style: TextStyle(
                color: _onSurfaceColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Column(
              children: <Widget>[
                for (int i = 0; i < VoiceVibeDiscoverData.hosts.length; i++) ...[
                  if (i > 0) const SizedBox(height: 8),
                  _HostItem(
                    host: VoiceVibeDiscoverData.hosts[i],
                    onFollow: () => _showMessage(
                      '已关注「${VoiceVibeDiscoverData.hosts[i].name}」',
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      );
}

/// 分类标签胶囊。
class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: selected
                ? _VoiceVibeDiscoverPageState._secondaryContainerColor
                : _VoiceVibeDiscoverPageState._surfaceColor,
            borderRadius: BorderRadius.circular(100),
            border: Border.all(
              color: selected
                  ? _VoiceVibeDiscoverPageState._primaryColor
                  : _VoiceVibeDiscoverPageState._outlineColor,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: selected
                  ? const Color(0xFF21005D)
                  : _VoiceVibeDiscoverPageState._secondaryTextColor,
              fontSize: 13,
              fontWeight: selected ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ),
      );
}

/// 当下最热现场网格卡片，背景图之上叠加 LIVE 徽章与元信息。
class _TrendingGridCard extends StatelessWidget {
  const _TrendingGridCard({required this.card, required this.onTap});

  final VoiceVibeDiscoverGridCard card;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: SizedBox(
            height: 130,
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                Image.asset(
                  card.coverAsset,
                  fit: BoxFit.cover,
                  semanticLabel: '${card.title}封面',
                ),
                Container(color: const Color(0x4D000000)),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: const BoxDecoration(
                          color: _VoiceVibeDiscoverPageState._liveColor,
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Text(
                              'LIVE',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            card.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            card.hostLine,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}

/// 人气红人列表项。
class _HostItem extends StatelessWidget {
  const _HostItem({required this.host, required this.onFollow});

  final VoiceVibeDiscoverHost host;
  final VoidCallback onFollow;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: _VoiceVibeDiscoverPageState._surfaceColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _VoiceVibeDiscoverPageState._outlineColor),
        ),
        child: Row(
          children: <Widget>[
            ClipOval(
              child: Image.asset(
                host.avatarAsset,
                width: 40,
                height: 40,
                fit: BoxFit.cover,
                semanticLabel: '${host.name}头像',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    host.name,
                    style: const TextStyle(
                      color: _VoiceVibeDiscoverPageState._onSurfaceColor,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    host.fansLabel,
                    style: const TextStyle(
                      color: _VoiceVibeDiscoverPageState._secondaryTextColor,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: <Widget>[
                Text(
                  host.isOnline ? '在线' : '离线',
                  style: TextStyle(
                    color: host.isOnline
                        ? _VoiceVibeDiscoverPageState._onlineColor
                        : _VoiceVibeDiscoverPageState._secondaryTextColor.withOpacity(0.6),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(width: 8),
                Semantics(
                  button: true,
                  label: '关注${host.name}',
                  child: InkWell(
                    onTap: onFollow,
                    borderRadius: BorderRadius.circular(100),
                    child: Ink(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: const BoxDecoration(
                        color: _VoiceVibeDiscoverPageState._primaryColor,
                        borderRadius: BorderRadius.all(Radius.circular(100)),
                      ),
                      child: const Text(
                        '+ 关注',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
}
