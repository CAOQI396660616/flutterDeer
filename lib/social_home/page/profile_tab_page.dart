import 'package:flutter/material.dart';
import 'package:flutter_deer/login/store/login_user_store.dart';
import 'package:flutter_deer/login/widgets/remote_avatar.dart';
import 'package:flutter_deer/social_home/data/mock_paged_data.dart';
import 'package:flutter_deer/social_home/data/user_assets.dart';
import 'package:flutter_deer/social_home/page/profile_edit_page.dart';
import 'package:flutter_deer/social_home/page/profile_settings_page.dart';
import 'package:flutter_deer/social_home/widgets/home_top_bar.dart';

/// First-stage Profil UI: profile area, pinned tabs, and local mock content.
class ProfileTabPage extends StatefulWidget {
  const ProfileTabPage({super.key});

  @override
  State<ProfileTabPage> createState() => _ProfileTabPageState();
}

class _ProfileTabPageState extends State<ProfileTabPage> {
  late final PageController _pageController;
  int _pageIndex = 0;
  double _pagePosition = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _pageController.addListener(_handlePageScroll);
  }

  @override
  void dispose() {
    _pageController
      ..removeListener(_handlePageScroll)
      ..dispose();
    super.dispose();
  }

  void _handlePageScroll() {
    if (!_pageController.hasClients || !_pageController.position.haveDimensions || !mounted) {
      return;
    }
    final double position = _pageController.page ?? _pageIndex.toDouble();
    if ((position - _pagePosition).abs() < .001) {
      return;
    }
    setState(() => _pagePosition = position);
  }

  @override
  Widget build(BuildContext context) {
    final user = LoginUserStore.currentUser;
    final String nickname = user?.nickname ?? 'Emre Yılmaz';
    final String avatar = user?.avatar ?? UserAssets.avatar002;
    return NestedScrollView(
      headerSliverBuilder: (BuildContext headerContext, __) => <Widget>[
        SliverToBoxAdapter(child: _ProfileHeader(nickname: nickname, avatar: avatar)),
        SliverOverlapAbsorber(
          handle: NestedScrollView.sliverOverlapAbsorberHandleFor(headerContext),
          sliver: SliverPersistentHeader(
            pinned: true,
            delegate: _ProfileTabHeaderDelegate(
                selected: _pageIndex, pagePosition: _pagePosition, onChanged: _animateToPage),
          ),
        ),
      ],
      body: Builder(
        builder: (BuildContext bodyContext) {
          final SliverOverlapAbsorberHandle overlapHandle =
              NestedScrollView.sliverOverlapAbsorberHandleFor(bodyContext);
          return PageView(
            controller: _pageController,
            onPageChanged: (int value) => setState(() {
              _pageIndex = value;
              _pagePosition = value.toDouble();
            }),
            children: <Widget>[
              _DynamicContent(handle: overlapHandle),
              _ProfileContent(handle: overlapHandle),
            ],
          );
        },
      ),
    );
  }

  void _animateToPage(int value) {
    _pageController.animateToPage(
      value,
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOutCubic,
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({required this.nickname, required this.avatar});
  final String nickname;
  final String avatar;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Align(
              alignment: Alignment.centerRight,
              child: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
                HomeActionButton(
                  icon: Icons.edit_outlined,
                  label: 'Düzenle',
                  onTap: () => Navigator.of(context).push<void>(
                    MaterialPageRoute<void>(builder: (_) => const ProfileEditPage()),
                  ),
                ),
                const SizedBox(width: 16),
                HomeActionButton(
                  icon: Icons.settings_outlined,
                  label: 'Ayarlar',
                  onTap: () => Navigator.of(context).push<void>(
                    MaterialPageRoute<void>(builder: (_) => const ProfileSettingsPage()),
                  ),
                ),
              ]),
            ),
            const SizedBox(height: 16),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
              Row(children: <Widget>[
                Container(
                  width: 82,
                  height: 82,
                  padding: const EdgeInsets.all(3),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: <BoxShadow>[BoxShadow(color: Colors.black38, blurRadius: 12)],
                  ),
                  child: ClipOval(child: RemoteAvatar(imageUrl: avatar)),
                ),
                const SizedBox(width: 22),
                const Expanded(
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
                    _ProfileStat(value: '0', label: 'Takip'),
                    _ProfileStat(value: '0', label: 'Takipçi'),
                    _ProfileStat(value: '6', label: 'Son ziyaret'),
                  ]),
                ),
              ]),
              const SizedBox(height: 14),
              Row(children: <Widget>[
                Text(nickname,
                    style: const TextStyle(
                        color: Colors.white, fontSize: 23, fontWeight: FontWeight.w600)),
                const SizedBox(width: 8),
                const _ProfileBadge(
                  text: '25',
                  colors: <Color>[Color(0xFF36E8E6), Color(0xFF19BFC8)],
                  textColor: Color(0xFF103D4A),
                ),
              ]),
              const SizedBox(height: 6),
              const Text('ID: 177173883   IP konumu: Guangdong',
                  style: TextStyle(color: Colors.white60, fontSize: 12)),
              const SizedBox(height: 10),
              const Wrap(spacing: 6, runSpacing: 6, children: <Widget>[
                _ProfileBadge(
                  text: 'SV1',
                  colors: <Color>[Color(0xFFFFE68A), Color(0xFFFF9D5C)],
                  textColor: Color(0xFF6E2B25),
                ),
                _ProfileBadge(
                  text: 'V1',
                  colors: <Color>[Color(0xFFFFD36E), Color(0xFFFF8B4D)],
                  textColor: Color(0xFF6E2B25),
                ),
                _ProfileBadge(
                  text: 'SVIP',
                  colors: <Color>[Color(0xFF9BE7FF), Color(0xFF62A9FF)],
                  textColor: Color(0xFF153B70),
                ),
                _ProfileBadge(
                  text: 'Sıradan',
                  colors: <Color>[Color(0xFFD7B4FF), Color(0xFF9C72F2)],
                  textColor: Color(0xFF3E1D70),
                ),
                _ProfileBadge(
                  text: 'Küçük Çaylak',
                  colors: <Color>[Color(0xFFE3E7F0), Color(0xFFAAB4C7)],
                  textColor: Color(0xFF39445A),
                ),
                _ProfileBadge(
                  text: 'Yeni Bronz',
                  colors: <Color>[Color(0xFFFFB8D8), Color(0xFFFF7B9E)],
                  textColor: Color(0xFF6C203D),
                ),
              ]),
              const SizedBox(height: 14),
              const Text('Profiline bir imza ekleyerek daha fazla ilgi çekebilirsin',
                  style: TextStyle(color: Colors.white70, fontSize: 14)),
            ]),
          ],
        ),
      );
}

