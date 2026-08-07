import 'package:flutter/material.dart';
import 'package:flutter_deer/social_home/data/user_assets.dart';
import 'package:flutter_deer/social_home/models/room_model.dart';

class RoomCard extends StatelessWidget {
  const RoomCard({super.key, required this.room, required this.onTap});
  final RoomModel room;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Ink(
          decoration: BoxDecoration(
            color: const Color(0xFF202329),
            borderRadius: BorderRadius.circular(14),
            boxShadow: const <BoxShadow>[
              BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 4)),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
                child: Stack(
                  children: <Widget>[
                    Image.asset(
                      room.coverAsset,
                      width: double.infinity,
                      height: 132,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Image.asset(
                        'assets/images/login_social/ic_placeholder_room_cover.png',
                        width: double.infinity,
                        height: 132,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: _RoomTypeTag(room: room),
                    ),
                    Positioned(
                      bottom: 8,
                      left: 9,
                      child: _HostBadge(name: room.hostName),
                    ),
                    Positioned(
                      bottom: 8,
                      right: 10,
                      child: _RoomStatus(count: room.onlineCount),
                    ),
                  ],
                ),
              ),
              ClipRRect(
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(14)),
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: <Color>[Color(0xFF28303D), Color(0xFF151922)],
                    ),
                  ),
                  padding: const EdgeInsets.fromLTRB(10, 8, 10, 9),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(room.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 7),
                      Row(
                        children: <Widget>[
                          const Icon(Icons.badge_outlined, color: Colors.white38, size: 12),
                          const SizedBox(width: 3),
                          Expanded(
                            child: Text(room.id.toUpperCase(),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(color: Colors.white38, fontSize: 10)),
                          ),
                          const Icon(Icons.bar_chart_rounded, color: Colors.white38, size: 13),
                          const SizedBox(width: 3),
                          Text('${room.onlineCount + 75}',
                              style: const TextStyle(color: Colors.white38, fontSize: 10)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}

class _RoomTypeTag extends StatelessWidget {
  const _RoomTypeTag({required this.room});
  final RoomModel room;

  @override
  Widget build(BuildContext context) {
    final _RoomTypeTagData tag = _tagForRoom(room);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(12),
          bottomLeft: Radius.circular(9),
          topLeft: Radius.circular(4),
          bottomRight: Radius.circular(4),
        ),
        gradient: LinearGradient(colors: tag.colors),
      ),
      child: Text(tag.label,
          style: TextStyle(color: tag.textColor, fontSize: 10, fontWeight: FontWeight.w700)),
    );
  }

  _RoomTypeTagData _tagForRoom(RoomModel room) {
    final int value = room.id.codeUnits.fold<int>(0, (int sum, int code) => sum + code);
    return switch (value % 4) {
      0 => const _RoomTypeTagData(
          label: 'Canlı',
          colors: <Color>[Color(0xFFFFE68A), Color(0xFFFF9D5C)],
          textColor: Color(0xFF6E2B25)),
      1 => const _RoomTypeTagData(
          label: 'Oyun',
          colors: <Color>[Color(0xFF9BE7FF), Color(0xFF62A9FF)],
          textColor: Color(0xFF153B70)),
      2 => const _RoomTypeTagData(
          label: 'Sesli',
          colors: <Color>[Color(0xFFD7B4FF), Color(0xFF9C72F2)],
          textColor: Color(0xFF3E1D70)),
      _ => const _RoomTypeTagData(
          label: 'Müzik',
          colors: <Color>[Color(0xFFFFB8D8), Color(0xFFFF7B9E)],
          textColor: Color(0xFF6C203D)),
    };
  }
}

class _RoomTypeTagData {
  const _RoomTypeTagData({required this.label, required this.colors, required this.textColor});
  final String label;
  final List<Color> colors;
  final Color textColor;
}

class _HostBadge extends StatelessWidget {
  const _HostBadge({required this.name});
  final String name;

  @override
  Widget build(BuildContext context) {
    final int seed = name.codeUnits.fold<int>(0, (int sum, int code) => sum + code);
    final List<String> avatars = List<String>.generate(
      3,
      (int index) => UserAssets.avatars[(seed + index) % UserAssets.avatars.length],
    );
    return SizedBox(
      width: 46,
      height: 20,
      child: Stack(
        clipBehavior: Clip.none,
        children: List<Widget>.generate(
          avatars.length,
          (int index) => Positioned(
            left: index * 12,
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white70),
                image: DecorationImage(image: AssetImage(avatars[index]), fit: BoxFit.cover),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RoomStatus extends StatelessWidget {
  const _RoomStatus({required this.count});
  final int count;

  @override
  Widget build(BuildContext context) => DecoratedBox(
        decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
          child: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
            const Icon(Icons.people_alt_outlined, color: Colors.white70, size: 13),
            const SizedBox(width: 3),
            Text('$count', style: const TextStyle(color: Colors.white70, fontSize: 11))
          ]),
        ),
      );
}
