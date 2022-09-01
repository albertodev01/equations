import 'package:equations_solver/localization/localization.dart';
import 'package:equations_solver/routes/nonlinear_page/model/inherited_nonlinear.dart';
import 'package:equations_solver/routes/nonlinear_page/model/nonlinear_state.dart';
import 'package:equations_solver/routes/nonlinear_page/nonlinear_body.dart';
import 'package:flutter/material.dart';

/// Mixin for [NonlinearBody] widgets that helps localizing the page title.
mixin NonlinearTitleLocalizer on StatelessWidget {
  /// Localizes the title of a nonlinear tab.
  String getLocalizedName(BuildContext context) {
    final nonlinearType = context.nonlinearState.nonlinearType;

    return nonlinearType == NonlinearType.singlePoint
        ? context.l10n.single_point
        : context.l10n.bracketing;
  }
}