class _ProfileStat extends StatelessWidget {
  const _ProfileStat({required this.value, required this.label});
  final String value;
  final String label;
  @override
  Widget build(BuildContext context) => Column(children: <Widget>[
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 20)),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 11)),
      ]);
}

class _ProfileBadge extends StatelessWidget {
  const _ProfileBadge({required this.text, required this.colors, required this.textColor});
  final String text;
  final List<Color> colors;
  final Color textColor;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(9),
          gradient: LinearGradient(colors: colors),
        ),
        child: Text(text,
            style: TextStyle(color: textColor, fontSize: 10, fontWeight: FontWeight.w700)),
      );
}

class _ProfileTabHeaderDelegate extends SliverPersistentHeaderDelegate {
  _ProfileTabHeaderDelegate({
    required this.selected,
    required this.pagePosition,
    required this.onChanged,
  });
  final int selected;
  final double pagePosition;
  final ValueChanged<int> onChanged;
  @override
  double get minExtent => 48;
  @override
  double get maxExtent => 48;
  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) => Container(
        height: 48,
        color: const Color(0xCC2B245B),
        padding: const EdgeInsets.only(left: 18),
        alignment: Alignment.centerLeft,
        child: HomeBrushTabBar(
          labels: const <String>['Aktiv', 'Bilgi'],
          selected: selected,
          indicatorProgress: pagePosition,
          onChanged: onChanged,
        ),
      );
  @override
  bool shouldRebuild(covariant _ProfileTabHeaderDelegate oldDelegate) =>
      oldDelegate.selected != selected ||
      oldDelegate.pagePosition != pagePosition ||
      oldDelegate.onChanged != onChanged;
}

class _DynamicContent extends StatelessWidget {
  const _DynamicContent({required this.handle});
  final SliverOverlapAbsorberHandle handle;

  @override
  Widget build(BuildContext context) => _ProfilePagedContent(
        handle: handle,
        items: <_ProfileListItem>[
          _ProfileListItem(
              icon: Icons.emoji_emotions_outlined,
              title: 'Aktivitelerime hoş geldin',
              body: 'Henüz aktivite yok. İlk paylaşımını yapabilirsin.'),
          _ProfileListItem(
              icon: Icons.auto_awesome,
              title: 'Yeni başlayan görevi tamamlandı',
              body: '1 yeni başlangıç rozeti kazandın.'),
        ],
      );
}

