import 'package:flutter/material.dart';

/// 首页“聊天”入口的消息与好友内容。
///
/// 当前先使用本地假数据，后续接入接口时只需替换列表数据即可。
class MessageTabPage extends StatefulWidget {
  const MessageTabPage({super.key});

  @override
  State<MessageTabPage> createState() => _MessageTabPageState();
}

class _MessageTabPageState extends State<MessageTabPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Column(
        children: <Widget>[
          _MessageHeader(controller: _tabController),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const <Widget>[_ChatContent(), _FriendContent()],
            ),
          ),
        ],
      );
}

class _MessageHeader extends StatelessWidget {
  const _MessageHeader({required this.controller});
  final TabController controller;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 10),
        child: Row(
          children: <Widget>[
            Expanded(
              child: TabBar(
                controller: controller,
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                tabs: const <Widget>[Tab(text: '聊天'), Tab(text: '好友')],
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white60,
                labelStyle: const TextStyle(fontSize: 21, fontWeight: FontWeight.w600),
                unselectedLabelStyle: const TextStyle(fontSize: 17),
                indicator: const _MessageIndicator(),
                indicatorSize: TabBarIndicatorSize.label,
                dividerColor: Colors.transparent,
                labelPadding: const EdgeInsets.only(right: 26),
              ),
            ),
            _HeaderAction(icon: Icons.card_giftcard_outlined, onTap: () {}),
            const SizedBox(width: 10),
            _HeaderAction(icon: Icons.person_add_alt_1_outlined, onTap: () {}),
          ],
        ),
      );
}

class _HeaderAction extends StatelessWidget {
  const _HeaderAction({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Material(
        color: Colors.white.withOpacity(.10),
        shape: const CircleBorder(),
        child: InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          child: Padding(
            padding: const EdgeInsets.all(11),
            child: Icon(icon, color: Colors.white70, size: 21),
          ),
        ),
      );
}

class _MessageIndicator extends Decoration {
  const _MessageIndicator();

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) => _MessageIndicatorPainter();
}

class _MessageIndicatorPainter extends BoxPainter {
  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final Size size = configuration.size ?? Size.zero;
    final Paint paint = Paint()
      ..color = const Color(0xFF20E0DE)
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    final Path path = Path()
      ..moveTo(offset.dx + 3, offset.dy + size.height - 6)
      ..quadraticBezierTo(offset.dx + size.width * .35, offset.dy + size.height - 14,
          offset.dx + size.width * .62, offset.dy + size.height - 7)
      ..quadraticBezierTo(offset.dx + size.width * .82, offset.dy + size.height,
          offset.dx + size.width - 3, offset.dy + size.height - 8);
    canvas.drawPath(path, paint);
  }
}

class _ChatContent extends StatelessWidget {
  const _ChatContent();

  @override
  Widget build(BuildContext context) => ListView(
        padding: const EdgeInsets.fromLTRB(8, 0, 8, 110),
        children: const <Widget>[
          _PermissionNotice(),
          _ProfileBanner(),
          _EventBanner(),
          _MessageItem(
            icon: Icons.notifications_none_rounded,
            iconColor: Color(0xFF81F7FF),
            title: '系统消息',
            time: '3天前',
            preview: '恭喜哟。。。晋升上神贵族，成功炼化5颗彩...',
          ),
          _MessageItem(
            icon: Icons.star_border_rounded,
            iconColor: Color(0xFFFFE3A2),
            title: '活动信息',
            time: '07-31',
            preview: '🎁礼物乐园钻兑换重新升级 ⏰7.31-8.3 每...',
          ),
          _MessageItem(
            icon: Icons.smart_toy_outlined,
            iconColor: Color(0xFFB9E9FF),
            title: '小天使AI',
            time: '07-28',
            preview: '宝！你居然找到我了，那我就给你留了彩蛋...',
          ),
        ],
      );
}

class _PermissionNotice extends StatelessWidget {
  const _PermissionNotice();

  @override
  Widget build(BuildContext context) => Container(
        height: 46,
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 28),
        color: const Color(0xCC171A3D),
        child: Row(
          children: const <Widget>[
            Icon(Icons.notifications_none, color: Color(0xFFAF9BFF), size: 21),
            SizedBox(width: 12),
            Expanded(
              child: Text('开启通知权限，才不会错过重要消息推送哦',
                  style: TextStyle(color: Colors.white70, fontSize: 12)),
            ),
            Text('前往开启', style: TextStyle(color: Color(0xFF25E0E0), fontSize: 12)),
          ],
        ),
      );
}

class _ProfileBanner extends StatelessWidget {
  const _ProfileBanner();

