import 'package:flutter/material.dart';
import 'package:flutter_deer/login/store/login_user_store.dart';
import 'package:flutter_deer/login/widgets/remote_avatar.dart';
import 'package:flutter_deer/social_home/page/profile_edit_page.dart';
import 'package:flutter_deer/social_home/page/profile_settings_page.dart';

/// First-stage Profil UI: profile area, pinned tabs, and local mock content.
class ProfileTabPage extends StatefulWidget {
  const ProfileTabPage({super.key});

  @override
  State<ProfileTabPage> createState() => _ProfileTabPageState();
}

class _ProfileTabPageState extends State<ProfileTabPage> with SingleTickerProviderStateMixin {
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
  Widget build(BuildContext context) {
    final user = LoginUserStore.currentUser;
    final String nickname = user?.nickname ?? 'Emre Yılmaz';
    final String avatar = user?.avatar ?? 'https://randomuser.me/api/portraits/women/44.jpg';
    return NestedScrollView(
      headerSliverBuilder: (_, __) => <Widget>[
        SliverToBoxAdapter(child: _ProfileHeader(nickname: nickname, avatar: avatar)),
        SliverPersistentHeader(
          pinned: true,
          delegate: _ProfileTabHeaderDelegate(controller: _tabController),
        ),
      ],
      body: TabBarView(
        controller: _tabController,
        children: const <Widget>[_DynamicContent(), _ProfileContent()],
      ),
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
                _ProfileAction(
                  icon: Icons.edit_outlined,
                  label: 'Düzenle',
                  onTap: () => Navigator.of(context).push<void>(
                    MaterialPageRoute<void>(builder: (_) => const ProfileEditPage()),
                  ),
                ),
                _ProfileAction(
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
                const _Tag(text: '25', color: Color(0xFF19D7D8)),
              ]),
              const SizedBox(height: 6),
              const Text('ID: 177173883   IP konumu: Guangdong',
                  style: TextStyle(color: Colors.white60, fontSize: 12)),
              const SizedBox(height: 10),
              const Wrap(spacing: 6, runSpacing: 6, children: <Widget>[
                _Tag(text: 'SVIP', color: Color(0xFFDBE7FF)),
                _Tag(text: 'Sıradan', color: Color(0xFF71777C)),
                _Tag(text: 'Küçük Çaylak', color: Color(0xFF9A9FA4)),
                _Tag(text: '1', color: Color(0xFF7DCB31)),
                _Tag(text: 'Yeni Bronz', color: Color(0xFF6F9C83)),
              ]),
              const SizedBox(height: 14),
              const Text('Profiline bir imza ekleyerek daha fazla ilgi çekebilirsin',
                  style: TextStyle(color: Colors.white70, fontSize: 14)),
            ]),
          ],
        ),
      );
}

class _ProfileAction extends StatelessWidget {
  const _ProfileAction({required this.icon, required this.label, required this.onTap});
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Tooltip(
        message: label,
        child: IconButton(
          onPressed: onTap,
          icon: Icon(icon, color: Colors.white70, size: 20),
          splashRadius: 22,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints.tightFor(width: 38, height: 38),
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

class _Tag extends StatelessWidget {
  const _Tag({required this.text, required this.color});
  final String text;
  final Color color;
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
        decoration:
            BoxDecoration(color: color.withOpacity(.85), borderRadius: BorderRadius.circular(9)),
        child: Text(text,
            style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w600)),
      );
}

class _ProfileTabHeaderDelegate extends SliverPersistentHeaderDelegate {
  _ProfileTabHeaderDelegate({required this.controller});
  final TabController controller;
  @override
  double get minExtent => 48;
  @override
  double get maxExtent => 48;
  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) => Container(
        height: 48,
        color: const Color(0xE6141820),
        padding: const EdgeInsets.only(left: 18),
        alignment: Alignment.centerLeft,
        child: TabBar(
          controller: controller,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          tabs: const <Widget>[Tab(text: 'Aktiviteler'), Tab(text: 'Bilgiler')],
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white54,
          labelStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          unselectedLabelStyle: const TextStyle(fontSize: 18),
          labelPadding: const EdgeInsets.symmetric(horizontal: 14),
          indicator: const _BrushIndicatorDecoration(),
          indicatorSize: TabBarIndicatorSize.label,
          dividerColor: Colors.transparent,
        ),
      );
  @override
  bool shouldRebuild(covariant _ProfileTabHeaderDelegate oldDelegate) => false;
}

class _BrushIndicatorDecoration extends Decoration {
  const _BrushIndicatorDecoration();
  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) => _BrushIndicatorPainter();
}

class _BrushIndicatorPainter extends BoxPainter {
  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final Size size = configuration.size ?? Size.zero;
    final Paint paint = Paint()
      ..shader = const LinearGradient(
        colors: <Color>[Color(0xFFFFD54F), Color(0xFFFF7A00)],
      ).createShader(offset & size)
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    final Path path = Path()
      ..moveTo(offset.dx + 3, offset.dy + size.height * .62)
      ..quadraticBezierTo(offset.dx + size.width * .28, offset.dy + size.height * .15,
          offset.dx + size.width * .55, offset.dy + size.height * .52)
      ..quadraticBezierTo(offset.dx + size.width * .78, offset.dy + size.height * .82,
          offset.dx + size.width - 2, offset.dy + size.height * .48);
    canvas.drawPath(path, paint);
  }
}

class _DynamicContent extends StatelessWidget {
  const _DynamicContent();
  @override
  Widget build(BuildContext context) =>
      ListView(padding: const EdgeInsets.all(20), children: const <Widget>[
        _ContentCard(
            icon: Icons.emoji_emotions_outlined,
            title: 'Aktivitelerime hoş geldin',
            body: 'Henüz aktivite yok. İlk paylaşımını yapabilirsin.'),
        _ContentCard(
            icon: Icons.auto_awesome,
            title: 'Yeni başlayan görevi tamamlandı',
            body: '1 yeni başlangıç rozeti kazandın.'),
      ]);
}

class _ProfileContent extends StatelessWidget {
  const _ProfileContent();
  @override
  Widget build(BuildContext context) =>
      ListView(padding: const EdgeInsets.all(20), children: const <Widget>[
        Text('Profil bilgileri',
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
        SizedBox(height: 14),
        _ContentCard(
            icon: Icons.location_on_outlined,
            title: 'Guangdong',
            body: 'Konum bilgisi henüz tamamlanmadı'),
      ]);
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
