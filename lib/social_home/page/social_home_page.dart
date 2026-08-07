import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_deer/social_home/data/mock_home_data.dart';
import 'package:flutter_deer/social_home/models/room_model.dart';
import 'package:flutter_deer/social_home/page/message_tab_page.dart';
import 'package:flutter_deer/social_home/page/profile_tab_page.dart';
import 'package:flutter_deer/social_home/page/square_page.dart';
import 'package:flutter_deer/social_home/widgets/home_bottom_bar.dart';
import 'package:flutter_deer/social_home/widgets/home_top_bar.dart';
import 'package:flutter_deer/social_home/widgets/newcomer_reward_dialog.dart';
import 'package:flutter_deer/social_home/widgets/room_card.dart';
import 'package:flutter_deer/social_home/widgets/welcome_lottie_animation.dart';

class SocialHomePage extends StatefulWidget {
  const SocialHomePage({super.key});

  @override
  State<SocialHomePage> createState() => _SocialHomePageState();
}

class _SocialHomePageState extends State<SocialHomePage> with WidgetsBindingObserver {
  // 调整这里的数值即可改变首页背景毛玻璃强度，数值越大越模糊。
  static const double _backgroundBlurSigma = 6;

  int _bottomIndex = 0;
  bool _showWelcomeAnimation = true;
  bool _hasShownAutomaticReward = false;
  bool _hasProcessedInitialResume = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.light,
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarContrastEnforced: false,
    ));
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed) {
      return;
    }
    if (!_hasProcessedInitialResume) {
      _hasProcessedInitialResume = true;
      return;
    }
    if (mounted) {
      setState(() => _showWelcomeAnimation = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final int bottomIndex = _bottomIndex.clamp(0, 3);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.light,
        systemNavigationBarDividerColor: Colors.transparent,
        systemNavigationBarContrastEnforced: false,
      ),
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Scaffold(
            extendBody: true,
            backgroundColor: Colors.transparent,
            body: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                Positioned.fill(
                  child: ImageFiltered(
                    imageFilter: ImageFilter.blur(
                      sigmaX: _backgroundBlurSigma,
                      sigmaY: _backgroundBlurSigma,
                    ),
                    child: Image.asset(
                      'assets/images/social_home/bg_main_page.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SafeArea(
                  child:
                      KeyedSubtree(key: ValueKey<int>(bottomIndex), child: _buildBody(bottomIndex)),
                ),
              ],
            ),
            bottomNavigationBar: HomeBottomBar(
                currentIndex: bottomIndex,
                onTap: (int index) => setState(() => _bottomIndex = index.clamp(0, 3))),
          ),
          if (_showWelcomeAnimation)
            Positioned.fill(
              child: Material(
                color: Colors.transparent,
                child: Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    const ModalBarrier(color: Color(0x99000000), dismissible: false),
                    Center(
                      child: FractionallySizedBox(
                        widthFactor: .88,
                        heightFactor: .68,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(24),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: const Color(0x66101820),
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(color: Colors.white24),
                              ),
                              child: Stack(
                                fit: StackFit.expand,
                                children: <Widget>[
                                  const Positioned(
                                    top: 34,
                                    left: 24,
                                    right: 24,
                                    height: 108,
                                    child: WelcomeLottieAnimation(
                                      asset: 'assets/lottie/welcome_top.json',
                                      repeat: true,
                                    ),
                                  ),
                                  Center(
                                    child: SizedBox(
                                      width: (MediaQuery.sizeOf(context).width * .52)
                                          .clamp(180.0, 220.0),
                                      height: (MediaQuery.sizeOf(context).width * .52)
                                          .clamp(180.0, 220.0),
                                      child: WelcomeLottieAnimation(
                                        asset: 'assets/lottie/welcome.json',
                                        onCompleted: _onWelcomeAnimationCompleted,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    left: 0,
                                    right: 0,
                                    bottom: 16,
                                    child: Center(
                                      child: DecoratedBox(
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(.16),
                                          shape: BoxShape.circle,
                                          border: Border.all(color: Colors.white24),
                                        ),
                                        child: IconButton(
                                          onPressed: () =>
                                              setState(() => _showWelcomeAnimation = false),
                                          color: Colors.white70,
                                          icon: const Icon(Icons.close),
                                          tooltip: 'Kapat',
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBody(int bottomIndex) {
    if (bottomIndex != 0) {
      if (bottomIndex == 1) {
        return const SquarePage();
      }
      if (bottomIndex == 3) {
        return const ProfileTabPage();
      }
      if (bottomIndex == 2) {
        return const MessageTabPage();
      }
      return Center(
          child: Text(HomeBottomBarLabels.labelFor(bottomIndex),
              style: const TextStyle(color: Colors.white70, fontSize: 20)));
    }
    return _RoomsHomeTab(
      onWelcomeTap: () => setState(() => _showWelcomeAnimation = true),
      onSearchTap: _showNewcomerReward,
    );
  }

  void _onWelcomeAnimationCompleted() {
    if (!mounted) {
      return;
    }
    setState(() => _showWelcomeAnimation = false);
    if (!_hasShownAutomaticReward) {
      _hasShownAutomaticReward = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _showNewcomerReward();
        }
      });
    }
  }

  void _showNewcomerReward() => showNewcomerRewardDialog(context);
}

class HomeBottomBarLabels {
  static const List<String> _labels = <String>['Ana Sayfa', 'Meydan', 'Sohbet', 'Profil'];
  static String labelFor(int index) => _labels[index.clamp(0, _labels.length - 1)];
}

class _HomeBanner extends StatelessWidget {
  const _HomeBanner();

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: SizedBox(
            height: 42,
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                Image.asset(
                  'assets/images/social_home/bg_new_user.jpg',
                  fit: BoxFit.cover,
                  color: const Color(0xAA202650),
                  colorBlendMode: BlendMode.multiply,
                ),
                const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: <Color>[Color(0xCC202650), Color(0x992C2358)],
                    ),
                  ),
                ),
                Row(
                  children: <Widget>[
                    const SizedBox(width: 14),
                    const Icon(Icons.auto_awesome, color: Color(0xFF8BE8FF), size: 21),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Text(
                        '新人专享福利，完善资料提高曝光',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(right: 12),
                      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF43E5E1),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Text(
                        '去看看',
                        style: TextStyle(
                            color: Color(0xFF183A49), fontSize: 11, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
}

class _RoomsHomeTab extends StatefulWidget {
  const _RoomsHomeTab({required this.onWelcomeTap, required this.onSearchTap});
  final VoidCallback onWelcomeTap;
  final VoidCallback onSearchTap;

  @override
  State<_RoomsHomeTab> createState() => _RoomsHomeTabState();
}

class _RoomsHomeTabState extends State<_RoomsHomeTab> {
  int _topTab = 0;
  int _pageIndex = 0;
  late final PageController _topPageController;
  double _pagePosition = 0;

  @override
  void initState() {
    super.initState();
    _topPageController = PageController(initialPage: _pageIndex);
    _topPageController.addListener(_handlePageScroll);
  }

  @override
  void dispose() {
    _topPageController.dispose();
    super.dispose();
  }

  void _handlePageScroll() {
    if (!_topPageController.hasClients || !_topPageController.position.haveDimensions) {
      return;
    }
    final double position = _topPageController.page ?? _pageIndex.toDouble();
    if ((position - _pagePosition).abs() < .001 || !mounted) {
      return;
    }
    setState(() => _pagePosition = position);
  }

  @override
  Widget build(BuildContext context) {
    final bool isFamily = _pageIndex < 2;
    final int subTabIndex = isFamily ? _pageIndex : _pageIndex - 2;
    final List<String> subTabs = isFamily ? MockHomeData.familyCategories : MockHomeData.categories;
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 12),
          child: HomeTopBar(
            selected: _topTab,
            indicatorProgress: (_pagePosition - 1).clamp(0.0, 1.0),
            onWelcomeTap: widget.onWelcomeTap,
            onSearchTap: widget.onSearchTap,
            onChanged: (int value) {
              final int targetPage = value == 0 ? 0 : 2;
              _topPageController.animateToPage(targetPage,
                  duration: const Duration(milliseconds: 260), curve: Curves.easeOutCubic);
            },
          ),
        ),
        if (isFamily) const _HomeBanner(),
        _CategoryBar(
          labels: subTabs,
          selected: subTabIndex,
          onChanged: (int value) => _topPageController.animateToPage(isFamily ? value : value + 2,
              duration: const Duration(milliseconds: 260), curve: Curves.easeOutCubic),
        ),
        Expanded(
          child: PageView(
            controller: _topPageController,
            onPageChanged: (int value) => setState(() {
              _pageIndex = value;
              _topTab = value < 2 ? 0 : 1;
            }),
            children: List<Widget>.generate(5, (int index) => _buildPage(index)),
          ),
        ),
      ],
    );
  }

  Widget _buildPage(int pageIndex) {
    return _FakeRoomListPage(
      key: ValueKey<int>(pageIndex),
      pageIndex: pageIndex,
      onRoomTap: (RoomModel room) => _showRoomPreview(context, room),
    );
  }

  void _showRoomPreview(BuildContext context, RoomModel room) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: const Color(0xFF292B2D),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 34),
        child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          const Icon(Icons.drag_handle, color: Colors.white38),
          const SizedBox(height: 12),
          Text(room.title,
              style:
                  const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Text('${room.category} · ${room.onlineCount} kişi çevrimiçi',
              style: const TextStyle(color: Colors.white60)),
          const SizedBox(height: 22),
          FilledButton(onPressed: () => Navigator.pop(context), child: const Text('Odaya Katıl')),
        ]),
      ),
    );
  }
}

