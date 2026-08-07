import 'package:flutter/material.dart';

/// 广场页：顶部频道、房间横滑推荐、帖子频道和帖子流。
class SquarePage extends StatefulWidget {
  const SquarePage({super.key});

  @override
  State<SquarePage> createState() => _SquarePageState();
}

class _SquarePageState extends State<SquarePage> {
  int _topTab = 0;
  int _postTab = 0;

  static const List<_SquareRoom> _rooms = <_SquareRoom>[
    _SquareRoom('恋与守护', 'assets/images/social_home/room_woman_44.jpg', '纪念相守', '128'),
    _SquareRoom('你眼中的我', 'assets/images/social_home/room_woman_47.jpg', 'VVV福利官', '96'),
    _SquareRoom('甜蜜派对', 'assets/images/social_home/room_woman_49.jpg', '夏日活动', '76'),
  ];

  static const List<_SquarePost> _posts = <_SquarePost>[
    _SquarePost(
      author: '只唯le',
      avatar: 'assets/images/social_home/room_woman_65.jpg',
      time: '8分钟前',
      text: 'd',
      image: 'assets/images/social_home/room_woman_68.jpg',
      likes: '1',
    ),
    _SquarePost(
      author: '早点睡觉',
      avatar: 'assets/images/social_home/room_woman_75.jpg',
      time: '11分钟前',
      text: '秋天的第一杯奶茶喝吗？一起好吧。',
      image: 'assets/images/social_home/room_woman_44.jpg',
      likes: '38',
    ),
    _SquarePost(
      author: '小鹿日记',
      avatar: 'assets/images/social_home/room_woman_49.jpg',
      time: '20分钟前',
      text: '今天也要和喜欢的人分享好心情。',
      image: 'assets/images/social_home/room_woman_47.jpg',
      likes: '26',
    ),
  ];

  @override
  Widget build(BuildContext context) => Column(
        children: <Widget>[
          _SquareTopBar(
            selected: _topTab,
            onChanged: (int value) => setState(() => _topTab = value),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 92,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              scrollDirection: Axis.horizontal,
              itemCount: _rooms.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, int index) => _SquareRoomCard(room: _rooms[index]),
            ),
          ),
          const SizedBox(height: 14),
          _PostTabs(
            selected: _postTab,
            onChanged: (int value) => setState(() => _postTab = value),
          ),
          const SizedBox(height: 4),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
              itemCount: _posts.length,
              itemBuilder: (_, int index) => _PostCard(post: _posts[index]),
            ),
          ),
        ],
      );
}

class _SquareTopBar extends StatelessWidget {
  const _SquareTopBar({required this.selected, required this.onChanged});
  final int selected;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
        child: Row(
          children: <Widget>[
            _SquareTab(label: '广场', selected: selected == 0, onTap: () => onChanged(0)),
            const SizedBox(width: 26),
            _SquareTab(label: '公会', selected: selected == 1, onTap: () => onChanged(1)),
            const Spacer(),
            Stack(
              clipBehavior: Clip.none,
              children: <Widget>[
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
                Positioned(
                  right: 2,
                  top: 1,
                  child: Container(
                    width: 7,
                    height: 7,
                    decoration: const BoxDecoration(color: Color(0xFFFF4B68), shape: BoxShape.circle),
                  ),
                ),
              ],
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
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Text(label,
              style: TextStyle(
                  color: selected ? Colors.white : Colors.white70,
                  fontSize: selected ? 20 : 17,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w400)),
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
                        style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
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

class _PostTabs extends StatelessWidget {
  const _PostTabs({required this.selected, required this.onChanged});
  final int selected;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) => Row(
        children: <Widget>[
          const SizedBox(width: 20),
          _PostTab(label: '推荐', selected: selected == 0, onTap: () => onChanged(0)),
          const SizedBox(width: 30),
          _PostTab(label: '最新', selected: selected == 1, onTap: () => onChanged(1)),
        ],
      );
}

class _PostTab extends StatelessWidget {
  const _PostTab({required this.label, required this.selected, required this.onTap});
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Text(label,
            style: TextStyle(
                color: selected ? Colors.white : Colors.white60,
                fontSize: 16,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w400)),
      );
}

class _PostCard extends StatelessWidget {
  const _PostCard({required this.post});
  final _SquarePost post;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 14, bottom: 16),
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
                        style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 3),
                    Text(post.time, style: const TextStyle(color: Colors.white38, fontSize: 11)),
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

class _SquareRoom {
  const _SquareRoom(this.title, this.image, this.subtitle, this.online);
  final String title;
  final String image;
  final String subtitle;
  final String online;
}

class _SquarePost {
  const _SquarePost({required this.author, required this.avatar, required this.time, required this.text, required this.image, required this.likes});
  final String author;
  final String avatar;
  final String time;
  final String text;
  final String image;
  final String likes;
}