  @override
  Widget build(BuildContext context) => Container(
        height: 74,
        margin: const EdgeInsets.fromLTRB(8, 0, 8, 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: const LinearGradient(
            colors: <Color>[Color(0xFF272752), Color(0xFF182443)],
          ),
        ),
        child: Row(
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Icon(Icons.favorite, color: Color(0xFFFF73AE), size: 38),
            ),
            const Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('还没心动?', style: TextStyle(color: Color(0xFFBFE7FF), fontSize: 17, fontWeight: FontWeight.w700)),
                  SizedBox(height: 5),
                  Text('完善资料瞬间提高回复率哦~', style: TextStyle(color: Colors.white70, fontSize: 11)),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
              decoration: BoxDecoration(color: const Color(0xFF3EE5E4), borderRadius: BorderRadius.circular(18)),
              child: const Text('去完善', style: TextStyle(color: Color(0xFF183A49), fontSize: 12, fontWeight: FontWeight.w700)),
            ),
          ],
        ),
      );
}

class _EventBanner extends StatelessWidget {
  const _EventBanner();

  @override
  Widget build(BuildContext context) => Container(
        height: 88,
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 18),
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: <Color>[Color(0xFF13264C), Color(0xFF242048)]),
          border: Border.all(color: const Color(0xFF38477D)),
        ),
        child: Row(children: const <Widget>[
          Icon(Icons.auto_awesome, color: Color(0xFF78D7FF), size: 36),
          SizedBox(width: 14),
          Text('我的宝藏纪', style: TextStyle(color: Color(0xFFA0EAF1), fontSize: 20, fontWeight: FontWeight.w600)),
          Spacer(),
          Icon(Icons.stars_rounded, color: Color(0xFF8D80B8), size: 42),
        ]),
      );
}

class _MessageItem extends StatelessWidget {
  const _MessageItem({required this.icon, required this.iconColor, required this.title, required this.time, required this.preview});
  final IconData icon;
  final Color iconColor;
  final String title;
  final String time;
  final String preview;

  @override
  Widget build(BuildContext context) => SizedBox(
        height: 99,
        child: Row(children: <Widget>[
          Container(
            width: 60,
            height: 60,
            margin: const EdgeInsets.only(left: 14, right: 16),
            decoration: BoxDecoration(shape: BoxShape.circle, color: iconColor.withOpacity(.15)),
            child: Icon(icon, color: iconColor, size: 34),
          ),
          Expanded(
            child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
              Row(children: <Widget>[
                Expanded(child: Text(title, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600))),
                Text(time, style: const TextStyle(color: Colors.white38, fontSize: 11)),
              ]),
              const SizedBox(height: 9),
              Text(preview, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white70, fontSize: 12)),
            ]),
          ),
          Container(width: 9, height: 9, margin: const EdgeInsets.only(left: 12, right: 14), decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFFFF2A5C))),
        ]),
      );
}

class _FriendContent extends StatelessWidget {
  const _FriendContent();

  static const List<String> _names = <String>[
    '星河入梦', '小鹿乱撞', '奶糖不甜', '云朵收藏家', '晚风轻轻', '桃气少女', '海盐汽水',
    '月亮邮差', '橘子汽水', '南风知我意', '一颗小太阳', '椰奶冻', '银河漫游', '甜心兔兔',
    '春日限定', '晚安小鱼', '薄荷微凉', '七分甜', '山野有雾', '晴天娃娃',
  ];
  static const List<String> _avatars = <String>[
    'room_woman_44.jpg', 'room_woman_47.jpg', 'room_woman_49.jpg', 'room_woman_65.jpg',
    'room_woman_68.jpg', 'room_woman_75.jpg',
  ];

  @override
  Widget build(BuildContext context) => ListView.separated(
        padding: const EdgeInsets.fromLTRB(14, 0, 14, 110),
        itemCount: _names.length,
        separatorBuilder: (_, __) => Divider(height: 1, color: Colors.white.withOpacity(.06)),
        itemBuilder: (_, int index) => _FriendItem(
          name: _names[index],
          avatar: _avatars[index % _avatars.length],
          isMale: index.isEven,
        ),
      );
}

class _FriendItem extends StatelessWidget {
  const _FriendItem({required this.name, required this.avatar, required this.isMale});
  final String name;
  final String avatar;
  final bool isMale;

  @override
  Widget build(BuildContext context) => SizedBox(
        height: 72,
        child: Row(children: <Widget>[
          ClipOval(child: Image.asset('assets/images/social_home/$avatar', width: 48, height: 48, fit: BoxFit.cover)),
          const SizedBox(width: 14),
          Expanded(child: Text(name, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500))),
          Icon(isMale ? Icons.male : Icons.female, color: isMale ? const Color(0xFF59BFFF) : const Color(0xFFFF83B6), size: 17),
          const SizedBox(width: 8),
        ]),
      );
}