class _ProfileContent extends StatelessWidget {
  const _ProfileContent({required this.handle});
  final SliverOverlapAbsorberHandle handle;

  @override
  Widget build(BuildContext context) => _ProfilePagedContent(
        handle: handle,
        title: 'Profil bilgileri',
        items: <_ProfileListItem>[
          _ProfileListItem(
              icon: Icons.location_on_outlined,
              title: 'Guangdong',
              body: 'Konum bilgisi henüz tamamlanmadı'),
        ],
      );
}

class _ProfilePagedContent extends StatefulWidget {
  const _ProfilePagedContent({required this.handle, this.title, required this.items});
  final SliverOverlapAbsorberHandle handle;
  final String? title;
  final List<_ProfileListItem> items;

  @override
  State<_ProfilePagedContent> createState() => _ProfilePagedContentState();
}

class _ProfilePagedContentState extends State<_ProfilePagedContent> {
  late final MockPagedData<_ProfileListItem> _pager;
  late List<_ProfileListItem> _items;
  bool _loadingMore = false;
  bool _noMore = false;

  @override
  void initState() {
    super.initState();
    _pager = MockPagedData<_ProfileListItem>(pageFactory: _fakeItems);
    _items = _pager.firstPage();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification notification) {
          if (notification.metrics.extentAfter < 220 && !_loadingMore && !_noMore) {
            _loadMore();
          }
          return false;
        },
        child: RefreshIndicator(
          color: const Color(0xFF20E0DE),
          onRefresh: _refresh,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: <Widget>[
              SliverOverlapInjector(
                handle: widget.handle,
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 100),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (_, int index) {
                      if (widget.title != null && index == 0) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 14),
                          child: Text(widget.title!,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
                        );
                      }
                      final int contentIndex = index - (widget.title == null ? 0 : 1);
                      if (contentIndex == _items.length) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 8, bottom: 22),
                          child: Center(
                            child: _loadingMore
                                ? const SizedBox(
                                    width: 22,
                                    height: 22,
                                    child: CircularProgressIndicator(strokeWidth: 2))
                                : const Text('Daha fazla veri yok',
                                    style: TextStyle(color: Colors.white38, fontSize: 12)),
                          ),
                        );
                      }
                      final _ProfileListItem item = _items[contentIndex];
                      return _ContentCard(icon: item.icon, title: item.title, body: item.body);
                    },
                    childCount: (widget.title == null ? 0 : 1) +
                        _items.length +
                        (_loadingMore || _noMore ? 1 : 0),
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  Future<void> _refresh() async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    if (!mounted) {
      return;
    }
    setState(() {
      _items = _pager.firstPage();
      _noMore = false;
    });
  }

  Future<void> _loadMore() async {
    if (!_pager.hasMore) {
      setState(() => _noMore = true);
      return;
    }
    setState(() => _loadingMore = true);
    await Future<void>.delayed(const Duration(milliseconds: 650));
    if (!mounted) {
      return;
    }
    setState(() {
      _items = <_ProfileListItem>[..._items, ..._pager.nextPage()];
      _loadingMore = false;
      _noMore = !_pager.hasMore;
    });
  }

  List<_ProfileListItem> _fakeItems(int offset, int limit) =>
      List<_ProfileListItem>.generate(limit, (int index) {
        final _ProfileListItem base = widget.items[(offset + index) % widget.items.length];
        final int number = offset + index;
        return _ProfileListItem(
          icon: base.icon,
          title: number < widget.items.length ? base.title : '${base.title} ${number + 1}',
          body: base.body,
        );
      });
}

class _ProfileListItem {
  const _ProfileListItem({required this.icon, required this.title, required this.body});
  final IconData icon;
  final String title;
  final String body;
}

class _ContentCard extends StatelessWidget {
  const _ContentCard({required this.icon, required this.title, required this.body});
  final IconData icon;
  final String title;
  final String body;
  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: Colors.white.withOpacity(.1), borderRadius: BorderRadius.circular(16)),
        child: Row(children: <Widget>[
          Icon(icon, color: const Color(0xFF19D7D8)),
          const SizedBox(width: 12),
          Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
            Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            Text(body, style: const TextStyle(color: Colors.white60, fontSize: 12)),
          ])),
        ]),
      );
}
