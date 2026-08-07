import 'package:flutter/material.dart';
import 'package:flutter_deer/social_home/data/user_assets.dart';
import 'package:flutter_deer/social_home/data/mock_paged_data.dart';
import 'package:flutter_deer/social_home/widgets/home_top_bar.dart';

/// Square page: parent tabs, child tabs, and brush indicator share Ana Sayfa's flow.
class SquarePage extends StatefulWidget {
  const SquarePage({super.key});

  @override
  State<SquarePage> createState() => _SquarePageState();
}

class _SquarePageState extends State<SquarePage> {
  int _pageIndex = 0;
  double _pagePosition = 0;
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController()..addListener(_handlePageScroll);
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

  void _changeParentTab(int value) {
    final int targetPage = value == 0 ? 0 : 2;
    _pageController.animateToPage(targetPage,
        duration: const Duration(milliseconds: 260), curve: Curves.easeOutCubic);
  }

  void _changeChildTab(int value) {
    final int parentPage = _pageIndex < 2 ? 0 : 2;
    _pageController.animateToPage(parentPage + value,
        duration: const Duration(milliseconds: 260), curve: Curves.easeOutCubic);
  }

  @override
  Widget build(BuildContext context) {
    final bool isGuild = _pageIndex >= 2;
    final List<String> childTabs =
        isGuild ? const <String>['Featured', 'Newest'] : const <String>['Recommended', 'Latest'];
    final int childIndex = _pageIndex.isEven ? 0 : 1;
    return Column(
      children: <Widget>[
        _SquareTopBar(
          selected: isGuild ? 1 : 0,
          indicatorProgress: (_pagePosition - 1).clamp(0.0, 1.0),
          onChanged: _changeParentTab,
        ),
        if (!isGuild) ...<Widget>[
          const SizedBox(height: 12),
          const _SquareRoomRecommendation(),
        ],
        _SquareCategoryBar(
          labels: childTabs,
          selected: childIndex,
          onChanged: _changeChildTab,
        ),
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            itemCount: 4,
            onPageChanged: (int value) => setState(() => _pageIndex = value),
            itemBuilder: (_, int index) {
              if (index < 2) {
                return _SquareFeedPage(latest: index == 1);
              }
              return _GuildListPage(newest: index == 3);
            },
          ),
        ),
      ],
    );
  }
}

class _SquareTopBar extends StatelessWidget {
  const _SquareTopBar(
      {required this.selected, required this.indicatorProgress, required this.onChanged});
  final int selected;
  final double indicatorProgress;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
        child: Row(
          children: <Widget>[
            HomeBrushTabBar(
              labels: const <String>['Square', 'Guild'],
              selected: selected,
              indicatorProgress: indicatorProgress,
              tabWidths: const <double>[70, 58],
              onChanged: onChanged,
            ),
            const Spacer(),
            DecoratedBox(
              decoration: BoxDecoration(
                color: const Color(0x99212A39),
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Padding(
                padding: EdgeInsets.all(8),
                child: Icon(Icons.notifications_none, color: Colors.white, size: 22),
              ),
            ),
          ],
        ),
      );
}

class _SquareCategoryBar extends StatelessWidget {
  const _SquareCategoryBar({required this.labels, required this.selected, required this.onChanged});
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

class _SquareFeedPage extends StatefulWidget {
  const _SquareFeedPage({required this.latest});
  final bool latest;

  static const List<_SquarePost> _posts = <_SquarePost>[
    _SquarePost(
      author: 'Onlyle',
      avatar: UserAssets.avatars[6],
      time: '8m ago',
      text: 'A good day starts with a little sunshine.',
      image: UserAssets.avatars[7],
      likes: '1',
    ),
    _SquarePost(
      author: 'Early Bird',
      avatar: UserAssets.avatars[8],
      time: '11m ago',
      text: 'Would you like the first milk tea of autumn?',
      image: UserAssets.avatars[9],
      likes: '38',
    ),
    _SquarePost(
      author: 'Deer Diary',
      avatar: UserAssets.avatars[2],
      time: '20m ago',
      text: 'Share a little happiness with someone you like.',
      image: UserAssets.avatars[3],
      likes: '26',
    ),
  ];

  @override
  State<_SquareFeedPage> createState() => _SquareFeedPageState();
}

class _SquareFeedPageState extends State<_SquareFeedPage> {
  final ScrollController _scrollController = ScrollController();
  late final MockPagedData<_SquarePost> _pager;
  late List<_SquarePost> _posts;
  bool _loadingMore = false;
  bool _noMore = false;