class _FakeRoomListPage extends StatefulWidget {
  const _FakeRoomListPage({super.key, required this.pageIndex, required this.onRoomTap});
  final int pageIndex;
  final ValueChanged<RoomModel> onRoomTap;

  @override
  State<_FakeRoomListPage> createState() => _FakeRoomListPageState();
}

class _FakeRoomListPageState extends State<_FakeRoomListPage> {
  static const int _pageSize = 10;
  final ScrollController _scrollController = ScrollController();
  late List<RoomModel> _rooms;
  bool _loadingMore = false;
  int _page = 1;

  @override
  void initState() {
    super.initState();
    _rooms = MockHomeData.roomsForPage(widget.pageIndex, 0, _pageSize);
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => RefreshIndicator(
        color: const Color(0xFF14D8D4),
        onRefresh: _refresh,
        child: CustomScrollView(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: <Widget>[
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 24),
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) =>
                        RoomCard(room: _rooms[index], onTap: () => widget.onRoomTap(_rooms[index])),
                    childCount: _rooms.length),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 6,
                    childAspectRatio: .91),
              ),
            ),
            if (_loadingMore)
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.only(bottom: 28),
                  child: Center(
                    child: SizedBox(
                        width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2)),
                  ),
                ),
              ),
          ],
        ),
      );

  void _onScroll() {
    if (_scrollController.position.extentAfter < 220 && !_loadingMore) {
      _loadMore();
    }
  }

  Future<void> _refresh() async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    if (!mounted) {
      return;
    }
    setState(() {
      _page = 1;
      _rooms = MockHomeData.roomsForPage(widget.pageIndex, 0, _pageSize);
    });
  }

  Future<void> _loadMore() async {
    setState(() => _loadingMore = true);
    await Future<void>.delayed(const Duration(milliseconds: 650));
    if (!mounted) {
      return;
    }
    final List<RoomModel> nextRooms =
        MockHomeData.roomsForPage(widget.pageIndex, _page * _pageSize, _pageSize);
    setState(() {
      _rooms = <RoomModel>[..._rooms, ...nextRooms];
      _page++;
      _loadingMore = false;
    });
  }
}

class _CategoryBar extends StatelessWidget {
  const _CategoryBar({required this.labels, required this.selected, required this.onChanged});
  final List<String> labels;
  final int selected;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) => SizedBox(
        height: 42,
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          scrollDirection: Axis.horizontal,
          itemCount: labels.length,
          separatorBuilder: (_, __) => const SizedBox(width: 22),
          itemBuilder: (_, int index) => GestureDetector(
            onTap: () => onChanged(index),
            child: Center(
                child: Text(labels[index],
                    style: TextStyle(
                        color: selected == index ? const Color(0xFF14D8D4) : Colors.white60,
                        fontSize: 14,
                        fontWeight: selected == index ? FontWeight.w600 : FontWeight.w400))),
          ),
        ),
      );
}
