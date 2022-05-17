import 'package:equations_solver/routes/other_page/model/analyzer/result_wrapper.dart';

class OtherResult<T extends ResultWrapper> {
  final ResultWrapper? results;

  /// Creates a [OtherResult] object.
  const OtherResult({
    this.results,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    if (other is OtherResult) {
      return runtimeType == other.runtimeType && results == other.results;
    } else {
      return false;
    }
  }

  @override
  int get hashCode => Object.hashAll([results]);
}
