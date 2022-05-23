import 'package:equations_solver/routes/other_page/model/analyzer/result_wrapper.dart';

/// Wrapper class that holds the [ResultWrapper] type computed by [OtherState].
class OtherResult<T extends ResultWrapper> {
  /// The [ResultWrapper] object holding the data.
  ///
  /// When `null`, it means that there has been a computational error.
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
  int get hashCode => results.hashCode;
}
