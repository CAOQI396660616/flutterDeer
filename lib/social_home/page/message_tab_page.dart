import 'package:flutter/material.dart';
import 'package:flutter_deer/social_home/data/mock_paged_data.dart';
import 'package:flutter_deer/social_home/data/user_assets.dart';
import 'package:flutter_deer/social_home/widgets/home_top_bar.dart';

/// Mesaj ve arkadaş içeriği.
///
/// Şimdilik yerel sahte veri kullanılır.
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
        padding: const EdgeInsets.fromLTRB(20, 0, 16, 20),
        child: Row(
          children: <Widget>[
            AnimatedBuilder(
              animation: controller.animation!,
              builder: (BuildContext context, Widget? child) {
                final double page = controller.animation?.value ?? controller.index.toDouble();
                final int selected = page.round().clamp(0, 1);
                return HomeBrushTabBar(
                  labels: const <String>['Sohbet', 'Arkadaşlar'],
                  selected: selected,
                  indicatorProgress: page.clamp(0.0, 1.0),
                  tabWidths: const <double>[75, 110],
                  onChanged: controller.animateTo,
                );
              },
            ),
            const Spacer(),
            HomeActionButton(icon: Icons.card_giftcard_outlined, label: 'Hediyeler', onTap: () {}),
            const SizedBox(width: 0),
            HomeActionButton(
                icon: Icons.person_add_alt_1_outlined, label: 'Arkadaş ekle', onTap: () {}),
          ],
        ),
      );
}

class _ChatContent extends StatefulWidget {
  const _ChatContent();

  @override
  State<_ChatContent> createState() => _ChatContentState();
}

class _ChatContentState extends State<_ChatContent> {
  static const List<_ChatMessageData> _fixedMessages = <_ChatMessageData>[
    _ChatMessageData(
      icon: Icons.notifications_none_rounded,
      iconColor: Color(0xFF81F7FF),
      title: 'Sistem Mesajı',
      time: '3 gün önce',
      preview: 'Tebrikler! Yeni VIP seviyen hayırlı olsun...',
    ),
    _ChatMessageData(
      icon: Icons.star_border_rounded,
      iconColor: Color(0xFFFFE3A2),
      title: 'Etkinlikler',
      time: '07-31',
      preview: '🎁 Hediye bahçesi yenilendi ⏰ 31.07-03.08...',
    ),
    _ChatMessageData(
      icon: Icons.smart_toy_outlined,
      iconColor: Color(0xFFB9E9FF),
      title: 'Küçük Melek AI',
      time: '07-28',
      preview: 'Beni buldun! Sana özel bir sürpriz bıraktım...',
    ),
  ];

  final ScrollController _scrollController = ScrollController();
  late final MockPagedData<_ChatMessageData> _pager;
  late List<_ChatMessageData> _messages;
  bool _loadingMore = false;
  bool _noMore = false;

  @override
  void initState() {
    super.initState();
    _pager = MockPagedData<_ChatMessageData>(pageFactory: _fakeMessages);
    _messages = _pager.firstPage();
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
          itemCount:
              1 + _fixedMessages.length + _messages.length + (_loadingMore || _noMore ? 1 : 0),
          itemBuilder: (BuildContext context, int index) {
            if (index == 0) {
              return const _ProfileBanner();
            }
            if (index <= _fixedMessages.length) {
              return _MessageItem(data: _fixedMessages[index - 1]);
            }
            final int dynamicIndex = index - 1 - _fixedMessages.length;
            if (dynamicIndex == _messages.length && (_loadingMore || _noMore)) {
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
            return _MessageItem(data: _messages[dynamicIndex]);
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
      _messages = _pager.firstPage();
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
      _messages = <_ChatMessageData>[..._messages, ..._pager.nextPage()];
      _loadingMore = false;
      _noMore = !_pager.hasMore;
    });
  }

