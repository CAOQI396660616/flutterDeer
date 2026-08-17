import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// VoiceVibe 直播房间页。
///
/// 对应设计稿中的 `voice-live-room` 画板。当前使用本地数据演示房间布局、
/// 参与者、聊天消息和底部操作，不连接实时音频或服务端消息。
class VoiceVibeLiveRoomPage extends StatefulWidget {
  const VoiceVibeLiveRoomPage({
    required this.title,
    required this.coverAsset,
    required this.hostName,
    required this.listenerLabel,
    super.key,
  });

  final String title;
  final String coverAsset;
  final String hostName;
  final String listenerLabel;

  /// 生成供 Fluro 使用的房间地址，资源路径和中文参数会被安全编码。
  static String routePath({
    required String title,
    required String coverAsset,
    required String hostName,
    required String listenerLabel,
  }) {
    final Map<String, String> query = <String, String>{
      'title': title,
      'cover': coverAsset,
      'host': hostName,
      'listeners': listenerLabel,
    };
    return '/login/voiceVibe/liveRoom?${query.entries.map((MapEntry<String, String> entry) => '${entry.key}=${Uri.encodeComponent(entry.value)}').join('&')}';
  }

  @override
  State<VoiceVibeLiveRoomPage> createState() => _VoiceVibeLiveRoomPageState();
}

class _VoiceVibeLiveRoomPageState extends State<VoiceVibeLiveRoomPage> {
  static const Color _backgroundColor = Color(0xFF121016);
  static const Color _surfaceColor = Color(0xFF24202D);
  static const Color _secondarySurfaceColor = Color(0xFF302A3E);
  static const Color _primaryColor = Color(0xFF8A63D2);
  static const Color _pinkColor = Color(0xFFFF0055);
  static const Color _textColor = Color(0xFFF7F2FA);
  static const Color _secondaryTextColor = Color(0xFFBDB5C9);
  static const String _assetDir = 'assets/images/login/voice_vibe';

  static const List<String> _participantAssets = <String>[
    '$_assetDir/voice_vibe_host_1.png',
    '$_assetDir/voice_vibe_rec_1.png',
    '$_assetDir/voice_vibe_host_2.png',
    '$_assetDir/voice_vibe_discover_host_1.png',
    '$_assetDir/voice_vibe_rec_2.png',
    '$_assetDir/voice_vibe_discover_host_2.png',
  ];

