import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_deer/social_home/data/mock_home_data.dart';
import 'package:flutter_deer/social_home/models/room_model.dart';
import 'package:flutter_deer/social_home/page/profile_tab_page.dart';
import 'package:flutter_deer/social_home/widgets/home_bottom_bar.dart';
import 'package:flutter_deer/social_home/widgets/home_top_bar.dart';
import 'package:flutter_deer/social_home/widgets/room_card.dart';
import 'package:flutter_deer/social_home/widgets/welcome_lottie_animation.dart';

class SocialHomePage extends StatefulWidget {
  const SocialHomePage({super.key});

  @override
  State<SocialHomePage> createState() => _SocialHomePageState();
}

class _SocialHomePageState extends State<SocialHomePage> {
  // 调整这里的数值即可改变首页背景毛玻璃强度，数值越大越模糊。
  static const double _backgroundBlurSigma = 6;

  int _bottomIndex = 0;
  bool _showWelcomeAnimation = true;

  @override
  void initState() {
    super.initState();
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
                    const ModalBarrier(color: Colors.transparent, dismissible: false),
                    Center(
                      child: SizedBox(
                        width: 180,
                        height: 180,
                        child: WelcomeLottieAnimation(
                          asset: 'assets/lottie/welcome.json',
                          onCompleted: () => setState(() => _showWelcomeAnimation = false),
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
      if (bottomIndex == 3) {
        return const ProfileTabPage();
      }
      return Center(
          child: Text(HomeBottomBarLabels.labelFor(bottomIndex),
              style: const TextStyle(color: Colors.white70, fontSize: 20)));
    }
    return const _RoomsHomeTab();
  }
}

class HomeBottomBarLabels {
  static const List<String> _labels = <String>['Ana Sayfa', 'Meydan', 'Sohbet', 'Profil'];
  static String labelFor(int index) => _labels[index.clamp(0, _labels.length - 1)];
}

class _RoomsHomeTab extends StatefulWidget {
  const _RoomsHomeTab();

  @override
  State<_RoomsHomeTab> createState() => _RoomsHomeTabState();
}

class _RoomsHomeTabState extends State<_RoomsHomeTab> {
  int _topTab = 1;
  int _pageIndex = 2;
  late final PageController _topPageController;

  @override
  void initState() {
    super.initState();
    _topPageController = PageController(initialPage: _pageIndex);
  }

  @override
  void dispose() {
    _topPageController.dispose();
    super.dispose();
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
            onChanged: (int value) {
              final int targetPage = value == 0 ? 0 : 2;
              _topPageController.animateToPage(targetPage,
                  duration: const Duration(milliseconds: 260), curve: Curves.easeOutCubic);
            },
          ),
        ),
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
    if (pageIndex < 2) {
      return Center(
          child: Text(MockHomeData.familyCategories[pageIndex],
              style: const TextStyle(color: Colors.white70, fontSize: 20)));
    }
    final String category = MockHomeData.categories[pageIndex - 2];
    final List<RoomModel> rooms = category == 'All'
        ? MockHomeData.rooms
        : MockHomeData.rooms.where((RoomModel room) => room.category == category).toList();
    return _buildRoomsGrid(rooms);
  }

  Widget _buildRoomsGrid(List<RoomModel> rooms) => CustomScrollView(
        slivers: <Widget>[
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 24),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) => RoomCard(
                      room: rooms[index], onTap: () => _showRoomPreview(context, rooms[index])),
                  childCount: rooms.length),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 6,
                  childAspectRatio: .91),
            ),
          ),
        ],
      );

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
