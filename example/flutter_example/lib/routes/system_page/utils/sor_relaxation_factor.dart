import 'package:equations_solver/blocs/dropdown/dropdown.dart';
import 'package:equations_solver/localization/localization.dart';
import 'package:equations_solver/routes/system_page/system_input_field.dart';
import 'package:equations_solver/routes/system_page/utils/dropdown_selection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// This very simple widget allows the input of the relaxation factor `w` of the
/// SOR system solving algorithm.
class RelaxationFactorInput extends StatefulWidget {
  /// The text controller
  final TextEditingController textEditingController;

  /// Creates a [RelaxationFactorInput] widget.
  const RelaxationFactorInput({
    Key? key,
    required this.textEditingController,
  }) : super(key: key);

  @override
  _RelaxationFactorInputState createState() => _RelaxationFactorInputState();
}

class _RelaxationFactorInputState extends State<RelaxationFactorInput> {
  /// Caching the input widget
  late final inputWidget = Padding(
    padding: const EdgeInsets.only(
      top: 35,
      bottom: 10,
    ),
    child: Column(
      children: [
        // Input
        SystemInputField(
          controller: widget.textEditingController,
          placeholder: 'w',
        ),

        // Some spacing
        const SizedBox(height: 15),

        // A label that describes what 'w' is
        Text(
          context.l10n.sor_w,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Center(
      child: BlocBuilder<DropdownCubit, String>(
        builder: (context, state) {
          if (state.toLowerCase() == SystemDropdownItems.sor.asString()) {
            return inputWidget;
          }

          // Nothing is displayed if the chosen method isn't SOR
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
