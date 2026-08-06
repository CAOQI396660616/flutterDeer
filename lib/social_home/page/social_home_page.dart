import 'package:flutter/material.dart';
import 'package:flutter_deer/social_home/data/mock_home_data.dart';
import 'package:flutter_deer/social_home/models/room_model.dart';
import 'package:flutter_deer/social_home/widgets/home_bottom_bar.dart';
import 'package:flutter_deer/social_home/widgets/home_top_bar.dart';
import 'package:flutter_deer/social_home/widgets/room_card.dart';

class SocialHomePage extends StatefulWidget {
  const SocialHomePage({super.key});

  @override
  State<SocialHomePage> createState() => _SocialHomePageState();
}

class _SocialHomePageState extends State<SocialHomePage> {
  int _bottomIndex = 0;

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFF202224),
    body: SafeArea(
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 320),
        reverseDuration: const Duration(milliseconds: 220),
        switchInCurve: Curves.easeOutCubic,
        switchOutCurve: Curves.easeInCubic,
        transitionBuilder: (Widget child, Animation<double> animation) => FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(begin: const Offset(.06, 0), end: Offset.zero).animate(animation),
            child: child,
          ),
        ),
        child: KeyedSubtree(key: ValueKey<int>(_bottomIndex), child: _buildBody()),
      ),
    ),
    bottomNavigationBar: HomeBottomBar(currentIndex: _bottomIndex, onTap: (int index) => setState(() => _bottomIndex = index)),
  );

  Widget _buildBody() {
    if (_bottomIndex != 0) {
      return Center(child: Text(HomeBottomBarLabels.labelFor(_bottomIndex), style: const TextStyle(color: Colors.white70, fontSize: 20)));
    }
    return const _RoomsHomeTab();
  }
}

class HomeBottomBarLabels {
  static const List<String> _labels = <String>['Video', 'Parti', 'Meydan', 'Sohbet', 'Hediye'];
  static String labelFor(int index) => _labels[index];
}

class _RoomsHomeTab extends StatefulWidget {
  const _RoomsHomeTab();

  @override
  State<_RoomsHomeTab> createState() => _RoomsHomeTabState();
}

class _RoomsHomeTabState extends State<_RoomsHomeTab> {
  int _topTab = 1;
  int _categoryIndex = 0;
  bool _showBanner = true;

  @override
  Widget build(BuildContext context) {
    final String category = MockHomeData.categories[_categoryIndex];
    final List<RoomModel> rooms = category == 'All' ? MockHomeData.rooms : MockHomeData.rooms.where((RoomModel room) => room.category == category).toList();
    return CustomScrollView(
      slivers: <Widget>[
        SliverPadding(padding: const EdgeInsets.fromLTRB(20, 18, 20, 12), sliver: SliverToBoxAdapter(child: HomeTopBar(selected: _topTab, onChanged: (int value) => setState(() => _topTab = value)))),
        if (_showBanner)
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 18),
            sliver: SliverToBoxAdapter(child: _HomeBanner(onClose: () => setState(() => _showBanner = false))),
          ),
        SliverToBoxAdapter(child: _CategoryBar(selected: _categoryIndex, onChanged: (int value) => setState(() => _categoryIndex = value))),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          sliver: SliverGrid(
            delegate: SliverChildBuilderDelegate((BuildContext context, int index) => RoomCard(room: rooms[index], onTap: () => _showRoomPreview(context, rooms[index])), childCount: rooms.length),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 14, childAspectRatio: .82),
          ),
        ),
      ],
    );
  }

  void _showRoomPreview(BuildContext context, RoomModel room) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: const Color(0xFF292B2D),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 34),
        child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          const Icon(Icons.drag_handle, color: Colors.white38),
          const SizedBox(height: 12),
          Text(room.title, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Text('${room.category} · ${room.onlineCount} kişi çevrimiçi', style: const TextStyle(color: Colors.white60)),
          const SizedBox(height: 22),
          FilledButton(onPressed: () => Navigator.pop(context), child: const Text('Odaya Katıl')),
        ]),
      ),
    );
  }
}

class _HomeBanner extends StatelessWidget {
  const _HomeBanner({required this.onClose});
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(16),
    child: Stack(children: <Widget>[
      Container(height: 166, width: double.infinity, color: const Color(0xFF2B3031), alignment: Alignment.center, child: const Text('Yeni kullanıcı animasyonu', style: TextStyle(color: Colors.white54, fontSize: 16))),
      Positioned(top: 10, right: 10, child: IconButton(onPressed: onClose, icon: const Icon(Icons.close, color: Colors.white70))),
      const Positioned(bottom: 12, left: 0, right: 0, child: Text('Yeni kullanıcılar için hoş geldin sürprizi', textAlign: TextAlign.center, style: TextStyle(color: Color(0xFF14D8D4), fontSize: 13, fontWeight: FontWeight.w600))),
    ]),
  );
}

class _CategoryBar extends StatelessWidget {
  const _CategoryBar({required this.selected, required this.onChanged});
  final int selected;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 42,
    child: ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      scrollDirection: Axis.horizontal,
      itemCount: MockHomeData.categories.length,
      separatorBuilder: (_, __) => const SizedBox(width: 22),
      itemBuilder: (_, int index) => GestureDetector(
        onTap: () => onChanged(index),
        child: Center(child: Text(MockHomeData.categories[index], style: TextStyle(color: selected == index ? const Color(0xFF14D8D4) : Colors.white60, fontSize: 14, fontWeight: selected == index ? FontWeight.w600 : FontWeight.w400))),
      ),
    ),
  );
}
