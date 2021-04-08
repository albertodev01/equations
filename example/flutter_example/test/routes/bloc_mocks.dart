import 'package:bloc_test/bloc_test.dart';
import 'package:equations_solver/blocs/dropdown/dropdown.dart';
import 'package:equations_solver/blocs/nonlinear_solver/nonlinear_solver.dart';
import 'package:equations_solver/blocs/polynomial_solver/polynomial_solver.dart';

class MockDropdownCubit extends MockCubit<String> implements DropdownCubit {}

class MockPolynomialBloc extends MockBloc<PolynomialEvent, PolynomialState>
    implements PolynomialBloc {}

class MockNonlinearBloc extends MockBloc<NonlinearEvent, NonlinearState>
    implements NonlinearBloc {}
