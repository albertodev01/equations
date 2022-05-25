import 'package:equations_solver/routes/models/dropdown_value/inherited_dropdown_value.dart';
import 'package:equations_solver/routes/models/number_switcher/inherited_number_switcher.dart';
import 'package:equations_solver/routes/models/number_switcher/number_switcher_state.dart';
import 'package:equations_solver/routes/models/system_text_controllers/inherited_system_controllers.dart';
import 'package:equations_solver/routes/models/system_text_controllers/system_text_controllers.dart';
import 'package:equations_solver/routes/system_page/model/inherited_system.dart';
import 'package:equations_solver/routes/system_page/model/system_state.dart';
import 'package:equations_solver/routes/system_page/system_body.dart';
import 'package:equations_solver/routes/system_page/utils/dropdown_selection.dart';
import 'package:flutter/material.dart';

import '../mock_wrapper.dart';

class MockSystemWidget extends StatefulWidget {
  final SystemType systemType;
  final Widget child;
  final String? dropdownValue;
  const MockSystemWidget({
    super.key,
    this.systemType = SystemType.rowReduction,
    this.child = const SystemBody(),
    this.dropdownValue,
  });

  @override
  State<MockSystemWidget> createState() => _MockSystemWidgetState();
}

class _MockSystemWidgetState extends State<MockSystemWidget> {
  final matrixControllers = List<TextEditingController>.generate(
    16,
    (_) => TextEditingController(),
    growable: false,
  );

  final vectorControllers = List<TextEditingController>.generate(
    4,
    (_) => TextEditingController(),
    growable: false,
  );

  final jacobiControllers = List<TextEditingController>.generate(
    4,
    (_) => TextEditingController(),
    growable: false,
  );

  final wSorController = TextEditingController();

  @override
  void dispose() {
    for (final controller in matrixControllers) {
      controller.dispose();
    }

    for (final controller in vectorControllers) {
      controller.dispose();
    }

    for (final controller in jacobiControllers) {
      controller.dispose();
    }

    wSorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MockWrapper(
      child: InheritedSystem(
        systemState: SystemState(widget.systemType),
        child: InheritedNumberSwitcher(
          numberSwitcherState: NumberSwitcherState(
            min: 1,
            max: 4,
          ),
          child: InheritedDropdownValue(
            dropdownValue: ValueNotifier<String>(
              widget.dropdownValue ?? SystemDropdownItems.lu.asString(),
            ),
            child: InheritedSystemControllers(
              systemTextControllers: SystemTextControllers(
                matrixControllers: matrixControllers,
                vectorControllers: vectorControllers,
                jacobiControllers: jacobiControllers,
                wSorController: wSorController,
              ),
              child: widget.child,
            ),
          ),
        ),
      ),
    );
  }
}