  @override
  void initState() {
    super.initState();
    _pager = MockPagedData<_SquarePost>(pageFactory: _fakePosts);
    _posts = _pager.firstPage();
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
        color: const Color(0xFF20E0DE),
        onRefresh: _refresh,
        child: ListView.builder(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 100),
          itemCount: _posts.length + (_loadingMore || _noMore ? 1 : 0),
          itemBuilder: (_, int index) {
            if (index == _posts.length) {
              return Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 24),
                child: Center(
                  child: _loadingMore
                      ? const SizedBox(
                          width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2))
                      : const Text('Daha fazla veri yok',
                          style: TextStyle(color: Colors.white38, fontSize: 12)),
                ),
              );
            }
            return _PostCard(post: _posts[index], latest: widget.latest);
          },
        ),
      );

  void _onScroll() {
    if (_scrollController.position.extentAfter < 220 && !_loadingMore && !_noMore) {
      _loadMore();
    }
  }

  Future<void> _refresh() async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    if (!mounted) {
      return;
    }
    setState(() {
      _posts = _pager.firstPage();
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
      _posts = <_SquarePost>[..._posts, ..._pager.nextPage()];
      _loadingMore = false;
      _noMore = !_pager.hasMore;
    });
  }

  List<_SquarePost> _fakePosts(int offset, int limit) =>
      List<_SquarePost>.generate(limit, (int index) {
        final _SquarePost base =
            _SquareFeedPage._posts[(offset + index) % _SquareFeedPage._posts.length];
        final int number = offset + index;
        return _SquarePost(
          author:
              number < _SquareFeedPage._posts.length ? base.author : '${base.author} ${number + 1}',
          avatar: base.avatar,
          time: number == 0 ? base.time : '${number + 1}m ago',
          text: base.text,
          image: base.image,
          likes: '${int.parse(base.likes) + number}',
        );
      });
}

/// The live-room recommendation strip belongs to the Square shell rather than
/// either feed page, so it remains fixed while Recommended and Latest switch.
class _SquareRoomRecommendation extends StatelessWidget {
  const _SquareRoomRecommendation();

  static const List<_SquareRoom> _rooms = <_SquareRoom>[
    _SquareRoom('Love & Care', UserAssets.avatars[0], 'Together', '128'),
    _SquareRoom('In Your Eyes', UserAssets.avatars[1], 'VVV Host', '96'),
    _SquareRoom('Sweet Party', UserAssets.avatars[4], 'Summer Event', '76'),
  ];

  @override
  Widget build(BuildContext context) => SizedBox(
        height: 92,
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          scrollDirection: Axis.horizontal,
          itemCount: _rooms.length,
          separatorBuilder: (_, __) => const SizedBox(width: 8),
          itemBuilder: (_, int index) => _SquareRoomCard(room: _rooms[index]),
        ),
      );
}

class _SquareRoomCard extends StatelessWidget {
  const _SquareRoomCard({required this.room});
  final _SquareRoom room;

  @override
  Widget build(BuildContext context) => ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: SizedBox(
          width: 158,
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Image.asset(room.image, fit: BoxFit.cover),
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: <Color>[Colors.transparent, Colors.black.withOpacity(.78)],
                  ),
                ),
              ),
              Positioned(
                left: 8,
                right: 8,
                bottom: 6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(room.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 2),
                    Text('◉  ${room.subtitle}  ·  ${room.online}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.white70, fontSize: 9)),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
}

class _PostCard extends StatelessWidget {
  const _PostCard({required this.post, required this.latest});
  final _SquarePost post;
  final bool latest;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                CircleAvatar(radius: 22, backgroundImage: AssetImage(post.avatar)),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(post.author,
                        style: const TextStyle(
                            color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 3),
                    Text(latest ? 'Latest · ${post.time}' : post.time,
                        style: const TextStyle(color: Colors.white38, fontSize: 11)),
                  ],
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(62, 10, 0, 12),
              child: Text(post.text, style: const TextStyle(color: Colors.white70, fontSize: 13)),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 62),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Image.asset(post.image, width: 202, height: 202, fit: BoxFit.cover),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(62, 12, 0, 0),
              child: Row(
                children: <Widget>[
                  const Icon(Icons.favorite_border, color: Color(0xFF65708A), size: 24),
                  const SizedBox(width: 7),
                  Text(post.likes, style: const TextStyle(color: Color(0xFF65708A), fontSize: 12)),
                  const SizedBox(width: 42),
                  const Icon(Icons.chat_bubble_outline, color: Color(0xFF65708A), size: 21),
                  const Spacer(),
                  const Icon(Icons.waving_hand, color: Color(0xFF7EE7E5), size: 25),
                ],
              ),
            ),
          ],
        ),
      );
}

class _GuildListPage extends StatefulWidget {
  const _GuildListPage({required this.newest});
  final bool newest;

