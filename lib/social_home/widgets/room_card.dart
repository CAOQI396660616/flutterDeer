import 'package:flutter/material.dart';
import 'package:flutter_deer/social_home/models/room_model.dart';
import 'package:flutter_deer/social_home/data/user_assets.dart';

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
                      top: 9,
                      right: 9,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: const Color(0xCCDCE7E7),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          child: Text('Canlı',
                              style: TextStyle(
                                  color: Color(0xFF198B8A),
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600)),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 8,
                      left: 9,
                      right: 9,
                      child: Row(
                        children: <Widget>[
                          _HostBadge(name: room.hostName, coverAsset: room.coverAsset),
                          const Spacer(),
                          _RoomStatus(count: room.onlineCount),
                        ],
                      ),
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

class _HostBadge extends StatelessWidget {
  const _HostBadge({required this.name, required this.coverAsset});
  final String name;
  final String coverAsset;

  @override
  Widget build(BuildContext context) => Flexible(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              width: 19,
              height: 19,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white70),
                image: DecorationImage(image: AssetImage(coverAsset)),
              ),
            ),
            const SizedBox(width: 4),
            Flexible(
              child: Text(name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white, fontSize: 10)),
            ),
            const SizedBox(width: 4),
            Image.asset(UserAssets.svipTag, width: 28, height: 16, fit: BoxFit.contain),
          ],
        ),
      );
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
