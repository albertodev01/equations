import 'package:equations_solver/blocs/system_solver/bloc/bloc.dart';
import 'package:equations_solver/blocs/system_solver/models/system_types.dart';
import 'package:equations_solver/blocs/textfield_values/textfield_values.dart';
import 'package:equations_solver/routes/system_page/system_body.dart';
import 'package:equations_solver/routes/system_page/system_data_input.dart';
import 'package:equations_solver/routes/system_page/system_results.dart';
import 'package:equations_solver/routes/system_page/utils/dropdown_selection.dart';
import 'package:equations_solver/routes/utils/body_pages/go_back_button.dart';
import 'package:equations_solver/routes/utils/body_pages/page_title.dart';
import 'package:equations_solver/routes/utils/svg_images/types/sections_logos.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import '../mock_wrapper.dart';

void main() {
  group("Testing the 'SystemBody' widget", () {
    testWidgets('Making sure that the widget can be rendered', (tester) async {
      await tester.pumpWidget(MockWrapper(
        dropdownInitial: SystemDropdownItems.sor.asString(),
        child: BlocProvider<SystemBloc>(
          create: (_) => SystemBloc(SystemType.iterative),
          child: Scaffold(
            body: BlocProvider<TextFieldValuesCubit>(
              create: (_) => TextFieldValuesCubit(),
              child: const SystemBody(),
            ),
          ),
        ),
      ));

      expect(find.byType(GoBackButton), findsOneWidget);
      expect(find.byType(SystemDataInput), findsOneWidget);
      expect(find.byType(SystemResults), findsOneWidget);
      expect(find.byType(PageTitle), findsOneWidget);
      expect(find.byType(SystemsLogo), findsOneWidget);
    });
  });
}
