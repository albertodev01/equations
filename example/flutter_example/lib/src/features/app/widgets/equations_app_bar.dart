import 'package:flutter/material.dart';

class EquationsAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  const EquationsAppBar({
    required this.title,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      actions: const [
        _InfoIconButton(),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
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
