import 'package:flutter/material.dart';
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
      decoration: BoxDecoration(color: const Color(0xFF292B2D), borderRadius: BorderRadius.circular(14)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
            child: Stack(
              children: <Widget>[
                Image.asset('assets/images/login_social/ic_placeholder_room_cover.png', width: double.infinity, height: 116, fit: BoxFit.cover),
                Positioned(bottom: 8, left: 9, child: _RoomStatus(count: room.onlineCount)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 9, 10, 11),
            child: Text(room.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)),
          ),
        ],
      ),
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
      child: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[const Icon(Icons.people_alt_outlined, color: Colors.white70, size: 13), const SizedBox(width: 3), Text('$count', style: const TextStyle(color: Colors.white70, fontSize: 11))]),
    ),
  );
}
