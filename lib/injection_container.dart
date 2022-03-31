import 'package:clean_architeture_app/core/network/network_info.dart';
import 'package:clean_architeture_app/core/util/input_converter.dart';
import 'package:clean_architeture_app/features/trivial_navigator/data/datasources/number_trevia_remote_data_source.dart';
import 'package:clean_architeture_app/features/trivial_navigator/data/repositories/numer_trivia_repository_impl.dart';
import 'package:clean_architeture_app/features/trivial_navigator/domain/repositories/number_trivia_repository.dart';
import 'package:clean_architeture_app/features/trivial_navigator/domain/use_cases/get_concrete_number_trivia.dart';
import 'package:clean_architeture_app/features/trivial_navigator/domain/use_cases/get_random_number_trivia.dart';
import 'package:clean_architeture_app/presentation/number_trivia_bloc.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'features/trivial_navigator/data/datasources/number_trivia_local_data_source.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Features - Number Trivia
  // Bloc
  sl.registerFactory(() => NumberTriviaBloc(
        getRandomNumberTrivia: sl(),
        inputConverter: sl(),
        getConcreteNumberTrivia: sl(),
      ));
  // Use cases
  sl.registerLazySingleton(() => GetConcreteNumberTrivia(sl()));
  sl.registerLazySingleton(() => GetRandomNumberTrivia(sl()));

  // Repository
  sl.registerLazySingleton<NumberTriviaRepository>(() =>
      NumberTriviaRepositoryImpl(
          remoteDataSource: sl(), localDataSource: sl(), networkInfo: sl()));
  // Data sources
  sl.registerLazySingleton<NumberTriviaRemoteDataSource>(
    () => NumberTriviaRemoteDataSourceImpl(client: sl()),
  );

  sl.registerLazySingleton<NumberTriviaLocalDataSource>(
    () => NumberTriviaLocalDataSourceImpl(sharedPreferences: sl()),
  );

  // Core
  sl.registerLazySingleton(() => InputConverter());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => DataConnectionChecker());
}