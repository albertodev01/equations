import 'package:equations_solver/localization/localization.dart';
import 'package:equations_solver/routes/system_page/model/inherited_system.dart';
import 'package:equations_solver/routes/system_page/model/system_state.dart';
import 'package:equations_solver/routes/system_page/system_data_input.dart';
import 'package:equations_solver/routes/system_page/system_results.dart';
import 'package:equations_solver/routes/utils/body_pages/go_back_button.dart';
import 'package:equations_solver/routes/utils/body_pages/page_title.dart';
import 'package:equations_solver/routes/utils/svg_images/types/sections_logos.dart';
import 'package:flutter/material.dart';

/// This widget contains the input for a matrix and the known values vector to
/// solve systems of linear equations.
class SystemBody extends StatelessWidget {
  /// Creates a [SystemBody] widget.
  const SystemBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: const [
        // Scrollable contents of the page
        Positioned.fill(
          child: _SystemBodyContents(),
        ),

        // "Go back" button
        Positioned(
          top: 20,
          left: 20,
          child: GoBackButton(),
        ),
      ],
    );
  }
}

/// Determines whether the contents should appear in 1 or 2 columns.
class _SystemBodyContents extends StatefulWidget {
  /// Creates a [_SystemBodyContents] widget.
  const _SystemBodyContents();

  @override
  __SystemBodyContentsState createState() => __SystemBodyContentsState();
}

class __SystemBodyContentsState extends State<_SystemBodyContents> {
  /// Manually caching the page title.
  late final Widget pageTitleWidget = PageTitle(
    pageTitle: localizedName,
    pageLogo: const SystemsLogo(
      size: 50,
    ),
  );

  /// Getting the title of the page according with the kind of algorithms that
  /// are going to be used.
  String get localizedName {
    final systemType = context.systemState.systemType;

    switch (systemType) {
      case SystemType.rowReduction:
        return context.l10n.row_reduction;
      case SystemType.factorization:
        return context.l10n.factorization;
      case SystemType.iterative:
        return context.l10n.iterative;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          pageTitleWidget,

          // Data input
          const SystemDataInput(),

          // Results
          const SystemResults(),
        ],
      ),
    );
  }
}
