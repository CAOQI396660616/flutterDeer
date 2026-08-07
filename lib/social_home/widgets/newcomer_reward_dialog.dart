import 'dart:ui';

import 'package:flutter/material.dart';

/// 新人礼包展示弹框。
///
/// 当前阶段只负责展示和关闭，奖励领取状态、接口调用留待后续业务接入。
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
    final double width =
        ((MediaQuery.sizeOf(context).width - 48).clamp(300.0, 470.0)) as double;
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
              color: const Color(0xB3101820),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white24),
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: width),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 24, 18, 14),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const Text(
                      '新人礼包',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 28),
                    LayoutBuilder(
                      builder: (BuildContext context, BoxConstraints constraints) {
                        final double itemWidth = (constraints.maxWidth - 24) / 3;
                        return Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 12,
                          runSpacing: 12,
                          children: _rewards
                              .map((reward) => SizedBox(
                                    width: itemWidth,
                                    child: _RewardTile(reward: reward),
                                  ))
                              .toList(),
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: 190,
                      height: 56,
                      child: FilledButton(
                        key: const Key('newcomer_reward_claim'),
                        onPressed: () => Navigator.of(context).pop(),
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFF14D8D4),
                          foregroundColor: const Color(0xFF10202A),
                          shape: const StadiumBorder(),
                        ),
                        child: const Text('收下', style: TextStyle(fontSize: 22)),
                      ),
                    ),
                    const SizedBox(height: 8),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(.16),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white24),
                      ),
                      child: IconButton(
                        key: const Key('newcomer_reward_close'),
                        onPressed: () => Navigator.of(context).pop(),
                        color: Colors.white70,
                        icon: const Icon(Icons.close),
                        tooltip: '关闭',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RewardItem {
  const _RewardItem(
      {required this.name,
      required this.badge,
      required this.quantity,
      required this.imagePath});
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
          height: 136,
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
            alignment: Alignment.center,
            children: <Widget>[
              Image.asset(
                reward.imagePath,
                width: 78,
                height: 62,
                fit: BoxFit.contain,
              ),
              Positioned(
                bottom: 36,
                child: Text(reward.name,
                    style: const TextStyle(color: Colors.white, fontSize: 12)),
              ),
              Positioned(
                bottom: 8,
                child: Text(reward.quantity,
                    style: const TextStyle(
                        color: Color(0xFFB8F4FF),
                        fontSize: 23,
                        fontWeight: FontWeight.w500)),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: ClipPath(
                  clipper: _RewardBadgeClipper(),
                  child: Container(
                    width: 52,
                    height: 34,
                    color: const Color(0xFF8DEEFF),
                    alignment: Alignment.topRight,
                    padding: const EdgeInsets.only(top: 3, right: 7),
                    child: Text(reward.badge,
                        style: const TextStyle(
                            color: Color(0xFF092B78),
                            fontSize: 18,
                            fontWeight: FontWeight.w600)),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 8,
                child: Container(width: 58, height: 4, color: const Color(0xFF8DEEFF)),
              ),
            ],
          ),
        ),
      );
}

class _RewardBadgeClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) => Path()
    ..moveTo(0, 0)
    ..lineTo(size.width, 0)
    ..lineTo(size.width, size.height)
    ..lineTo(0, size.height)
    ..lineTo(size.width * .22, size.height * .5)
    ..close();

  @override
  bool shouldReclip(covariant _RewardBadgeClipper oldClipper) => false;
}
