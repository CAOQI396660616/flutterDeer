import 'package:flutter/material.dart';
import 'package:flutter_deer/login/login_router.dart';
import 'package:flutter_deer/login/store/login_user_store.dart';

class ProfileSettingsPage extends StatelessWidget {
  const ProfileSettingsPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: const Color(0xFF12152B),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          elevation: 0,
          title: const Text('Ayarlar'),
        ),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: <Widget>[
            _SettingsCard(
              icon: Icons.person_outline,
              title: 'Profil bilgileri',
              subtitle: 'Profil adını ve kişisel bilgilerini düzenle',
              onTap: () => _showUnavailable(context),
            ),
            _SettingsCard(
              icon: Icons.notifications_none_outlined,
              title: 'Bildirimler',
              subtitle: 'Bildirim tercihlerini yönet',
              onTap: () => _showUnavailable(context),
            ),
            const SizedBox(height: 18),
            _SettingsCard(
              icon: Icons.logout,
              title: 'Çıkış yap',
              subtitle: 'Bu cihazdaki hesabından çıkış yap',
              destructive: true,
              onTap: () => _confirmLogout(context),
            ),
          ],
        ),
      );

  void _showUnavailable(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Bu özellik yakında kullanılabilir olacak')),
    );
  }

  Future<void> _confirmLogout(BuildContext context) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) => AlertDialog(
        title: const Text('Çıkış yap'),
        content: const Text('Hesabından çıkış yapmak istediğine emin misin?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Vazgeç'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Çıkış yap'),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) {
      return;
    }
    LoginUserStore.clear();
    Navigator.of(context).pushNamedAndRemoveUntil(LoginRouter.loginPage, (_) => false);
  }
}

class _SettingsCard extends StatelessWidget {
  const _SettingsCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.destructive = false,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool destructive;

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(.1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: ListTile(
          onTap: onTap,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
          leading: Icon(icon, color: destructive ? Colors.redAccent : const Color(0xFF19D7D8)),
          title: Text(title,
              style: TextStyle(
                  color: destructive ? Colors.redAccent : Colors.white,
                  fontWeight: FontWeight.w600)),
          subtitle: Text(subtitle, style: const TextStyle(color: Colors.white60, fontSize: 12)),
          trailing: const Icon(Icons.chevron_right, color: Colors.white54),
        ),
      );
}
