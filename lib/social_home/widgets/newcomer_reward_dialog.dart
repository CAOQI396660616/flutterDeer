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
        name: 'Medal', badge: '7D', quantity: 'x1', icon: Icons.workspace_premium_outlined),
    _RewardItem(
        name: 'Frame', badge: '7D', quantity: 'x1', icon: Icons.account_circle_outlined),
    _RewardItem(name: 'Tulip', badge: '7D', quantity: 'x10', icon: Icons.local_florist_outlined),
    _RewardItem(
        name: 'Coins', badge: '∞', quantity: 'x1000', icon: Icons.monetization_on_outlined),
    _RewardItem(name: 'Banner', badge: '∞', quantity: 'x1', icon: Icons.flag_outlined),
  ];

  @override
  Widget build(BuildContext context) {
    final double width =
        ((MediaQuery.sizeOf(context).width - 48).clamp(300.0, 470.0)) as double;
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: width),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 10, 18, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  key: const Key('newcomer_reward_close'),
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close, size: 22),
                  color: const Color(0xFF18202A),
                  tooltip: '关闭',
                ),
              ),
              const Text(
                '新人礼包',
                style: TextStyle(
                  color: Color(0xFF18202A),
                  fontSize: 28,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 22),
              LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  final double itemWidth = (constraints.maxWidth - 12) / 2;
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
            ],
          ),
        ),
      ),
    );
  }
}

class _RewardItem {
  const _RewardItem(
      {required this.name, required this.badge, required this.quantity, required this.icon});
  final String name;
  final String badge;
  final String quantity;
  final IconData icon;
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
              Icon(reward.icon, size: 58, color: const Color(0xFFFFE58A)),
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
