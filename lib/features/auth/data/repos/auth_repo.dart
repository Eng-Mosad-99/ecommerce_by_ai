import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/constants/api_constants.dart';
import '../models/auth_response_model.dart';

class AuthRepo {
  final Dio _dio;

  AuthRepo(this._dio);

  Future<Either<Failure, AuthResponseModel>> login(String email, String password) async {
    try {
      final response = await _dio.post(
        ApiConstants.signin,
        data: {
          "email": email,
          "password": password,
        },
      );
      return Right(AuthResponseModel.fromJson(response.data));
    } on DioException catch (e) {
      return Left(ServerFailure(e.response?.data['message'] ?? 'An error occurred'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, AuthResponseModel>> register({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) async {
    try {
      final response = await _dio.post(
        ApiConstants.signup,
        data: {
          "name": name,
          "email": email,
          "password": password,
          "rePassword": password,
          "phone": phone,
        },
      );
      return Right(AuthResponseModel.fromJson(response.data));
    } on DioException catch (e) {
      return Left(ServerFailure(e.response?.data['message'] ?? 'An error occurred'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, String>> forgotPassword(String email) async {
    try {
      final response = await _dio.post(
        ApiConstants.forgotPassword,
        data: {"email": email},
      );
      return Right(response.data['message'] ?? 'Code sent');
    } on DioException catch (e) {
      return Left(ServerFailure(e.response?.data['message'] ?? 'An error occurred'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, String>> verifyCode(String code) async {
    try {
      final response = await _dio.post(
        ApiConstants.verifyCode,
        data: {"resetCode": code},
      );
      return Right(response.data['status'] ?? 'Success');
    } on DioException catch (e) {
      return Left(ServerFailure(e.response?.data['message'] ?? 'An error occurred'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, String>> resetPassword(String email, String newPassword) async {
    try {
      final response = await _dio.put(
        ApiConstants.resetPassword,
        data: {
          "email": email,
          "newPassword": newPassword,
        },
      );
      return Right(response.data['token'] ?? 'Success');
    } on DioException catch (e) {
      return Left(ServerFailure(e.response?.data['message'] ?? 'An error occurred'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
