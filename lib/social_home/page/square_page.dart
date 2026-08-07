import 'package:flutter/material.dart';

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
    final List<String> childTabs = isGuild
        ? const <String>['Featured', 'Newest']
        : const <String>['Recommended', 'Latest'];
    final int childIndex = _pageIndex.isEven ? 0 : 1;
    return Column(
      children: <Widget>[
        _SquareTopBar(
          selected: isGuild ? 1 : 0,
          indicatorProgress: ((_pagePosition - 1).clamp(0.0, 1.0)) as double,
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
            SizedBox(
              width: 150,
              height: 38,
              child: Stack(
                clipBehavior: Clip.none,
                children: <Widget>[
                  Positioned(
                    left: 14 + (indicatorProgress * 87),
                    bottom: 8,
                    width: 27,
                    height: 8,
                    child: const IgnorePointer(
                      child: CustomPaint(painter: _SquareTabIndicatorPainter()),
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      SizedBox(
                          width: 70,
                          child: _SquareTab(
                              label: 'Square', selected: selected == 0, onTap: () => onChanged(0))),
                      const SizedBox(width: 22),
                      SizedBox(
                          width: 58,
                          child: _SquareTab(
                              label: 'Guild', selected: selected == 1, onTap: () => onChanged(1))),
                    ],
                  ),
                ],
              ),
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

class _SquareTab extends StatelessWidget {
  const _SquareTab({required this.label, required this.selected, required this.onTap});
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Center(
          child: Text(label,
              style: TextStyle(
                  color: selected ? Colors.white : Colors.white60,
                  fontSize: 20,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w400)),
        ),
      );
}

class _SquareTabIndicatorPainter extends CustomPainter {
  const _SquareTabIndicatorPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..shader = const LinearGradient(
        colors: <Color>[Color(0xFFFFD54F), Color(0xFFFF7A00)],
      ).createShader(Offset.zero & size)
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 3.5
      ..style = PaintingStyle.stroke;
    final Path path = Path()
      ..moveTo(3, size.height * .62)
      ..quadraticBezierTo(size.width * .28, size.height * .15,
          size.width * .55, size.height * .52)
      ..quadraticBezierTo(size.width * .78, size.height * .82, size.width - 2, size.height * .48);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _SquareTabIndicatorPainter oldDelegate) => false;
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

class _SquareFeedPage extends StatelessWidget {
  const _SquareFeedPage({required this.latest});
  final bool latest;

  static const List<_SquarePost> _posts = <_SquarePost>[
    _SquarePost(
      author: 'Onlyle',
      avatar: 'assets/images/social_home/room_woman_65.jpg',
      time: '8m ago',
      text: 'A good day starts with a little sunshine.',
      image: 'assets/images/social_home/room_woman_68.jpg',
      likes: '1',
    ),
    _SquarePost(
      author: 'Early Bird',
      avatar: 'assets/images/social_home/room_woman_75.jpg',
      time: '11m ago',
      text: 'Would you like the first milk tea of autumn?',
      image: 'assets/images/social_home/room_woman_44.jpg',
      likes: '38',
    ),
    _SquarePost(
      author: 'Deer Diary',
      avatar: 'assets/images/social_home/room_woman_49.jpg',
      time: '20m ago',
      text: 'Share a little happiness with someone you like.',
      image: 'assets/images/social_home/room_woman_47.jpg',
      likes: '26',
    ),
  ];

  @override
  Widget build(BuildContext context) => ListView(
        padding: const EdgeInsets.only(bottom: 100),
        children: <Widget>[
          ...(_posts.reversed.toList()).map((post) => _PostCard(post: post, latest: latest)),
        ],
      );
}

/// The live-room recommendation strip belongs to the Square shell rather than
/// either feed page, so it remains fixed while Recommended and Latest switch.
class _SquareRoomRecommendation extends StatelessWidget {
  const _SquareRoomRecommendation();

  static const List<_SquareRoom> _rooms = <_SquareRoom>[
    _SquareRoom('Love & Care', 'assets/images/social_home/room_woman_44.jpg', 'Together', '128'),
    _SquareRoom('In Your Eyes', 'assets/images/social_home/room_woman_47.jpg', 'VVV Host', '96'),
    _SquareRoom('Sweet Party', 'assets/images/social_home/room_woman_49.jpg', 'Summer Event', '76'),
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

class _GuildListPage extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final List<_Guild> guilds = newest ? _guilds.reversed.toList() : _guilds;
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 100),
      itemCount: guilds.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (_, int index) => _GuildCard(guild: guilds[index]),
    );
  }
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
                gradient: const LinearGradient(
                    colors: <Color>[Color(0xFF64E6E1), Color(0xFF7B68EE)]),
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
