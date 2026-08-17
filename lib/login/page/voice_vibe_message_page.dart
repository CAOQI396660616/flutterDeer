import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_deer/login/data/voice_vibe_message_data.dart';
import 'package:flutter_deer/login/models/voice_vibe_message_model.dart';

/// VoiceVibe 声浪消息页。
///
/// 页面根据 Figma 节点 `3:397` 实现，展示私信对话列表。
/// 点击对话项展示轻量反馈，所有交互均为本地演示。
class VoiceVibeMessagePage extends StatefulWidget {
  const VoiceVibeMessagePage({super.key});

  @override
  State<VoiceVibeMessagePage> createState() => _VoiceVibeMessagePageState();
}

class _VoiceVibeMessagePageState extends State<VoiceVibeMessagePage> {
  static const Color _backgroundColor = Color(0xFFFEF7FF);
  static const Color _primaryColor = Color(0xFF6750A4);
  static const Color _surfaceColor = Color(0xFFF7F2FA);
  static const Color _outlineColor = Color(0xFFE7E0EC);
  static const Color _onSurfaceColor = Color(0xFF1C1B1F);
  static const Color _secondaryTextColor = Color(0xFF49454F);
  static const Color _liveColor = Color(0xFFFF0055);

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
              _buildTitleBar(),
              _buildMessageList(),
            ],
          ),
        ),
      );

  Widget _buildTitleBar() => Padding(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
        child: Text(
          '消息',
          style: const TextStyle(
            color: _onSurfaceColor,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      );

  Widget _buildMessageList() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          children: <Widget>[
            for (int i = 0; i < VoiceVibeMessageData.messages.length; i++) ...[
              if (i > 0)
                const Divider(height: 1, indent: 68, color: _outlineColor),
              _MessageItem(
                message: VoiceVibeMessageData.messages[i],
                onTap: () => _showMessage(
                  '即将打开「${VoiceVibeMessageData.messages[i].name}」的对话',
                ),
              ),
            ],
          ],
        ),
      );
}

/// 私信对话列表项。
class _MessageItem extends StatelessWidget {
  const _MessageItem({required this.message, required this.onTap});

  final VoiceVibeMessage message;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Stack(
                children: <Widget>[
                  ClipOval(
                    child: Image.asset(
                      message.avatarAsset,
                      width: 44,
                      height: 44,
                      fit: BoxFit.cover,
                      semanticLabel: '${message.name}头像',
                    ),
                  ),
                  if (message.unreadCount > 0)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        width: 16,
                        height: 16,
                        decoration: const BoxDecoration(
                          color: _VoiceVibeMessagePageState._liveColor,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            message.unreadCount > 99
                                ? '99+'
                                : '${message.unreadCount}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            message.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: _VoiceVibeMessagePageState._onSurfaceColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Text(
                          message.timeLabel,
                          style: const TextStyle(
                            color:
                                _VoiceVibeMessagePageState._secondaryTextColor,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      message.lastMessage,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color:
                            _VoiceVibeMessagePageState._secondaryTextColor,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
}