import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_deer/login/data/voice_vibe_home_data.dart';
import 'package:flutter_deer/login/login_router.dart';
import 'package:flutter_deer/login/models/voice_vibe_home_model.dart';
import 'package:flutter_deer/routers/fluro_navigator.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// VoiceVibe 声浪首页。
///
/// 页面根据 Figma 节点 `3:56` 实现，承接 VoiceVibe 登录页之后的内容流。
/// 分类切换、开播和底部导航均为本地交互演示，不会请求真实服务端。
class VoiceVibeHomePage extends StatefulWidget {
  const VoiceVibeHomePage({super.key});

  @override
  State<VoiceVibeHomePage> createState() => _VoiceVibeHomePageState();
}

class _VoiceVibeHomePageState extends State<VoiceVibeHomePage> {
  static const Color _backgroundColor = Color(0xFFFEF7FF);
  static const Color _primaryColor = Color(0xFF6750A4);
  static const Color _surfaceColor = Color(0xFFF7F2FA);
  static const Color _outlineColor = Color(0xFFE7E0EC);
  static const Color _secondarySurfaceColor = Color(0xFFE8DEF8);
  static const Color _secondaryContainerColor = Color(0xFFEADDFF);
  static const Color _onSurfaceColor = Color(0xFF1C1B1F);
  static const Color _secondaryTextColor = Color(0xFF49454F);
  static const Color _liveColor = Color(0xFFFF0055);

  static const String _assetDir = 'assets/images/login/voice_vibe';

  /// 底部导航项配置，图标与文案同 Figma 节点 `3:178`。
  static const List<_BottomTabData> _bottomTabs = <_BottomTabData>[
    _BottomTabData(label: '首页', iconAsset: '$_assetDir/voice_vibe_tab_home.svg'),
    _BottomTabData(label: '发现', iconAsset: '$_assetDir/voice_vibe_tab_compass.svg'),
    _BottomTabData(label: '消息', iconAsset: '$_assetDir/voice_vibe_tab_message.svg'),
    _BottomTabData(label: '我的', iconAsset: '$_assetDir/voice_vibe_tab_user.svg'),
  ];