  bool _isFollowing = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
      systemNavigationBarColor: _backgroundColor,
      systemNavigationBarIconBrightness: Brightness.light,
    ));
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: _backgroundColor,
        body: SafeArea(
          child: Column(
            children: <Widget>[
              _buildHeader(),
              Expanded(child: _buildRoomContent()),
              _buildComposer(),
            ],
          ),
        ),
      );

  Widget _buildHeader() => Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 16, 14),
        child: Row(
          children: <Widget>[
            _RoundButton(
              icon: Icons.arrow_back,
              semanticLabel: '返回',
              onTap: () => Navigator.of(context).maybePop(),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    widget.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: _textColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'ID: 4859385',
                    style: TextStyle(color: _secondaryTextColor, fontSize: 11),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () => setState(() => _isFollowing = !_isFollowing),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: _isFollowing ? _secondarySurfaceColor : _primaryColor,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  child: Text(
                    _isFollowing ? '已关注' : '关注',
                    style: const TextStyle(
                        color: _textColor, fontSize: 12, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            DecoratedBox(
              decoration: const BoxDecoration(
                color: _surfaceColor,
                borderRadius: BorderRadius.all(Radius.circular(18)),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                child: Row(
                  children: <Widget>[
                    const Icon(Icons.people_alt_outlined, color: _textColor, size: 15),
                    const SizedBox(width: 4),
                    Text(widget.listenerLabel,
                        style: const TextStyle(color: _textColor, fontSize: 12)),
                  ],
                ),
              ),
            ),
          ],
        ),
      );

  Widget _buildRoomContent() => ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        children: <Widget>[
          _buildHostHero(),
          const SizedBox(height: 20),
          _buildParticipantGrid(),
          const SizedBox(height: 18),
          _buildChatMessages(),
        ],
      );

  Widget _buildHostHero() => Column(
        children: <Widget>[
          SizedBox(
            width: 128,
            height: 128,
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                ImageFiltered(
                  imageFilter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                  child: ClipOval(
                    child:
                        Image.asset(widget.coverAsset, width: 112, height: 112, fit: BoxFit.cover),
                  ),
                ),
                Container(
                  width: 96,
                  height: 96,
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: _backgroundColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: _primaryColor, width: 2),
                    boxShadow: const <BoxShadow>[
                      BoxShadow(color: Color(0x998A63D2), blurRadius: 24, spreadRadius: 4),
                    ],
                  ),
                  child: ClipOval(
                    child: Image.asset(widget.coverAsset, fit: BoxFit.cover),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          DecoratedBox(
            decoration: BoxDecoration(
              color: _primaryColor.withOpacity(0.8),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Icon(Icons.mic, color: _textColor, size: 14),
                  const SizedBox(width: 4),
                  Text('主持：${widget.hostName}',
                      style: const TextStyle(color: _textColor, fontSize: 12)),
                ],
              ),
            ),
          ),
        ],
      );

  Widget _buildParticipantGrid() => GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 8,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: 14,
          crossAxisSpacing: 10,
          childAspectRatio: 0.82,
        ),
        itemBuilder: (BuildContext context, int index) {
          if (index >= _participantAssets.length) {
            return _buildEmptyParticipant();
          }
          return Column(
            children: <Widget>[
              ClipOval(
                child: Image.asset(_participantAssets[index],
                    width: 54, height: 54, fit: BoxFit.cover),
              ),
              const SizedBox(height: 6),
              Text(
                <String>['夏野', '小雨', '麦子', '木木', '二喵', '阿风'][index],
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: _secondaryTextColor, fontSize: 12),
              ),
            ],
          );
        },
      );

  Widget _buildEmptyParticipant() => Column(
        children: <Widget>[
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: _surfaceColor,
              shape: BoxShape.circle,
              border: Border.all(color: _secondaryTextColor.withOpacity(0.35)),
            ),
            child: const Icon(Icons.person_add_alt_1, color: _secondaryTextColor, size: 24),
          ),
          const SizedBox(height: 6),
          const Text('等位置', style: TextStyle(color: _secondaryTextColor, fontSize: 12)),
        ],
      );

  Widget _buildChatMessages() => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _ChatBubble(
            name: 'System',
            message: '欢迎来到「${widget.title}」！请文明发言，共同维护健康社区环境。',
            highlighted: true,
          ),
          const _ChatBubble(name: '小雨', message: '这首歌什么名字呀？太治愈了💖'),
          const _ChatBubble(name: '麦子', message: '吉他弹得超级赞，为主播疯狂打 call！'),
          _ChatBubble(name: '主持 ${widget.hostName}', message: '感谢大家的喜欢！接下来给大家弹一首《晴天》'),
        ],
      );

  Widget _buildComposer() => Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
        child: Row(
          children: <Widget>[
            Expanded(
              child: GestureDetector(
                onTap: () => _showMessage('聊天输入暂未连接'),
                child: Container(
                  height: 44,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  alignment: Alignment.centerLeft,
                  decoration: const BoxDecoration(
                    color: _surfaceColor,
                    borderRadius: BorderRadius.all(Radius.circular(24)),
                  ),
                  child: const Text('聊两句...',
                      style: TextStyle(color: _secondaryTextColor, fontSize: 13)),
                ),
              ),
            ),
            const SizedBox(width: 8),
            _RoundButton(
                icon: Icons.graphic_eq, semanticLabel: '声音', onTap: () => _showMessage('声音面板暂未配置')),
            const SizedBox(width: 8),
            _RoundButton(
                icon: Icons.card_giftcard,
                semanticLabel: '礼物',
                filled: true,
                onTap: () => _showMessage('礼物面板暂未配置')),
            const SizedBox(width: 8),
            _RoundButton(
                icon: Icons.send_outlined,
                semanticLabel: '分享',
                onTap: () => _showMessage('分享功能暂未配置')),
            const SizedBox(width: 8),
            _RoundButton(
                icon: Icons.close,
                semanticLabel: '关闭房间',
                accent: true,
                onTap: () => Navigator.of(context).maybePop()),
          ],
        ),
      );
}

class _ChatBubble extends StatelessWidget {
  const _ChatBubble({required this.name, required this.message, this.highlighted = false});

  final String name;
  final String message;
  final bool highlighted;

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
        decoration: BoxDecoration(
          color: highlighted ? const Color(0xFF2B243A) : const Color(0xFF211E27),
          borderRadius: BorderRadius.circular(16),
        ),
        child: RichText(
          text: TextSpan(
            style: const TextStyle(color: Color(0xFFE8E0EE), fontSize: 12, height: 1.35),
            children: <InlineSpan>[
              TextSpan(text: '$name：', style: const TextStyle(fontWeight: FontWeight.w700)),
              TextSpan(text: message),
            ],
          ),
        ),
      );
}

class _RoundButton extends StatelessWidget {
  const _RoundButton({
    required this.icon,
    required this.semanticLabel,
    required this.onTap,
    this.filled = false,
    this.accent = false,
  });

  final IconData icon;
  final String semanticLabel;
  final VoidCallback onTap;
  final bool filled;
  final bool accent;

  @override
  Widget build(BuildContext context) => Semantics(
        button: true,
        label: semanticLabel,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: filled
                  ? _VoiceVibeLiveRoomPageState._primaryColor
                  : _VoiceVibeLiveRoomPageState._surfaceColor,
              shape: BoxShape.circle,
              border: accent
                  ? Border.all(color: _VoiceVibeLiveRoomPageState._pinkColor, width: 1.5)
                  : null,
            ),
            child: Icon(
              icon,
              color: accent
                  ? _VoiceVibeLiveRoomPageState._pinkColor
                  : _VoiceVibeLiveRoomPageState._textColor,
              size: 20,
            ),
          ),
        ),
      );
}
