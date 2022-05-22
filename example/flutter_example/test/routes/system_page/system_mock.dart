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

Widget mockSystemWidget({
  SystemType systemType = SystemType.rowReduction,
  Widget child = const SystemBody(),
  String? dropdownValue,
}) {
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
  return MockWrapper(
    child: InheritedSystem(
      systemState: SystemState(systemType),
      child: InheritedNumberSwitcher(
        numberSwitcherState: NumberSwitcherState(
          min: 1,
          max: 4,
        ),
        child: InheritedDropdownValue(
          dropdownValue: ValueNotifier<String>(
            dropdownValue ?? SystemDropdownItems.lu.asString(),
          ),
          child: InheritedSystemControllers(
            systemTextControllers: SystemTextControllers(
              matrixControllers: matrixControllers,
              vectorControllers: vectorControllers,
              jacobiControllers: jacobiControllers,
              wSorController: wSorController,
            ),
            child: child,
          ),
        ),
      ),
    ),
  );
}
