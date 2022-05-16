// ignore_for_file: avoid_implementing_value_types

import 'package:bloc_test/bloc_test.dart';
import 'package:equations_solver/blocs/dropdown/dropdown.dart';
import 'package:equations_solver/blocs/integral_solver/integral_solver.dart';
import 'package:equations_solver/blocs/navigation_bar/navigation_bar.dart';
import 'package:equations_solver/blocs/nonlinear_solver/nonlinear_solver.dart';
import 'package:equations_solver/blocs/number_switcher/number_switcher.dart';
import 'package:equations_solver/blocs/other_solvers/other_solvers.dart';
import 'package:equations_solver/blocs/system_solver/system_solver.dart';
import 'package:mocktail/mocktail.dart';

// ===== Nonlinear bloc mock class ===== //
class MockNonlinearBloc extends MockBloc<NonlinearEvent, NonlinearState>
    implements NonlinearBloc {}

class MockNonlinearEvent extends Fake implements NonlinearEvent {}

class MockNonlinearState extends Fake implements NonlinearState {}

// ===== System bloc mock class ===== //
class MockSystemBloc extends MockBloc<SystemEvent, SystemState>
    implements SystemBloc {}

class MockSystemEvent extends Fake implements SystemEvent {}

class MockSystemState extends Fake implements SystemState {}

// ===== Integrals bloc mock class ===== //
class MockIntegralBloc extends MockBloc<IntegralEvent, IntegralState>
    implements IntegralBloc {}

class MockIntegralEvent extends Fake implements IntegralEvent {}

class MockIntegralState extends Fake implements IntegralState {}

// ===== Other bloc mock class ===== //
class MockOtherBloc extends MockBloc<OtherEvent, OtherState>
    implements OtherBloc {}

class MockOtherEvent extends Fake implements OtherEvent {}

class MockOtherState extends Fake implements OtherState {}

// ===== Dropdown cubit mock class ===== //
class MockDropdownCubit extends MockCubit<String> implements DropdownCubit {}

// ===== Navigation cubit mock class ===== //
class MockNavigationCubit extends MockCubit<int> implements NavigationCubit {}

// ===== Navigation cubit mock class ===== //
class MockNumberSwitcherCubit extends MockCubit<int>
    implements NumberSwitcherCubit {}
