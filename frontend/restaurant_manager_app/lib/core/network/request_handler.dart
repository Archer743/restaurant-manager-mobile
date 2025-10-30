import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:restaurant_manager_app/core/constants/error_codes.dart';
import 'package:restaurant_manager_app/core/errors/exceptions.dart';
import 'package:restaurant_manager_app/core/errors/failure.dart';

/// A utility method to handle errors when making asynchronous requests to the server,
/// typically inside a repository method.
///
/// Wrap your API call in the [request] function to automatically handle
/// exceptions and convert them into a [Failure].
///
/// Returns:
/// - `Right<T>` if the request completes successfully.
/// - `Left<Failure>` if a known error occurs (e.g., network or server error).
Future<Either<Failure, T>> handleRequest<T>(
    Future<T> Function() originalRequest) async {
  try {
    final result = await originalRequest();
    return Right(result);
  } on DioException catch (e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.connectionError) {
      return Left(NetworkFailure());
    }

    final int? statusCode = e.response?.statusCode;
    final String? errorCode = e.response?.data['errorCode'];

    if (statusCode == null ||
        errorCode == null ||
        errorCode.isEmpty ||
        statusCode == HttpStatus.internalServerError ||
        statusCode == HttpStatus.serviceUnavailable) {
      return Left(UnknownFailure());
    }

    // Returned when refresh request failed
    if (errorCode == ErrorCodes.invalidSession) {
      return Left(InvalidSessionFailure());
    }

    return Left(ServerFailure(statusCode: statusCode, errorCode: errorCode));
  } on AuthTokenException {
    return Left(AuthTokenFailure());
  } catch (e) {
    // TODO: Add logger
    return Left(UnknownFailure());
  }
}
