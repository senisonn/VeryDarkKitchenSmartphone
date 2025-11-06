import 'package:dartz/dartz.dart';
import 'package:restaurant_reservation/shared/models/failure.dart';

/// Type alias for Result type using Either from dartz.
///
/// Left = Failure, Right = Success value
/// This makes our code more readable and follows functional programming principles.
typedef Result<T> = Either<Failure, T>;

/// Extension methods for Result type.
extension ResultExtensions<T> on Result<T> {
  /// Returns true if the result is a success (Right).
  bool get isSuccess => isRight();

  /// Returns true if the result is a failure (Left).
  bool get isFailure => isLeft();

  /// Gets the success value or null if failure.
  T? get valueOrNull => fold(
        (l) => null,
        (r) => r,
      );

  /// Gets the failure or null if success.
  Failure? get failureOrNull => fold(
        (l) => l,
        (r) => null,
      );

  /// Maps the success value to another type.
  Result<R> mapValue<R>(R Function(T) mapper) {
    return map((value) => mapper(value));
  }

  /// Executes one of the callbacks based on success/failure.
  R when<R>({
    required R Function(Failure) failure,
    required R Function(T) success,
  }) {
    return fold(failure, success);
  }

  /// Executes callback only on success.
  void onSuccess(void Function(T) callback) {
    fold(
      (l) => null,
      (r) {
        callback(r);
        return r;
      },
    );
  }

  /// Executes callback only on failure.
  void onFailure(void Function(Failure) callback) {
    fold(
      (l) {
        callback(l);
        return l;
      },
      (r) => null,
    );
  }
}

/// Helper methods to create Result instances.
class ResultHelper {
  ResultHelper._();

  /// Creates a success Result.
  static Result<T> success<T>(T value) {
    return Right(value);
  }

  /// Creates a failure Result.
  static Result<T> failure<T>(Failure failure) {
    return Left(failure);
  }

  /// Wraps a function that might throw into a Result.
  static Result<T> tryCatch<T>(
    T Function() function, {
    Failure Function(dynamic)? onError,
  }) {
    try {
      return Right(function());
    } catch (e) {
      final failure = onError?.call(e) ?? FailureConverter.fromException(e);
      return Left(failure);
    }
  }

  /// Wraps an async function that might throw into a Result.
  static Future<Result<T>> tryCatchAsync<T>(
    Future<T> Function() function, {
    Failure Function(dynamic)? onError,
  }) async {
    try {
      final value = await function();
      return Right(value);
    } catch (e) {
      final failure = onError?.call(e) ?? FailureConverter.fromException(e);
      return Left(failure);
    }
  }

  /// Combines multiple Results into a single Result containing a list.
  static Result<List<T>> combine<T>(List<Result<T>> results) {
    final values = <T>[];
    for (final result in results) {
      final value = result.fold(
        (failure) => failure,
        (success) {
          values.add(success);
          return success;
        },
      );
      if (value is Failure) {
        return Left(value);
      }
    }
    return Right(values);
  }

  /// Executes functions sequentially, stopping at first failure.
  static Future<Result<List<T>>> sequence<T>(
    List<Future<Result<T>> Function()> functions,
  ) async {
    final values = <T>[];
    for (final function in functions) {
      final result = await function();
      final value = result.fold(
        (failure) => failure,
        (success) {
          values.add(success);
          return success;
        },
      );
      if (value is Failure) {
        return Left(value);
      }
    }
    return Right(values);
  }
}
