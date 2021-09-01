import 'dart:math' as math;

import 'package:equations/equations.dart';
import 'package:equations/src/system/utils/matrix/decompositions/eigenvalue_decomposition/eigen_decomposition.dart';
import 'package:equations/src/utils/math_utils.dart';

/// Eigendecomposition, also known as spectral decomposition, is a decomposition
/// of a matrix A into a product `A = V x D x V^-1` where:
///
///   - V is a square matrix with the eigenvectors of A;
///   - D is a square matrix with the eigenvalues of A;
///   - V^-1 is the inverse of V.
///
/// This class performs the QR decomposition on [RealMatrix] types.
class EigendecompositionReal extends EigenDecomposition<double, RealMatrix>
    with MathUtils {
  /// Row and column dimension (square matrix).
  final int _n;

  /// Symmetry flag.
  final bool _isSymmetric;

  /// Arrays for internal storage of eigenvalues.
  final List<double> _d, _e;

  /// Array for internal storage of eigenvectors.
  final List<List<double>> _v;

  /// Array for internal storage of non-symmetric Hessenberg form.
  final List<List<double>> _h;

  /// Working storage for non-symmetric algorithm.
  final List<double> _ort;

  /// Requires the [realMatrix] matrix to be decomposed.
  EigendecompositionReal({
    required RealMatrix matrix,
  })  : _n = matrix.columnCount,
        _isSymmetric = matrix.isSymmetric(),
        _d = List<double>.generate(matrix.columnCount, (_) => 0.0),
        _e = List<double>.generate(matrix.columnCount, (_) => 0.0),
        _v = List<List<double>>.generate(matrix.columnCount,
            (_) => List<double>.generate(matrix.columnCount, (_) => 0.0)),
        _h = List<List<double>>.generate(matrix.columnCount,
            (_) => List<double>.generate(matrix.columnCount, (_) => 0.0)),
        _ort = List<double>.generate(matrix.columnCount, (_) => 0.0),
        super(matrix: matrix) {
    final source = matrix.toListOfList();

    if (_isSymmetric) {
      for (var i = 0; i < _n; i++) {
        for (var j = 0; j < _n; j++) {
          _v.set(i, j, source.get(i, j));
        }
      }

      // Tridiagonalize.
      _tred2();
      // Diagonalize.
      _tql2();
    } else {
      for (var j = 0; j < _n; j++) {
        for (var i = 0; i < _n; i++) {
          _h.set(i, j, source.get(i, j));
        }
      }

      // Reduce to Hessenberg form.
      _orthes();
      // Reduce Hessenberg to real Schur form.
      _hqr2();
    }
  }

  @override
  List<RealMatrix> decompose() {
    final data = List<List<double>>.generate(
      matrix.rowCount,
      (_) => List<double>.generate(
        matrix.columnCount,
        (_) => 0,
      ),
    );

    for (var i = 0; i < matrix.rowCount; ++i) {
      data[i][i] = _d[i];

      if (_e[i] > 0) {
        data[i][i + 1] = _e[i];
      } else if (_e[i] < 0) {
        data[i][i - 1] = _e[i];
      }
    }

    final Q = RealMatrix.fromData(
        rows: matrix.rowCount, columns: matrix.columnCount, data: data);
    // Returning Q and R
    return [
      RealMatrix.fromData(rows: _v.length, columns: _v[0].length, data: _v),
      Q,
      RealMatrix.fromData(rows: _v.length, columns: _v[0].length, data: _v)
          .inverse(),
    ];
  }

  // Symmetric Householder reduction to tridiagonal form.
  void _tred2() {
    //  This is derived from the Algol procedures tred2 by
    //  Bowdler, Martin, Reinsch, and Wilkinson, Handbook for
    //  Auto. Comp., Vol.ii-Linear Algebra, and the corresponding
    //  Fortran subroutine in EISPACK.

    for (var j = 0; j < _n; j++) {
      _d[j] = _v.get(_n - 1, j);
    }

    // Householder reduction to tridiagonal form.

    for (var i = _n - 1; i > 0; i--) {
      // Scale to avoid under/overflow.

      var scale = 0.0;
      var h = 0.0;
      for (var k = 0; k < i; k++) {
        scale = scale + _d[k].abs();
      }
      if (scale == 0.0) {
        _e[i] = _d[i - 1];
        for (var j = 0; j < i; j++) {
          _d[j] = _v.get(i - 1, j);
          _v.set(i, j, 0);
          _v.set(j, i, 0);
        }
      } else {
        // Generate Householder vector.

        for (var k = 0; k < i; k++) {
          _d[k] /= scale;
          h += _d[k] * _d[k];
        }
        var f = _d[i - 1];
        var g = math.sqrt(h);
        if (f > 0) {
          g = -g;
        }
        _e[i] = scale * g;
        h = h - f * g;
        _d[i - 1] = f - g;
        for (var j = 0; j < i; j++) {
          _e[j] = 0.0;
        }

        // Apply similarity transformation to remaining columns.

        for (var j = 0; j < i; j++) {
          f = _d[j];
          _v.set(j, i, f);
          g = _e[j] + _v.get(j, j) * f;
          for (var k = j + 1; k <= i - 1; k++) {
            g += _v.get(k, j) * _d[k];
            _e[k] += _v.get(k, j) * f;
          }
          _e[j] = g;
        }
        f = 0.0;
        for (var j = 0; j < i; j++) {
          _e[j] /= h;
          f += _e[j] * _d[j];
        }
        final hh = f / (h + h);
        for (var j = 0; j < i; j++) {
          _e[j] -= hh * _d[j];
        }
        for (var j = 0; j < i; j++) {
          f = _d[j];
          g = _e[j];
          for (var k = j; k <= i - 1; k++) {
            _v.set(k, j, _v.get(k, j) - (f * _e[k] + g * _d[k]));
          }
          _d[j] = _v.get(i - 1, j);
          _v.set(i, j, 0);
        }
      }
      _d[i] = h;
    }

    // Accumulate transformations.

    for (var i = 0; i < _n - 1; i++) {
      _v.set(_n - 1, i, _v.get(i, i));
      _v.set(i, i, 1);
      final h = _d[i + 1];
      if (h != 0.0) {
        for (var k = 0; k <= i; k++) {
          _d[k] = _v.get(k, i + 1) / h;
        }
        for (var j = 0; j <= i; j++) {
          var g = 0.0;
          for (var k = 0; k <= i; k++) {
            g += _v.get(k, i + 1) * _v.get(k, j);
          }
          for (var k = 0; k <= i; k++) {
            _v.set(k, j, _v.get(k, j) - g * _d[k]);
          }
        }
      }
      for (var k = 0; k <= i; k++) {
        _v.set(k, i + 1, 0);
      }
    }
    for (var j = 0; j < _n; j++) {
      _d[j] = _v.get(_n - 1, j);
      _v.set(_n - 1, j, 0);
    }
    _v.set(_n - 1, _n - 1, 1);
    _e[0] = 0.0;
  }

  // Symmetric tridiagonal QL algorithm.

  void _tql2() {
    //  This is derived from the Algol procedures tql2, by
    //  Bowdler, Martin, Reinsch, and Wilkinson, Handbook for
    //  Auto. Comp., Vol.ii-Linear Algebra, and the corresponding
    //  Fortran subroutine in EISPACK.

    for (var i = 1; i < _n; i++) {
      _e[i - 1] = _e[i];
    }
    _e[_n - 1] = 0.0;

    var f = 0.0;
    var tst1 = 0.0;
    final eps = math.pow(2.0, -52.0);
    for (var l = 0; l < _n; l++) {
      // Find small subdiagonal element

      tst1 = math.max(tst1, _d[l].abs() + _e[l].abs());
      var m = l;
      while (m < _n) {
        if (_e[m].abs() <= eps * tst1) {
          break;
        }
        m++;
      }

      // If m == l, d[l] is an eigenvalue,
      // otherwise, iterate.

      if (m > l) {
        var iter = 0;
        do {
          iter = iter + 1; // (Could check iteration count here.)

          // Compute implicit shift

          var g = _d[l];
          var p = (_d[l + 1] - g) / (2.0 * _e[l]);
          var r = hypot(p, 1.0);
          if (p < 0) {
            r = -r;
          }
          _d[l] = _e[l] / (p + r);
          _d[l + 1] = _e[l] * (p + r);
          final dl1 = _d[l + 1];
          var h = g - _d[l];
          for (var i = l + 2; i < _n; i++) {
            _d[i] -= h;
          }
          f = f + h;

          // Implicit QL transformation.

          p = _d[m];
          var c = 1.0;
          var c2 = c;
          var c3 = c;
          final el1 = _e[l + 1];
          var s = 0.0;
          var s2 = 0.0;
          for (var i = m - 1; i >= l; i--) {
            c3 = c2;
            c2 = c;
            s2 = s;
            g = c * _e[i];
            h = c * p;
            r = hypot(p, _e[i]);
            _e[i + 1] = s * r;
            s = _e[i] / r;
            c = p / r;
            p = c * _d[i] - s * g;
            _d[i + 1] = h + s * (c * g + s * _d[i]);

            // Accumulate transformation.

            for (var k = 0; k < _n; k++) {
              h = _v.get(k, i + 1);
              _v.set(k, i + 1, s * _v.get(k, i) + c * h);
              _v.set(k, i, c * _v.get(k, i) - s * h);
            }
          }
          p = -s * s2 * c3 * el1 * _e[l] / dl1;
          _e[l] = s * p;
          _d[l] = c * p;

          // Check for convergence.

        } while (_e[l].abs() > eps * tst1);
      }
      _d[l] = _d[l] + f;
      _e[l] = 0.0;
    }

    // Sort eigenvalues and corresponding vectors.

    for (var i = 0; i < _n - 1; i++) {
      var k = i;
      var p = _d[i];
      for (var j = i + 1; j < _n; j++) {
        if (_d[j] < p) {
          k = j;
          p = _d[j];
        }
      }
      if (k != i) {
        _d[k] = _d[i];
        _d[i] = p;
        for (var j = 0; j < _n; j++) {
          p = _v.get(j, i);
          _v.set(j, i, _v.get(j, k));
          _v.set(j, k, p);
        }
      }
    }
  }

  // Nonsymmetric reduction to Hessenberg form.

  void _orthes() {
    //  This is derived from the Algol procedures orthes and ortran,
    //  by Martin and Wilkinson, Handbook for Auto. Comp.,
    //  Vol.ii-Linear Algebra, and the corresponding
    //  Fortran subroutines in EISPACK.

    final high = _n - 1;

    for (var m = 1; m <= high - 1; m++) {
      // Scale column.

      var scale = 0.0;
      for (var i = m; i <= high; i++) {
        scale = scale + _h.get(i, m - 1).abs();
      }
      if (scale != 0.0) {
        // Compute Householder transformation.

        var h = 0.0;
        for (var i = high; i >= m; i--) {
          _ort[i] = _h.get(i, m - 1) / scale;
          h += _ort[i] * _ort[i];
        }
        var g = math.sqrt(h);
        if (_ort[m] > 0) {
          g = -g;
        }
        h = h - _ort[m] * g;
        _ort[m] = _ort[m] - g;

        // Apply Householder similarity transformation
        // H = (I-u*u'/h)*H*(I-u*u')/h)

        for (var j = m; j < _n; j++) {
          var f = 0.0;
          for (var i = high; i >= m; i--) {
            f += _ort[i] * _h.get(i, j);
          }
          f = f / h;
          for (var i = m; i <= high; i++) {
            _h.set(i, j, _h.get(i, j) - f * _ort[i]);
          }
        }

        for (var i = 0; i <= high; i++) {
          var f = 0.0;
          for (var j = high; j >= m; j--) {
            f += _ort[j] * _h.get(i, j);
          }
          f = f / h;
          for (var j = m; j <= high; j++) {
            _h.set(i, j, _h.get(i, j) - f * _ort[j]);
          }
        }
        _ort[m] = scale * _ort[m];
        _h.set(m, m - 1, scale * g);
      }
    }

    // Accumulate transformations (Algol's ortran).

    for (var i = 0; i < _n; i++) {
      for (var j = 0; j < _n; j++) {
        _v.set(i, j, i == j ? 1.0 : 0.0);
      }
    }

    for (var m = high - 1; m >= 1; m--) {
      if (_h.get(m, m - 1) != 0.0) {
        for (var i = m + 1; i <= high; i++) {
          _ort[i] = _h.get(i, m - 1);
        }
        for (var j = m; j <= high; j++) {
          var g = 0.0;
          for (var i = m; i <= high; i++) {
            g += _ort[i] * _v.get(i, j);
          }
          // Double division avoids possible underflow
          g = (g / _ort[m]) / _h.get(m, m - 1);
          for (var i = m; i <= high; i++) {
            _v.set(i, j, _v.get(i, j) + g * _ort[i]);
          }
        }
      }
    }
  }

  // Complex scalar division.
  double _cdivr = 0, _cdivi = 0;

  void _cdiv(double xr, double xi, double yr, double yi) {
    if (yr.abs() > yi.abs()) {
      final r = yi / yr;
      final d = yr + r * yi;
      _cdivr = (xr + r * xi) / d;
      _cdivi = (xi - r * xr) / d;
    } else {
      final r = yr / yi;
      final d = yi + r * yr;
      _cdivr = (r * xr + xi) / d;
      _cdivi = (r * xi - xr) / d;
    }
  }

  // Nonsymmetric reduction from Hessenberg to real Schur form.

  void _hqr2() {
    //  This is derived from the Algol procedure hqr2,
    //  by Martin and Wilkinson, Handbook for Auto. Comp.,
    //  Vol.ii-Linear Algebra, and the corresponding
    //  Fortran subroutine in EISPACK.

    // Initialize

    final nn = _n;
    var n = nn - 1;
    const low = 0;
    final high = nn - 1;
    final eps = math.pow(2.0, -52.0);
    var exshift = 0.0;
    var p = 0.0,
        q = 0.0,
        r = 0.0,
        s = 0.0,
        z = 0.0,
        t = 0.0,
        w = 0.0,
        x = 0.0,
        y = 0.0;

    // Store roots isolated by balanc and compute matrix norm

    var norm = 0.0;
    for (var i = 0; i < nn; i++) {
      if (i < low || i > high) {
        _d[i] = _h.get(i, i);
        _e[i] = 0.0;
      }
      for (var j = math.max(i - 1, 0); j < nn; j++) {
        norm = norm + _h.get(i, j).abs();
      }
    }

    // Outer loop over eigenvalue index

    var iter = 0;
    while (n >= low) {
      // Look for single small sub-diagonal element

      var l = n;
      while (l > low) {
        s = _h.get(l - 1, l - 1).abs() + _h.get(l, l).abs();
        if (s == 0.0) {
          s = norm;
        }
        if (_h.get(l, l - 1).abs() < eps * s) {
          break;
        }
        l--;
      }

      // Check for convergence
      // One root found

      if (l == n) {
        _h.set(n, n, _h.get(n, n) + exshift);
        _d[n] = _h.get(n, n);
        _e[n] = 0.0;
        n--;
        iter = 0;

        // Two roots found

      } else if (l == n - 1) {
        w = _h.get(n, n - 1) * _h.get(n - 1, n);
        p = (_h.get(n - 1, n - 1) - _h.get(n, n)) / 2.0;
        q = p * p + w;
        z = math.sqrt(q.abs());
        _h.set(n, n, _h.get(n, n) + exshift);
        _h.set(n - 1, n - 1, _h.get(n - 1, n - 1) + exshift);
        x = _h.get(n, n);

        // Real pair

        if (q >= 0) {
          if (p >= 0) {
            z = p + z;
          } else {
            z = p - z;
          }
          _d[n - 1] = x + z;
          _d[n] = _d[n - 1];
          if (z != 0.0) {
            _d[n] = x - w / z;
          }
          _e[n - 1] = 0.0;
          _e[n] = 0.0;
          x = _h.get(n, n - 1);
          s = x.abs() + z.abs();
          p = x / s;
          q = z / s;
          r = math.sqrt(p * p + q * q);
          p = p / r;
          q = q / r;

          // Row modification

          for (var j = n - 1; j < nn; j++) {
            z = _h.get(n - 1, j);
            _h.set(n - 1, j, q * z + p * _h.get(n, j));
            _h.set(n, j, q * _h.get(n, j) - p * z);
          }

          // Column modification

          for (var i = 0; i <= n; i++) {
            z = _h.get(i, n - 1);
            _h.set(i, n - 1, q * z + p * _h.get(i, n));
            _h.set(i, n, q * _h.get(i, n) - p * z);
          }

          // Accumulate transformations

          for (var i = low; i <= high; i++) {
            z = _v.get(i, n - 1);
            _v.set(i, n - 1, q * z + p * _v.get(i, n));
            _v.set(i, n, q * _v.get(i, n) - p * z);
          }

          // Complex pair

        } else {
          _d[n - 1] = x + p;
          _d[n] = x + p;
          _e[n - 1] = z;
          _e[n] = -z;
        }
        n = n - 2;
        iter = 0;

        // No convergence yet

      } else {
        // Form shift

        x = _h.get(n, n);
        y = 0.0;
        w = 0.0;
        if (l < n) {
          y = _h.get(n - 1, n - 1);
          w = _h.get(n, n - 1) * _h.get(n - 1, n);
        }

        // Wilkinson's original ad hoc shift

        if (iter == 10) {
          exshift += x;
          for (var i = low; i <= n; i++) {
            _h.set(i, i, _h.get(i, i) - x);
          }
          s = _h.get(n, n - 1).abs() + _h.get(n - 1, n - 2).abs();
          x = y = 0.75 * s;
          w = -0.4375 * s * s;
        }

        // MATLAB's new ad hoc shift

        if (iter == 30) {
          s = (y - x) / 2.0;
          s = s * s + w;
          if (s > 0) {
            s = math.sqrt(s);
            if (y < x) {
              s = -s;
            }
            s = x - w / ((y - x) / 2.0 + s);
            for (var i = low; i <= n; i++) {
              _h.set(i, i, _h.get(i, i) - s);
            }
            exshift += s;
            x = y = w = 0.964;
          }
        }

        iter = iter + 1; // (Could check iteration count here.)

        // Look for two consecutive small sub-diagonal elements

        var m = n - 2;
        while (m >= l) {
          z = _h.get(m, m);
          r = x - z;
          s = y - z;
          p = (r * s - w) / _h.get(m + 1, m) + _h.get(m, m + 1);
          q = _h.get(m + 1, m + 1) - z - r - s;
          r = _h.get(m + 2, m + 1);
          s = p.abs() + q.abs() + r.abs();
          p = p / s;
          q = q / s;
          r = r / s;
          if (m == l) {
            break;
          }
          if (_h.get(m, m - 1).abs() * (q.abs() + r.abs()) <
              eps *
                  (p.abs() *
                      (_h.get(m - 1, m - 1).abs() +
                          z.abs() +
                          _h.get(m + 1, m + 1).abs()))) {
            break;
          }
          m--;
        }

        for (var i = m + 2; i <= n; i++) {
          _h.set(i, i - 2, 0);
          if (i > m + 2) {
            _h.set(i, i - 3, 0);
          }
        }

        // Double QR step involving rows l:n and columns m:n

        for (var k = m; k <= n - 1; k++) {
          final notlast = k != n - 1;
          if (k != m) {
            p = _h.get(k, k - 1);
            q = _h.get(k + 1, k - 1);
            r = notlast ? _h.get(k + 2, k - 1) : 0.0;
            x = p.abs() + q.abs() + r.abs();
            if (x == 0.0) {
              continue;
            }
            p = p / x;
            q = q / x;
            r = r / x;
          }

          s = math.sqrt(p * p + q * q + r * r);
          if (p < 0) {
            s = -s;
          }
          if (s != 0) {
            if (k != m) {
              _h.set(k, k - 1, -s * x);
            } else if (l != m) {
              _h.set(k, k - 1, -_h.get(k, k - 1));
            }
            p = p + s;
            x = p / s;
            y = q / s;
            z = r / s;
            q = q / p;
            r = r / p;

            // Row modification

            for (var j = k; j < nn; j++) {
              p = _h.get(k, j) + q * _h.get(k + 1, j);
              if (notlast) {
                p = p + r * _h.get(k + 2, j);
                _h.set(k + 2, j, _h.get(k + 2, j) - p * z);
              }
              _h.set(k, j, _h.get(k, j) - p * x);
              _h.set(k + 1, j, _h.get(k + 1, j) - p * y);
            }

            // Column modification

            for (var i = 0; i <= math.min(n, k + 3); i++) {
              p = x * _h.get(i, k) + y * _h.get(i, k + 1);
              if (notlast) {
                p = p + z * _h.get(i, k + 2);
                _h.set(i, k + 2, _h.get(i, k + 2) - p * r);
              }
              _h.set(i, k, _h.get(i, k) - p);
              _h.set(i, k + 1, _h.get(i, k + 1) - p * q);
            }

            // Accumulate transformations

            for (var i = low; i <= high; i++) {
              p = x * _v.get(i, k) + y * _v.get(i, k + 1);
              if (notlast) {
                p = p + z * _v.get(i, k + 2);
                _v.set(i, k + 2, _v.get(i, k + 2) - p * r);
              }
              _v.set(i, k, _v.get(i, k) - p);
              _v.set(i, k + 1, _v.get(i, k + 1) - p * q);
            }
          } // (s != 0)
        } // k loop
      } // check convergence
    } // while (n >= low)

    // Backsubstitute to find vectors of upper triangular form

    if (norm == 0.0) {
      return;
    }

    for (n = nn - 1; n >= 0; n--) {
      p = _d[n];
      q = _e[n];

      // Real vector

      if (q == 0) {
        var l = n;
        _h.set(n, n, 1);
        for (var i = n - 1; i >= 0; i--) {
          w = _h.get(i, i) - p;
          r = 0.0;
          for (var j = l; j <= n; j++) {
            r = r + _h.get(i, j) * _h.get(j, n);
          }
          if (_e[i] < 0.0) {
            z = w;
            s = r;
          } else {
            l = i;
            if (_e[i] == 0.0) {
              if (w != 0.0) {
                _h.set(i, n, -r / w);
              } else {
                _h.set(i, n, -r / (eps * norm));
              }

              // Solve real equations

            } else {
              x = _h.get(i, i + 1);
              y = _h.get(i + 1, i);
              q = (_d[i] - p) * (_d[i] - p) + _e[i] * _e[i];
              t = (x * s - z * r) / q;
              _h.set(i, n, t);
              if (x.abs() > z.abs()) {
                _h.set(i + 1, n, (-r - w * t) / x);
              } else {
                _h.set(i + 1, n, (-s - y * t) / z);
              }
            }

            // Overflow control

            t = _h.get(i, n).abs();
            if ((eps * t) * t > 1) {
              for (var j = i; j <= n; j++) {
                _h.set(j, n, _h.get(j, n) / t);
              }
            }
          }
        }

        // Complex vector

      } else if (q < 0) {
        var l = n - 1;

        // Last vector component imaginary so matrix is triangular

        if (_h.get(n, n - 1).abs() > _h.get(n - 1, n).abs()) {
          _h.set(n - 1, n - 1, q / _h.get(n, n - 1));
          _h.set(n - 1, n, -(_h.get(n, n) - p) / _h.get(n, n - 1));
        } else {
          _cdiv(0, -_h.get(n - 1, n), _h.get(n - 1, n - 1) - p, q);
          _h.set(n - 1, n - 1, _cdivr);
          _h.set(n - 1, n, _cdivi);
        }
        _h.set(n, n - 1, 0);
        _h.set(n, n, 1);
        for (var i = n - 2; i >= 0; i--) {
          var ra = 0.0, sa = 0.0, vr = 0.0, vi = 0.0;
          ra = 0.0;
          sa = 0.0;
          for (var j = l; j <= n; j++) {
            ra = ra + _h.get(i, j) * _h.get(j, n - 1);
            sa = sa + _h.get(i, j) * _h.get(j, n);
          }
          w = _h.get(i, i) - p;

          if (_e[i] < 0.0) {
            z = w;
            r = ra;
            s = sa;
          } else {
            l = i;
            if (_e[i] == 0) {
              _cdiv(-ra, -sa, w, q);
              _h.set(i, n - 1, _cdivr);
              _h.set(i, n, _cdivi);
            } else {
              // Solve complex equations

              x = _h.get(i, i + 1);
              y = _h.get(i + 1, i);
              vr = (_d[i] - p) * (_d[i] - p) + _e[i] * _e[i] - q * q;
              vi = (_d[i] - p) * 2.0 * q;
              if (vr == 0.0 && vi == 0.0) {
                vr = eps *
                    norm *
                    (w.abs() + q.abs() + x.abs() + y.abs() + z.abs());
              }
              _cdiv(x * r - z * ra + q * sa, x * s - z * sa - q * ra, vr, vi);
              _h.set(i, n - 1, _cdivr);
              _h.set(i, n, _cdivi);
              if (x.abs() > (z.abs() + q.abs())) {
                _h.set(i + 1, n - 1,
                    (-ra - w * _h.get(i, n - 1) + q * _h.get(i, n)) / x);
                _h.set(i + 1, n,
                    (-sa - w * _h.get(i, n) - q * _h.get(i, n - 1)) / x);
              } else {
                _cdiv(-r - y * _h.get(i, n - 1), -s - y * _h.get(i, n), z, q);
                _h.set(i + 1, n - 1, _cdivr);
                _h.set(i + 1, n, _cdivi);
              }
            }

            // Overflow control

            t = math.max(_h.get(i, n - 1).abs(), _h.get(i, n).abs());
            if ((eps * t) * t > 1) {
              for (var j = i; j <= n; j++) {
                _h.set(j, n - 1, _h.get(j, n - 1) / t);
                _h.set(j, n, _h.get(j, n) / t);
              }
            }
          }
        }
      }
    }

    // Vectors of isolated roots

    for (var i = 0; i < nn; i++) {
      if (i < low || i > high) {
        for (var j = i; j < nn; j++) {
          _v.set(i, j, _h.get(i, j));
        }
      }
    }

    // Back transformation to get eigenvectors of original matrix

    for (var j = nn - 1; j >= low; j--) {
      for (var i = low; i <= high; i++) {
        z = 0.0;
        for (var k = low; k <= math.min(j, high); k++) {
          z = z + _v.get(i, k) * _h.get(k, j);
        }
        _v.set(i, j, z);
      }
    }
  }
}

/// Extension method on `List<List<double>>` with two shortcuts to read and write
/// the contents of a list of lists.
extension _EigenHelper on List<List<double>> {
  /// Reads the data at the given ([row]; [col]) position.
  double get(int row, int col) {
    return this[row][col];
  }

  /// Writes the given [value] in the ([row]; [col]) position.
  void set(int row, int col, double value) {
    this[row][col] = value;
  }
}
