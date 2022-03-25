import 'package:clean_architeture_app/core/use_cases/usecase.dart';
import 'package:clean_architeture_app/features/trivial_navigator/domain/entities/number_trivia.dart';
import 'package:clean_architeture_app/features/trivial_navigator/domain/repositories/number_trivia_repository.dart';
import 'package:clean_architeture_app/features/trivial_navigator/domain/use_cases/get_concrete_number_trivia.dart';
import 'package:clean_architeture_app/features/trivial_navigator/domain/use_cases/get_random_number_trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockNumberTriviaRepository extends Mock
    implements NumberTriviaRepository {}

void main() {
  MockNumberTriviaRepository mockNumberTriviaRepository =
      MockNumberTriviaRepository();
  GetRandomNumberTrivia usecase =
      GetRandomNumberTrivia(mockNumberTriviaRepository);
  setUp(() {});

  final tNumberTrivia = NumberTrivia(number: 1, text: 'test');

  test('should get trivia  from the repository', () async {
    when(() => mockNumberTriviaRepository.getRandomNumberTrivia())
        .thenAnswer((_) async => Right(tNumberTrivia));

    // act
    final result = await usecase(NoParams());
    // assert
    expect(result, Right(tNumberTrivia));
    verify(() => mockNumberTriviaRepository.getRandomNumberTrivia());
    verifyNoMoreInteractions(mockNumberTriviaRepository);
  });
}
