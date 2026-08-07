import 'package:flutter/material.dart';
import 'package:flutter_deer/social_home/widgets/home_top_bar.dart';

/// 首页“聊天”入口的消息与好友内容。
///
/// 当前先使用本地假数据，后续接入接口时只需替换列表数据即可。
class MessageTabPage extends StatefulWidget {
  const MessageTabPage({super.key});

  @override
  State<MessageTabPage> createState() => _MessageTabPageState();
}

class _MessageTabPageState extends State<MessageTabPage> with SingleTickerProviderStateMixin {
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
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: Row(
          children: <Widget>[
            AnimatedBuilder(
              animation: controller.animation!,
              builder: (BuildContext context, Widget? child) {
                final double page = controller.animation?.value ?? controller.index.toDouble();
                final int selected = page.round().clamp(0, 1);
                return HomeBrushTabBar(
                  labels: const <String>['聊天', '好友'],
                  selected: selected,
                  indicatorProgress: page.clamp(0.0, 1.0),
                  onChanged: controller.animateTo,
                );
              },
            ),
            const Spacer(),
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

class _ChatContent extends StatefulWidget {
  const _ChatContent();

  @override
  State<_ChatContent> createState() => _ChatContentState();
}

class _ChatContentState extends State<_ChatContent> {
  static const int _pageSize = 3;
  final ScrollController _scrollController = ScrollController();
  late List<_ChatMessageData> _messages;
  bool _loadingMore = false;
  int _page = 1;

  @override
  void initState() {
    super.initState();
    _messages = _fakeMessages(0, _pageSize);
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
          padding: const EdgeInsets.fromLTRB(8, 0, 8, 110),
          itemCount: 1 + _messages.length + (_loadingMore ? 1 : 0),
          itemBuilder: (BuildContext context, int index) {
            if (index == 0) {
              return const _ProfileBanner();
            }
            if (index == _messages.length + 1) {
              return const Padding(
                padding: EdgeInsets.only(top: 8, bottom: 22),
                child: Center(
                    child: SizedBox(
                        width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2))),
              );
            }
            return _MessageItem(data: _messages[index - 1]);
          },
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
      _messages = _fakeMessages(0, _pageSize);
    });
  }

  Future<void> _loadMore() async {
    setState(() => _loadingMore = true);
    await Future<void>.delayed(const Duration(milliseconds: 650));
    if (!mounted) {
      return;
    }
    setState(() {
      _messages = <_ChatMessageData>[..._messages, ..._fakeMessages(_page * _pageSize, _pageSize)];
      _page++;
      _loadingMore = false;
    });
  }

  List<_ChatMessageData> _fakeMessages(int start, int count) {
    const List<String> titles = <String>['系统消息', '活动信息', '小天使AI', '好友动态', '官方提醒'];
    const List<String> previews = <String>[
      '恭喜哟。。。晋升上神贵族，成功炼化5颗彩...',
      '🎁礼物乐园钻兑换重新升级 ⏰7.31-8.3 每...',
      '宝！你居然找到我了，那我就给你留了彩蛋...',
      '你关注的好友发布了新的动态，快去看看吧...',
      '新的活动已经开启，参与活动可以领取奖励哦...',
    ];
    const List<IconData> icons = <IconData>[
      Icons.notifications_none_rounded,
      Icons.star_border_rounded,
      Icons.smart_toy_outlined,
      Icons.favorite_border_rounded,
      Icons.campaign_outlined,
    ];
    const List<Color> colors = <Color>[
      Color(0xFF81F7FF),
      Color(0xFFFFE3A2),
      Color(0xFFB9E9FF),
      Color(0xFFFF9DC4),
      Color(0xFFFFD47C),
    ];
    return List<_ChatMessageData>.generate(count, (int index) {
      final int dataIndex = (start + index) % titles.length;
      return _ChatMessageData(
        icon: icons[dataIndex],
        iconColor: colors[dataIndex],
        title: dataIndex == 0
            ? titles[dataIndex]
            : '${titles[dataIndex]} ${start + index ~/ titles.length + 1}',
        time: dataIndex < 3 ? <String>['3天前', '07-31', '07-28'][dataIndex] : '刚刚',
        preview: previews[dataIndex],
      );
    });
  }
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
                  Text('还没心动?',
                      style: TextStyle(
                          color: Color(0xFFBFE7FF), fontSize: 17, fontWeight: FontWeight.w700)),
                  SizedBox(height: 5),
                  Text('完善资料瞬间提高回复率哦~', style: TextStyle(color: Colors.white70, fontSize: 11)),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
              decoration: BoxDecoration(
                  color: const Color(0xFF3EE5E4), borderRadius: BorderRadius.circular(18)),
              child: const Text('去完善',
                  style: TextStyle(
                      color: Color(0xFF183A49), fontSize: 12, fontWeight: FontWeight.w700)),
            ),
          ],
        ),
      );
}

class _MessageItem extends StatelessWidget {
  const _MessageItem({required this.data});
  final _ChatMessageData data;

  @override
  Widget build(BuildContext context) => SizedBox(
        height: 99,
        child: Row(children: <Widget>[
          Container(
            width: 60,
            height: 60,
            margin: const EdgeInsets.only(left: 14, right: 16),
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: data.iconColor.withOpacity(.15)),
            child: Icon(data.icon, color: data.iconColor, size: 34),
          ),
          Expanded(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(children: <Widget>[
                    Expanded(
                        child: Text(data.title,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600))),
                    Text(data.time, style: const TextStyle(color: Colors.white38, fontSize: 11)),
                  ]),
                  const SizedBox(height: 9),
                  Text(data.preview,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.white70, fontSize: 12)),
                ]),
          ),
          Container(
              width: 9,
              height: 9,
              margin: const EdgeInsets.only(left: 12, right: 14),
              decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFFFF2A5C))),
        ]),
      );
}

class _ChatMessageData {
  const _ChatMessageData({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.time,
    required this.preview,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String time;
  final String preview;
}

class _FriendContent extends StatelessWidget {
  const _FriendContent();

  static const List<String> _names = <String>[
    '星河入梦',
    '小鹿乱撞',
    '奶糖不甜',
    '云朵收藏家',
    '晚风轻轻',
    '桃气少女',
    '海盐汽水',
    '月亮邮差',
    '橘子汽水',
    '南风知我意',
    '一颗小太阳',
    '椰奶冻',
    '银河漫游',
    '甜心兔兔',
    '春日限定',
    '晚安小鱼',
    '薄荷微凉',
    '七分甜',
    '山野有雾',
    '晴天娃娃',
  ];
  static const List<String> _avatars = <String>[
    'room_woman_44.jpg',
    'room_woman_47.jpg',
    'room_woman_49.jpg',
    'room_woman_65.jpg',
    'room_woman_68.jpg',
    'room_woman_75.jpg',
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
          ClipOval(
              child: Image.asset('assets/images/social_home/$avatar',
                  width: 48, height: 48, fit: BoxFit.cover)),
          const SizedBox(width: 14),
          Expanded(
              child: Text(name,
                  style: const TextStyle(
                      color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500))),
          Icon(isMale ? Icons.male : Icons.female,
              color: isMale ? const Color(0xFF59BFFF) : const Color(0xFFFF83B6), size: 17),
          const SizedBox(width: 8),
        ]),
      );
}