  List<_ChatMessageData> _fakeMessages(int start, int count) {
    const List<String> names = <String>[
      'Elif',
      'Mert',
      'Derya',
      'Aylin',
      'Lina',
      'Ece',
      'Deniz',
      'Selin',
      'Bora',
      'Zeynep',
    ];
    const List<String> previews = <String>[
      'Bugün nasılsın? Biraz sohbet edelim mi?',
      'Paylaşımını gördüm, gerçekten çok güzel olmuş.',
      'Akşam odada buluşalım mı?',
      'Yeni bir şarkı keşfettim, sana da göndereyim.',
      'Uzun zamandır görünmüyorsun, her şey yolunda mı?',
      'Profilindeki fotoğraf çok güzelmiş 😊',
      'Müsait olunca bana yazabilirsin.',
      'Bugünkü etkinliğe katılacak mısın?',
      'Tanıştığımıza memnun oldum!',
      'Sana küçük bir sürpriz gönderdim.',
    ];
    const List<String> avatars = <String>[
      UserAssets.avatar001,
      UserAssets.avatar002,
      UserAssets.avatar003,
      UserAssets.avatar004,
      UserAssets.avatar005,
      UserAssets.avatar006,
    ];
    return List<_ChatMessageData>.generate(count, (int index) {
      final int dataIndex = (start + index) % names.length;
      return _ChatMessageData(
        icon: Icons.person_outline,
        iconColor: Colors.white70,
        avatarAsset: avatars[(start + index) % avatars.length],
        title: names[dataIndex],
        time: dataIndex.isEven ? 'Şimdi' : '${dataIndex + 1} dk önce',
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
                  Text('Henüz kalbin kıpırdamadı mı?',
                      style: TextStyle(
                          color: Color(0xFFBFE7FF), fontSize: 17, fontWeight: FontWeight.w700)),
                  SizedBox(height: 5),
                  Text('Profilini tamamla, yanıtların artsın~',
                      style: TextStyle(color: Colors.white70, fontSize: 11)),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
              decoration: BoxDecoration(
                  color: const Color(0xFF3EE5E4), borderRadius: BorderRadius.circular(18)),
              child: const Text('Tamamla',
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
        height: 72,
        child: Row(children: <Widget>[
          Container(
            width: 60,
            height: 60,
            margin: const EdgeInsets.only(left: 14, right: 16),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color:
                  data.avatarAsset == null ? data.iconColor.withOpacity(.15) : Colors.transparent,
            ),
            clipBehavior: Clip.antiAlias,
            child: data.avatarAsset == null
                ? Icon(data.icon, color: data.iconColor, size: 34)
                : Image.asset(data.avatarAsset!, fit: BoxFit.cover),
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
    this.avatarAsset,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String time;
  final String preview;
  final String? avatarAsset;
}

class _FriendContent extends StatefulWidget {
  const _FriendContent();

  @override
  State<_FriendContent> createState() => _FriendContentState();
}

class _FriendContentState extends State<_FriendContent> {
  final ScrollController _scrollController = ScrollController();
  late final MockPagedData<_FriendData> _pager;
  late List<_FriendData> _friends;
  bool _loadingMore = false;
  bool _noMore = false;

  static const List<String> _names = <String>[
    'Yıldız Rüyası',
    'Tatlı Geyik',
    'Süt Şekeri',
    'Bulut Koleksiyoncusu',
    'Akşam Esintisi',
    'Şeftali Kızı',
    'Deniz Sodası',
    'Ay Postacısı',
    'Portakal Gazozu',
    'Güney Rüzgârı',
    'Küçük Güneş',
    'Hindistan Cevizi',
    'Galaksi Gezisi',
    'Tatlı Tavşan',
    'Bahar Özel',
    'İyi Geceler Balık',
    'Serin Nane',
    'Yedi Ölçü Tatlı',
    'Sisli Dağ',
    'Güneş Bebek',
  ];
  static const List<String> _avatars = <String>[
    '001.webp',
    '002.webp',
    '003.webp',
    '004.webp',
    '005.webp',
    '006.webp',
  ];

  @override
  void initState() {
    super.initState();
    _pager = MockPagedData<_FriendData>(pageFactory: _fakeFriends);
    _friends = _pager.firstPage();
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
          padding: const EdgeInsets.fromLTRB(14, 0, 14, 110),
          itemCount: _friends.length + (_loadingMore || _noMore ? 1 : 0),
          separatorBuilder: (_, __) => Divider(height: 1, color: Colors.white.withOpacity(.06)),
          itemBuilder: (_, int index) {
            if (index == _friends.length) {
              return Padding(
                padding: const EdgeInsets.only(top: 12, bottom: 22),
                child: Center(
                  child: _loadingMore
                      ? const SizedBox(
                          width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2))
                      : const Text('Daha fazla veri yok',
                          style: TextStyle(color: Colors.white38, fontSize: 12)),
                ),
              );
            }
            final _FriendData friend = _friends[index];
            return _FriendItem(name: friend.name, avatar: friend.avatar, isMale: friend.isMale);
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
      _friends = _pager.firstPage();
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
      _friends = <_FriendData>[..._friends, ..._pager.nextPage()];
      _loadingMore = false;
      _noMore = !_pager.hasMore;
    });
  }

  List<_FriendData> _fakeFriends(int offset, int limit) =>
      List<_FriendData>.generate(limit, (int index) {
        final int sourceIndex = (offset + index) % _names.length;
        final int cycle = (offset + index) ~/ _names.length;
        return _FriendData(
          name: cycle == 0 ? _names[sourceIndex] : '${_names[sourceIndex]} ${cycle + 1}',
          avatar: _avatars[sourceIndex % _avatars.length],
          isMale: (offset + index).isEven,
        );
      });
}

class _FriendData {
  const _FriendData({required this.name, required this.avatar, required this.isMale});
  final String name;
  final String avatar;
  final bool isMale;
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
              child: Image.asset('${UserAssets.directory}/$avatar',
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
