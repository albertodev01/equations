import 'package:equations_solver/src/features/app/models/svg_assets.dart';
import 'package:equations_solver/src/features/app/routes/routes.dart';
import 'package:equations_solver/src/localization/localization.dart';
import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

class EquationsDrawer extends StatelessWidget {
  const EquationsDrawer({super.key});

  void _goTo({
    required BuildContext context,
    required String path,
  }) {
    Scaffold.of(context).closeDrawer();
    context.push(path);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const _Header(),
          const SizedBox(height: 4),
          ListTile(
            leading: const Icon(Icons.home),
            title: Text(context.l10n.solvers),
            subtitle: Text(context.l10n.solversSubtitle),
            onTap: () => _goTo(context: context, path: homeRoute),
          ),
          const SizedBox(height: 8),
          ListTile(
            leading: const Icon(Icons.functions),
            title: Text(context.l10n.integrals),
            subtitle: Text(context.l10n.integralsSubtitle),
            onTap: () => _goTo(context: context, path: integralsRoute),
          ),
          const SizedBox(height: 8),
          ListTile(
            leading: const Icon(Icons.grid_on),
            title: Text(context.l10n.matrices),
            subtitle: Text(context.l10n.matricesSubtitle),
            onTap: () => _goTo(context: context, path: matricesRoute),
          ),
          const SizedBox(height: 8),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text(context.l10n.complexNumbers),
            subtitle: Text(context.l10n.complexNumberSubtitle),
            onTap: () => _goTo(context: context, path: complexNumbersRoute),
          ),
          const SizedBox(height: 8),
          ListTile(
            leading: const Icon(Icons.graphic_eq),
            title: Text(context.l10n.interpolation),
            subtitle: Text(context.l10n.interpolation),
            onTap: () => _goTo(context: context, path: interpolationRoute),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return DrawerHeader(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: const SvgAssetWidget.logo(
              width: 60,
              height: 60,
            ),
          ),
          Text(context.l10n.title),
        ],
      ),
    );
  }
}
