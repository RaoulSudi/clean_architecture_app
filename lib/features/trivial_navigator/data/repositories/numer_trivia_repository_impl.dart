import 'dart:async';

import 'package:clean_architeture_app/core/error/exceptions.dart';
import 'package:clean_architeture_app/core/error/failures.dart';
import 'package:clean_architeture_app/core/network/network_info.dart';
import 'package:clean_architeture_app/features/trivial_navigator/data/datasources/number_trevia_remote_data_source.dart';
import 'package:clean_architeture_app/features/trivial_navigator/data/datasources/number_trivia_local_data_source.dart';
import 'package:clean_architeture_app/features/trivial_navigator/data/models/number_trivia_model.dart';
import 'package:clean_architeture_app/features/trivial_navigator/domain/entities/number_trivia.dart';
import 'package:clean_architeture_app/features/trivial_navigator/domain/repositories/number_trivia_repository.dart';
import 'package:dartz/dartz.dart';

typedef Future<NumberTriviaModel> _ConcreteOrRandomChooser();

class NumberTriviaRepositoryImpl implements NumberTriviaRepository {
  late final NumberTriviaRemoteDataSource remoteDataSource;
  late final NumberTriviaLocalDataSource localDataSource;
  late final NetworkInfo networkInfo;

  NumberTriviaRepositoryImpl(
      {required this.remoteDataSource,
      required this.localDataSource,
      required this.networkInfo});

  @override
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(
      int number) async {
    return await _getTrivia(() {
      return remoteDataSource.getConcreteNumberTrivia(number);
    });
  }

  @override
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia() async {
    return await _getTrivia(() {
      return remoteDataSource.getRandomNumberTrivia();
    });
  }

  Future<Either<Failure, NumberTrivia>> _getTrivia(
      _ConcreteOrRandomChooser getConcreteOrRandom) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteTrivia = await getConcreteOrRandom();
        unawaited(localDataSource.cacheNumberTrivia(remoteTrivia));
        return Right(remoteTrivia);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        return Right(await localDataSource.getLastNumberTrivia());
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}
