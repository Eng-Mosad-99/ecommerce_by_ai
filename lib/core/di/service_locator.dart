import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import '../network/dio_client.dart';
import '../../features/auth/data/repos/auth_repo.dart';
import '../../features/auth/presentation/blocs/auth_bloc.dart';

final sl = GetIt.instance;

void setupServiceLocator() {
  // Network
  sl.registerLazySingleton<Dio>(() => DioClient.createDio());

  // Repositories
  sl.registerLazySingleton<AuthRepo>(() => AuthRepo(sl<Dio>()));

  // Blocs
  sl.registerFactory<AuthBloc>(() => AuthBloc(sl<AuthRepo>()));
}
