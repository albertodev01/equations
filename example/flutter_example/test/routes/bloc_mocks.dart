import 'package:bloc_test/bloc_test.dart';
import 'package:equations_solver/blocs/nonlinear_solver/nonlinear_solver.dart';
import 'package:mocktail/mocktail.dart';

// ===== Nonlinear bloc mock class ===== //
class MockNonlinearBloc extends MockBloc<NonlinearEvent, NonlinearState>
    implements NonlinearBloc {}

class MockNonlinearEvent extends Fake implements NonlinearEvent {}

class MockNonlinearState extends Fake implements NonlinearState {}
