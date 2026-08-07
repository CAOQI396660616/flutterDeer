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
    _RewardItem(title: '新人勋章', badge: '7Days', icon: Icons.workspace_premium_outlined),
    _RewardItem(title: '新人头像框', badge: '7Days', icon: Icons.account_circle_outlined),
    _RewardItem(title: '郁金香', badge: 'x10', icon: Icons.local_florist_outlined),
    _RewardItem(title: '财富卡\n+1000', badge: '永久', icon: Icons.credit_card_outlined),
    _RewardItem(title: '进场横幅', badge: '永久', icon: Icons.flag_outlined),
  ];

  @override
  Widget build(BuildContext context) {
    final double width = ((MediaQuery.sizeOf(context).width - 48).clamp(300.0, 470.0)) as double;
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
              const SizedBox(height: 26),
              LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  final double itemWidth = (constraints.maxWidth - 24) / 3;
                  return Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 12,
                    runSpacing: 18,
                    children: _rewards
                        .map((reward) => SizedBox(
                              width: itemWidth,
                              child: _RewardTile(reward: reward),
                            ))
                        .toList(),
                  );
                },
              ),
              const SizedBox(height: 28),
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
  const _RewardItem({required this.title, required this.badge, required this.icon});
  final String title;
  final String badge;
  final IconData icon;
}

class _RewardTile extends StatelessWidget {
  const _RewardTile({required this.reward});
  final _RewardItem reward;

  @override
  Widget build(BuildContext context) => Column(
        children: <Widget>[
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: <Widget>[
              Container(
                height: 106,
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFF98A0A5), width: 1.2),
                  color: const Color(0xFFF9FAFA),
                ),
                child: Center(
                  child: Icon(reward.icon, size: 42, color: const Color(0xFF6E747A)),
                ),
              ),
              Positioned(
                top: -14,
                child: DecoratedBox(
                  decoration: const ShapeDecoration(
                    color: Color(0xFF45484C),
                    shape: StadiumBorder(),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
                    child: Text(reward.badge,
                        style: const TextStyle(color: Colors.white, fontSize: 12)),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 7),
          Text(reward.title,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Color(0xFF18202A), fontSize: 15, height: 1.15)),
        ],
      );
}