  int _selectedCategoryIndex = 0;
  int _selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
  }

  /// 切换顶部分类标签。
  void _selectCategory(int index) {
    if (_selectedCategoryIndex == index) {
      return;
    }
    setState(() => _selectedCategoryIndex = index);
    _showMessage('已切换到「${VoiceVibeHomeData.categories[index]}」分类');
  }

  /// 切换底部导航栏。
  void _selectTab(int index) {
    if (_selectedTabIndex == index) {
      return;
    }
    switch (index) {
      case 1:
        NavigatorUtils.push(context, LoginRouter.voiceVibeDiscoverPage);
        return;
      case 2:
        NavigatorUtils.push(context, LoginRouter.voiceVibeMessagePage);
        return;
      case 3:
        NavigatorUtils.push(context, LoginRouter.voiceVibeProfilePage);
        return;
    }
    setState(() => _selectedTabIndex = index);
  }

  /// 显示页面内轻量反馈，避免演示操作静默失败。
  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: _backgroundColor,
        body: SafeArea(
          bottom: false,
          child: Column(
            children: <Widget>[
              _buildHeaderRow(),
              _buildCategories(),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: <Widget>[
                    _buildFeaturedSection(),
                    _buildRecommendedSection(),
                  ],
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: _buildStartLiveButton(),
        bottomNavigationBar: _buildBottomNavigationBar(),
      );

  Widget _buildHeaderRow() => Padding(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            const Text(
              'VoiceVibe',
              style: TextStyle(
                color: _primaryColor,
                fontSize: 22,
                fontWeight: FontWeight.w800,
              ),
            ),
            Row(
              children: <Widget>[
                _CircleIconButton(
                  semanticLabel: '搜索',
                  iconAsset: '$_assetDir/voice_vibe_search.svg',
                  onTap: () => _showMessage('搜索功能暂未配置'),
                ),
                const SizedBox(width: 12),
                _CircleIconButton(
                  semanticLabel: '通知',
                  iconAsset: '$_assetDir/voice_vibe_bell_dot.svg',
                  onTap: () => _showMessage('通知功能暂未配置'),
                ),
              ],
            ),
          ],
        ),
      );

  Widget _buildCategories() => SizedBox(
        height: 48,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          itemCount: VoiceVibeHomeData.categories.length,
          separatorBuilder: (_, __) => const SizedBox(width: 20),
          itemBuilder: (BuildContext context, int index) => _CategoryTab(
            label: VoiceVibeHomeData.categories[index],
            selected: index == _selectedCategoryIndex,
            onTap: () => _selectCategory(index),
          ),
        ),
      );

  Widget _buildFeaturedSection() => Padding(
        padding: const EdgeInsets.only(top: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const Text(
                    '精选 live 现场',
                    style: TextStyle(
                      color: _onSurfaceColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _showMessage('精选列表暂未配置'),
                    child: SvgPicture.asset(
                      '$_assetDir/voice_vibe_arrow_right.svg',
                      width: 20,
                      height: 20,
                      semanticsLabel: '查看更多精选直播',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 150,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(left: 24, right: 24),
                itemCount: VoiceVibeHomeData.featuredRooms.length,
                separatorBuilder: (_, __) => const SizedBox(width: 16),
                itemBuilder: (BuildContext context, int index) {
                  final VoiceVibeLiveRoom room = VoiceVibeHomeData.featuredRooms[index];
                  return _FeaturedLiveCard(
                    room: room,
                    onTap: () => _showMessage('即将进入「${room.title}」'),
                  );
                },
              ),
            ),
          ],
        ),
      );

  Widget _buildRecommendedSection() => Padding(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              '为您推荐',
              style: TextStyle(
                color: _onSurfaceColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            for (final VoiceVibeRecommendRoom room in VoiceVibeHomeData.recommendRooms)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _RecommendRoomItem(
                  room: room,
                  onTap: () => _showMessage('即将进入「${room.title}」'),
                ),
              ),
          ],
        ),
      );

  Widget _buildStartLiveButton() => FloatingActionButton.extended(
        onPressed: () => _showMessage('开播功能暂未配置'),
        backgroundColor: _secondaryContainerColor,
        foregroundColor: const Color(0xFF21005D),
        elevation: 4,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(24)),
        ),
        icon: SvgPicture.asset(
          '$_assetDir/voice_vibe_mic.svg',
          width: 24,
          height: 24,
          semanticsLabel: '开播',
        ),
        label: const Text(
          '开播',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      );

  Widget _buildBottomNavigationBar() => Container(
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
                for (int index = 0; index < _bottomTabs.length; index++)
                  _BottomTabItem(
                    data: _bottomTabs[index],
                    selected: index == _selectedTabIndex,
                    onTap: () => _selectTab(index),
                  ),
              ],
            ),
          ),
        ),
      );
}

/// 底部导航项配置数据。
class _BottomTabData {
  const _BottomTabData({required this.label, required this.iconAsset});

  final String label;
  final String iconAsset;
}

/// 顶部圆形图标按钮，用于搜索和通知入口。
class _CircleIconButton extends StatelessWidget {
  const _CircleIconButton({
    required this.semanticLabel,
    required this.iconAsset,
    required this.onTap,
  });

  final String semanticLabel;
  final String iconAsset;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Semantics(
        button: true,
        label: semanticLabel,
        child: Ink(
          width: 40,
          height: 40,
          decoration: const BoxDecoration(
            color: _VoiceVibeHomePageState._surfaceColor,
            shape: BoxShape.circle,
          ),
          child: InkWell(
            onTap: onTap,
            customBorder: const CircleBorder(),
            child: Center(
              child: SvgPicture.asset(iconAsset, width: 20, height: 20),
            ),
          ),
        ),
      );
}

