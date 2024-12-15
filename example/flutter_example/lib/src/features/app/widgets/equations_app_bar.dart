import 'package:flutter/material.dart';

class EquationsAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final TabBar? tabBar;
  const EquationsAppBar({
    required this.title,
    this.tabBar,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      bottom: tabBar,
      actions: const [
        _InfoIconButton(),
      ],
    );
  }

  @override
  Size get preferredSize {
    if (tabBar != null) {
      return const Size.fromHeight(kToolbarHeight + 60);
    }

    return const Size.fromHeight(kToolbarHeight);
  }
}

class _InfoIconButton extends StatelessWidget {
  const _InfoIconButton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: IconButton(
        onPressed: () {},
        icon: const Icon(Icons.info),
      ),
    );
  }
}