  static const List<_Guild> _guilds = <_Guild>[
    _Guild('Aurora Club', 'Music, friends and late-night talks', '12.8K', Icons.auto_awesome),
    _Guild('Sunset House', 'A warm place for new friends', '8.6K', Icons.wb_sunny_outlined),
    _Guild('Ocean Voice', 'Singing, games and good vibes', '6.4K', Icons.water_drop_outlined),
    _Guild('Dream Garden', 'Share stories and daily moments', '5.2K', Icons.local_florist_outlined),
    _Guild('Star Lounge', 'Find your people and stay awhile', '3.9K', Icons.star_border),
    _Guild('Moonlight', 'Quiet conversations after dark', '2.7K', Icons.nightlight_outlined),
  ];

  @override
  State<_GuildListPage> createState() => _GuildListPageState();
}

class _GuildListPageState extends State<_GuildListPage> {
  final ScrollController _scrollController = ScrollController();
  late final MockPagedData<_Guild> _pager;
  late List<_Guild> _guilds;
  bool _loadingMore = false;
  bool _noMore = false;

  @override
  void initState() {
    super.initState();
    _pager = MockPagedData<_Guild>(pageFactory: _fakeGuilds);
    _guilds = _pager.firstPage();
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
        color: const Color(0xFF20E0DE),
        onRefresh: _refresh,
        child: ListView.separated(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 100),
          itemCount: _guilds.length + (_loadingMore || _noMore ? 1 : 0),
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (_, int index) {
            if (index == _guilds.length) {
              return Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 22),
                child: Center(
                  child: _loadingMore
                      ? const SizedBox(
                          width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2))
                      : const Text('Daha fazla veri yok',
                          style: TextStyle(color: Colors.white38, fontSize: 12)),
                ),
              );
            }
            return _GuildCard(guild: _guilds[index]);
          },
        ),
      );

  void _onScroll() {
    if (_scrollController.position.extentAfter < 220 && !_loadingMore && !_noMore) {
      _loadMore();
    }
  }

  Future<void> _refresh() async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    if (!mounted) {
      return;
    }
    setState(() {
      _guilds = _pager.firstPage();
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
      _guilds = <_Guild>[..._guilds, ..._pager.nextPage()];
      _loadingMore = false;
      _noMore = !_pager.hasMore;
    });
  }

  List<_Guild> _fakeGuilds(int offset, int limit) => List<_Guild>.generate(limit, (int index) {
        final int sourceIndex = (offset + index) % _GuildListPage._guilds.length;
        final _Guild base = widget.newest
            ? _GuildListPage._guilds.reversed.toList()[sourceIndex]
            : _GuildListPage._guilds[sourceIndex];
        final int number = offset + index;
        return _Guild(
          number < _GuildListPage._guilds.length ? base.name : '${base.name} ${number + 1}',
          base.description,
          base.members,
          base.icon,
        );
      });
}

class _GuildCard extends StatelessWidget {
  const _GuildCard({required this.guild});
  final _Guild guild;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0x66242A52),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(.10)),
        ),
        child: Row(
          children: <Widget>[
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient:
                    const LinearGradient(colors: <Color>[Color(0xFF64E6E1), Color(0xFF7B68EE)]),
                boxShadow: <BoxShadow>[
                  BoxShadow(color: const Color(0xFF62E2E1).withOpacity(.25), blurRadius: 12)
                ],
              ),
              child: Icon(guild.icon, color: Colors.white, size: 28),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(guild.name,
                      style: const TextStyle(
                          color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 5),
                  Text(guild.description,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.white60, fontSize: 11)),
                  const SizedBox(height: 5),
                  Text('${guild.members} members',
                      style: const TextStyle(color: Color(0xFF8FE8E5), fontSize: 11)),
                ],
              ),
            ),
            const SizedBox(width: 8),
            OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF8FE8E5),
                side: const BorderSide(color: Color(0xFF57D5D2)),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                minimumSize: const Size(0, 32),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
              ),
              child: const Text('Join', style: TextStyle(fontSize: 12)),
            ),
          ],
        ),
      );
}

class _SquareRoom {
  const _SquareRoom(this.title, this.image, this.subtitle, this.online);
  final String title;
  final String image;
  final String subtitle;
  final String online;
}

class _SquarePost {
  const _SquarePost(
      {required this.author,
      required this.avatar,
      required this.time,
      required this.text,
      required this.image,
      required this.likes});
  final String author;
  final String avatar;
  final String time;
  final String text;
  final String image;
  final String likes;
}

class _Guild {
  const _Guild(this.name, this.description, this.members, this.icon);
  final String name;
  final String description;
  final String members;
  final IconData icon;
}
