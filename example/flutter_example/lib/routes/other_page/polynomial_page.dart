import 'package:equations_solver/routes/utils/body_pages/go_back_button.dart';
import 'package:flutter/material.dart';

/// This widget analyzes a matrix and outputs various results about its rank,
/// determinant, eigenvalues and much more.
class PolynomialOtherBody extends StatelessWidget {
  /// Creates a [MatrixBody] widget.
  const PolynomialOtherBody({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: const [
        // Scrollable contents of the page
        Positioned.fill(
          child: _PageBody(),
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

/// The actual contents of the [PolynomialOtherBody] widget.
class _PageBody extends StatelessWidget {
  /// Creates a [_PageBody] widget.
  const _PageBody({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('polynomial body'),
    );
  }
}
