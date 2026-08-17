import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_deer/login/data/voice_vibe_profile_data.dart';
import 'package:flutter_deer/login/models/voice_vibe_profile_model.dart';

/// VoiceVibe 声浪「我的」页面。
///
/// 页面根据 Figma 节点 `3:481` 实现，展示用户信息卡片与功能入口列表。
/// 所有交互均为本地演示。
class VoiceVibeProfilePage extends StatefulWidget {
  const VoiceVibeProfilePage({super.key});

  @override
  State<VoiceVibeProfilePage> createState() => _VoiceVibeProfilePageState();
}

class _VoiceVibeProfilePageState extends State<VoiceVibeProfilePage> {
  static const Color _backgroundColor = Color(0xFFFEF7FF);
  static const Color _primaryColor = Color(0xFF6750A4);
  static const Color _surfaceColor = Color(0xFFF7F2FA);
  static const Color _outlineColor = Color(0xFFE7E0EC);
  static const Color _secondaryContainerColor = Color(0xFFEADDFF);
  static const Color _onSurfaceColor = Color(0xFF1C1B1F);
  static const Color _secondaryTextColor = Color(0xFF49454F);

  static const String _assetDir = 'assets/images/login/voice_vibe';

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
  }

  /// 显示页面内轻量反馈，避免演示操作静默失败。
  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: _backgroundColor,
        body: SafeArea(
          bottom: false,
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              _buildProfileHeader(),
              _buildStatRow(),
              const SizedBox(height: 16),
              _buildMenuSection(),
            ],
          ),
        ),
      );

  Widget _buildProfileHeader() => Padding(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
        child: Row(
          children: <Widget>[
            ClipOval(
              child: Image.asset(
                VoiceVibeProfileData.userAvatar,
                width: 64,
                height: 64,
                fit: BoxFit.cover,
                semanticLabel: '${VoiceVibeProfileData.userName} 头像',
                errorBuilder: (_, __, ___) =>
                    const SizedBox(width: 64, height: 64),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    VoiceVibeProfileData.userName,
                    style: const TextStyle(
                      color: _onSurfaceColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    VoiceVibeProfileData.userId,
                    style: const TextStyle(
                      color: _secondaryTextColor,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            Semantics(
              button: true,
              label: '编辑资料',
              child: InkWell(
                onTap: () => _showMessage('即将打开编辑资料页面'),
                borderRadius: BorderRadius.circular(100),
                child: Ink(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: _secondaryContainerColor,
                    borderRadius:
                        const BorderRadius.all(Radius.circular(100)),
                  ),
                  child: const Text(
                    '编辑',
                    style: TextStyle(
                      color: _primaryColor,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );

  Widget _buildStatRow() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Row(
          children: <Widget>[
            _StatChip(
              label: VoiceVibeProfileData.fansLabel,
              onTap: () => _showMessage('即将打开粉丝列表'),
            ),
            const SizedBox(width: 12),
            _StatChip(
              label: VoiceVibeProfileData.followLabel,
              onTap: () => _showMessage('即将打开关注列表'),
            ),
          ],
        ),
      );

  Widget _buildMenuSection() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          children: <Widget>[
            for (int i = 0;
                i < VoiceVibeProfileData.menuItems.length;
                i++) ...[
              if (i > 0)
                const Divider(
                  height: 1,
                  indent: 68,
                  color: _outlineColor,
                ),
              _ProfileMenuItem(
                item: VoiceVibeProfileData.menuItems[i],
                onTap: () => _showMessage(
                  '即将打开「${VoiceVibeProfileData.menuItems[i].label}」',
                ),
              ),
            ],
          ],
        ),
      );
}

/// 粉丝/关注统计标签。
class _StatChip extends StatelessWidget {
  const _StatChip({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: _VoiceVibeProfilePageState._surfaceColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: _VoiceVibeProfilePageState._outlineColor,
            ),
          ),
          child: Text(
            label,
            style: const TextStyle(
              color: _VoiceVibeProfilePageState._secondaryTextColor,
              fontSize: 12,
            ),
          ),
        ),
      );
}

/// 功能菜单项。
class _ProfileMenuItem extends StatelessWidget {
  const _ProfileMenuItem({required this.item, required this.onTap});

  final VoiceVibeProfileMenuItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          child: Row(
            children: <Widget>[
              SizedBox(
                width: 28,
                height: 28,
                child: Image.asset(
                  item.iconAsset,
                  width: 28,
                  height: 28,
                  semanticLabel: '${item.label}图标',
                  errorBuilder: (_, __, ___) =>
                      const SizedBox(width: 28, height: 28),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  item.label,
                  style: const TextStyle(
                    color: _VoiceVibeProfilePageState._onSurfaceColor,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              if (item.trailing.isNotEmpty)
                Text(
                  item.trailing,
                  style: const TextStyle(
                    color: _VoiceVibeProfilePageState._primaryColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              if (item.trailing.isNotEmpty) const SizedBox(width: 8),
              Icon(
                Icons.chevron_right,
                size: 20,
                color:
                    _VoiceVibeProfilePageState._secondaryTextColor,
              ),
            ],
          ),
        ),
      );
}