/// 顶部分类标签，选中态在文案下方展示指示条。
class _CategoryTab extends StatelessWidget {
  const _CategoryTab({
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
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              label,
              style: TextStyle(
                color: selected
                    ? _VoiceVibeHomePageState._primaryColor
                    : _VoiceVibeHomePageState._secondaryTextColor.withOpacity(0.6),
                fontSize: 16,
                fontWeight: selected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            const SizedBox(height: 4),
            Container(
              width: 16,
              height: 3,
              decoration: BoxDecoration(
                color: selected
                    ? _VoiceVibeHomePageState._primaryColor
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ),
      );
}

/// 精选 live 现场卡片，封面之上叠加直播状态与主播信息。
class _FeaturedLiveCard extends StatelessWidget {
  const _FeaturedLiveCard({required this.room, required this.onTap});

  final VoiceVibeLiveRoom room;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: SizedBox(
            width: 260,
            height: 150,
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                Image.asset(
                  room.coverAsset,
                  fit: BoxFit.cover,
                  semanticLabel: '${room.title}封面',
                ),
                const ColoredBox(color: Color(0x66000000)),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          const _LiveBadge(),
                          _ListenerBadge(label: room.listenerLabel),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            room.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: <Widget>[
                              ClipOval(
                                child: Image.asset(
                                  room.hostAvatarAsset,
                                  width: 20,
                                  height: 20,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                room.hostName,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.8),
                                  fontSize: 12,
                                ),
                              ),
                            ],
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

/// 直播中标识。
class _LiveBadge extends StatelessWidget {
  const _LiveBadge();

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: const BoxDecoration(
          color: _VoiceVibeHomePageState._liveColor,
          borderRadius: BorderRadius.all(Radius.circular(4)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              width: 6,
              height: 6,
              decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
            ),
            const SizedBox(width: 4),
            const Text(
              'LIVE',
              style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      );
}

/// 卡片右上角的在线收听人数标识。
class _ListenerBadge extends StatelessWidget {
  const _ListenerBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: const BoxDecoration(
          color: Color(0x61000000),
          borderRadius: BorderRadius.all(Radius.circular(100)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SvgPicture.asset(
              '${_VoiceVibeHomePageState._assetDir}/voice_vibe_headphones.svg',
              width: 12,
              height: 12,
              semanticsLabel: '在线收听人数',
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
}

/// 为您推荐列表项。
class _RecommendRoomItem extends StatelessWidget {
  const _RecommendRoomItem({required this.room, required this.onTap});

  final VoiceVibeRecommendRoom room;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: _VoiceVibeHomePageState._surfaceColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _VoiceVibeHomePageState._outlineColor),
          ),
          child: Row(
            children: <Widget>[
              SizedBox(
                width: 48,
                height: 48,
                child: Stack(
                  children: <Widget>[
                    ClipOval(
                      child: Image.asset(
                        room.avatarAsset,
                        width: 48,
                        height: 48,
                        fit: BoxFit.cover,
                        semanticLabel: '${room.hostName}头像',
                      ),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: _VoiceVibeHomePageState._liveColor,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: _VoiceVibeHomePageState._surfaceColor,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      room.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: _VoiceVibeHomePageState._onSurfaceColor,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: <Widget>[
                        Flexible(
                          child: Text(
                            room.hostName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: _VoiceVibeHomePageState._secondaryTextColor,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: const BoxDecoration(
                            color: _VoiceVibeHomePageState._secondarySurfaceColor,
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                          ),
                          child: Text(
                            room.categoryLabel,
                            style: const TextStyle(
                              color: Color(0xFF1D192B),
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  const _WaveformIndicator(),
                  const SizedBox(height: 4),
                  Text(
                    room.listenerLabel,
                    style: const TextStyle(
                      color: _VoiceVibeHomePageState._secondaryTextColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
}

/// 推荐列表右侧的静态声波指示条。
class _WaveformIndicator extends StatelessWidget {
  const _WaveformIndicator();

  /// 各声波条高度，取自 Figma 节点 `3:124`。
  static const List<double> _barHeights = <double>[12, 18, 10, 22, 14, 16, 8];

  @override
  Widget build(BuildContext context) => SizedBox(
        height: 22,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            for (final double height in _barHeights)
              Padding(
                padding: const EdgeInsets.only(right: 2),
                child: Container(
                  width: 2.5,
                  height: height,
                  decoration: BoxDecoration(
                    color: _VoiceVibeHomePageState._primaryColor,
                    borderRadius: BorderRadius.circular(1.25),
                  ),
                ),
              ),
          ],
        ),
      );
}

/// 底部导航单项，选中态展示胶囊背景。
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
        child: GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.opaque,
          child: SizedBox(
            width: 64,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  width: 48,
                  height: 32,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: selected
                        ? _VoiceVibeHomePageState._secondaryContainerColor
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Opacity(
                    opacity: selected ? 1 : 0.6,
                    child: SvgPicture.asset(data.iconAsset, width: 22, height: 22),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  data.label,
                  style: TextStyle(
                    color: selected
                        ? _VoiceVibeHomePageState._primaryColor
                        : _VoiceVibeHomePageState._onSurfaceColor.withOpacity(0.6),
                    fontSize: 12,
                    fontWeight: selected ? FontWeight.bold : FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
