import 'package:clean_architeture_app/features/trivial_navigator/data/models/number_trivia_model.dart';
import 'package:clean_architeture_app/features/trivial_navigator/domain/entities/number_trivia.dart';

abstract class NumberTriviaRemoteDataSource {
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number);
  Future<NumberTriviaModel> getRandomNumberTrivia();
}