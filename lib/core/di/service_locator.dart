import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import '../network/dio_client.dart';
import '../../features/auth/data/repos/auth_repo.dart';
import '../../features/auth/presentation/cubits/auth_cubit.dart';

final sl = GetIt.instance;

void setupServiceLocator() {
  // Network
  sl.registerLazySingleton<Dio>(() => DioClient.createDio());

  // Repositories
  sl.registerLazySingleton<AuthRepo>(() => AuthRepo(sl<Dio>()));

  // Cubits
  sl.registerFactory<AuthCubit>(() => AuthCubit(sl<AuthRepo>()));
}
