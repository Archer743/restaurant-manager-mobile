import 'package:flutter/material.dart';
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:restaurant_manager_app/core/constants/error_codes.dart';
import 'package:restaurant_manager_app/core/data/data_sources/local/token_storage_service.dart';
import 'package:restaurant_manager_app/core/domain/repository/auth_shared_repository.dart';
import 'package:restaurant_manager_app/core/errors/exceptions.dart';
import 'package:restaurant_manager_app/core/errors/failure.dart';

// This function acts as a wrapper for API calls requiring authentication.
Future<Either<Failure, T>> handleAuthRequest<T>(
    TokenStorageService tokenService,
    AuthSharedRepository authSharedRepo,
    Future<T> Function(String authorization) originalRequest,
    {bool isRetry = false} // Flag to track if this is a retry attempt
    ) async {
  try {
    // 1. Get Access Token
    final String? accessToken = await tokenService.getAccessToken();

    if (accessToken == null || accessToken.isEmpty) {
      return Left(AuthTokenFailure());
    }

    final String authorization = "Bearer $accessToken";

    // 2. Execute the original request
    final result = await originalRequest(authorization);
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
        statusCode == HttpStatus.internalServerError) {
      return Left(UnknownFailure());
    }

    // 5. Handle Token Expiry
    if (errorCode == ErrorCodes.invalidAuthorization) {
      // Prevent infinite refresh loop
      if (isRetry) {
        // If we've already tried to refresh and the token is still invalid,
        // or the refresh itself failed, then it's a genuine auth problem.
        return Left(InvalidSessionFailure());
      }

      // Attempt to refresh the token
      final refreshResult = await authSharedRepo.refresh();

      return refreshResult.fold(
        (failure) => Left(failure),
        // If refresh succeeds, retry the *original request* with the new token.
        (_) async {
          // Recursive call, but with isRetry flag set to true
          return await handleAuthRequest(
            tokenService,
            authSharedRepo,
            originalRequest,
            isRetry: true, // Mark this as a retry
          );
        },
      );
    }

    return Left(ServerFailure(statusCode: statusCode, errorCode: errorCode));
  } on AuthTokenException {
    return Left(AuthTokenFailure());
  } catch (e) {
    // TODO: Add logger
    return Left(UnknownFailure());
  }
}
