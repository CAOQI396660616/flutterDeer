import 'dart:ui';

import 'package:flutter/material.dart';

/// Yeni üye ödüllerini gösteren pencere.
///
/// Şimdilik yalnızca gösterim ve kapatma yapılır.
Future<void> showNewcomerRewardDialog(BuildContext context) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.black.withOpacity(.66),
    builder: (_) => const NewcomerRewardDialog(),
  );
}

class NewcomerRewardDialog extends StatelessWidget {
  const NewcomerRewardDialog({super.key});

  static const List<_RewardItem> _rewards = <_RewardItem>[
    _RewardItem(
        name: 'Medal',
        badge: '7D',
        quantity: 'x1',
        imagePath: 'assets/images/social_home/rewards/ic_room_top_3_1.png'),
    _RewardItem(
        name: 'Frame',
        badge: '7D',
        quantity: 'x1',
        imagePath: 'assets/images/social_home/rewards/ic_stay_main.webp'),
    _RewardItem(
        name: 'Tulip',
        badge: '7D',
        quantity: 'x10',
        imagePath: 'assets/images/social_home/rewards/ic_task_gift_1.png'),
    _RewardItem(
        name: 'Coins',
        badge: '∞',
        quantity: 'x1000',
        imagePath: 'assets/images/social_home/rewards/ic_packet_open_success_coin.webp'),
    _RewardItem(
        name: 'Banner',
        badge: '∞',
        quantity: 'x1',
        imagePath: 'assets/images/social_home/rewards/bg_gift_flow_svip4.webp'),
  ];

  @override
  Widget build(BuildContext context) {
    final double width = (MediaQuery.sizeOf(context).width - 48).clamp(300.0, 470.0);
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white24),
            ),
            child: Stack(
              children: <Widget>[
                const Positioned.fill(
                  child: Image(
                    image: AssetImage('assets/images/social_home/bg_new_user.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned.fill(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
                    child: Container(color: const Color(0xB3101820)),
                  ),
                ),
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: width),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(18, 24, 18, 0),
                    child: Stack(
                      children: <Widget>[
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            const Text(
                              'New Gift',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 21,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 5),
                            const Text(
                              'Rewards credited',
                              style: TextStyle(color: Colors.white70, fontSize: 12),
                            ),
                            const SizedBox(height: 18),
                            LayoutBuilder(
                              builder: (BuildContext context, BoxConstraints constraints) {
                                final double itemWidth = (constraints.maxWidth - 24) / 3;
                                return Column(
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        SizedBox(
                                            width: itemWidth,
                                            child: _RewardTile(reward: _rewards[0])),
                                        const SizedBox(width: 12),
                                        SizedBox(
                                            width: itemWidth,
                                            child: _RewardTile(reward: _rewards[1])),
                                        const SizedBox(width: 12),
                                        SizedBox(
                                            width: itemWidth,
                                            child: _RewardTile(reward: _rewards[2])),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        SizedBox(
                                            width: itemWidth,
                                            child: _RewardTile(reward: _rewards[3])),
                                        const SizedBox(width: 12),
                                        SizedBox(
                                            width: itemWidth,
                                            child: _RewardTile(reward: _rewards[4])),
                                      ],
                                    ),
                                  ],
                                );
                              },
                            ),
                            const SizedBox(height: 18),
                          ],
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: SizedBox(
                            width: 31,
                            height: 31,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(.16),
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white24),
                              ),
                              child: IconButton(
                                key: const Key('newcomer_reward_close'),
                                padding: EdgeInsets.zero,
                                onPressed: () => Navigator.of(context).pop(),
                                color: Colors.white70,
                                iconSize: 16,
                                icon: const Icon(Icons.close),
                                tooltip: 'Close',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RewardItem {
  const _RewardItem(
      {required this.name, required this.badge, required this.quantity, required this.imagePath});
  final String name;
  final String badge;
  final String quantity;
  final String imagePath;
}

class _RewardTile extends StatelessWidget {
  const _RewardTile({required this.reward});
  final _RewardItem reward;

  @override
  Widget build(BuildContext context) => ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          height: 102,
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFF3A9BFF), width: 2),
            borderRadius: BorderRadius.circular(16),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[Color(0xFF123D98), Color(0xFF08256F)],
            ),
          ),
          child: Stack(
            children: <Widget>[
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: SizedBox(
                        height: 58,
                        child: Center(
                          child: Image.asset(
                            reward.imagePath,
                            width: 72,
                            height: 52,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                    Text(reward.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.white, fontSize: 10, height: 1.1)),
                    Text(reward.quantity,
                        style: const TextStyle(
                            color: Color(0xFFB8F4FF),
                            fontSize: 17,
                            height: 1.1,
                            fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  width: 38,
                  height: 17,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(14),
                      bottomLeft: Radius.circular(9),
                    ),
                    gradient: LinearGradient(
                      colors: <Color>[Color(0xFFFFD36A), Color(0xFFFF7A5C)],
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(reward.badge,
                      style: const TextStyle(
                          color: Color(0xFF6E1D27), fontSize: 10, fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ),
      );
}
