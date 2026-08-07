import 'package:flutter/material.dart';

class RemoteAvatar extends StatelessWidget {
  const RemoteAvatar({super.key, required this.imageUrl});

  final String imageUrl;

  static const String placeholderAsset = 'assets/images/login_social/ic_placeholder_room_cover.png';

  @override
  Widget build(BuildContext context) {
    final Widget placeholder = Image.asset(placeholderAsset, fit: BoxFit.cover);
    if (imageUrl.startsWith('assets/')) {
      return Image.asset(imageUrl, fit: BoxFit.cover, errorBuilder: (_, __, ___) => placeholder);
    }
    return Image.network(
      imageUrl,
      fit: BoxFit.cover,
      frameBuilder: (BuildContext context, Widget child, int? frame, bool wasSynchronouslyLoaded) {
        if (wasSynchronouslyLoaded || frame != null) {
          return child;
        }
        return placeholder;
      },
      errorBuilder: (_, __, ___) => placeholder,
    );
  }
}
