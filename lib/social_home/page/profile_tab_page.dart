import 'package:flutter/material.dart';
import 'package:flutter_deer/login/login_router.dart';
import 'package:flutter_deer/login/store/login_user_store.dart';

class ProfileTabPage extends StatelessWidget {
  const ProfileTabPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = LoginUserStore.currentUser;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(user?.nickname ?? 'Profil',
                style: const TextStyle(
                    color: Colors.white, fontSize: 22, fontWeight: FontWeight.w600)),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () {
                LoginUserStore.clear();
                Navigator.of(context).pushNamedAndRemoveUntil(LoginRouter.loginPage, (_) => false);
              },
              icon: const Icon(Icons.logout),
              label: const Text('Çıkış yap'),
            ),
          ],
        ),
      ),
    );
  }
}
