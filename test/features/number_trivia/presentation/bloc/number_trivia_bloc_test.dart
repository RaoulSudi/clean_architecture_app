import 'package:clean_architeture_app/core/util/input_converter.dart';
import 'package:clean_architeture_app/features/trivial_navigator/domain/entities/number_trivia.dart';
import 'package:clean_architeture_app/features/trivial_navigator/domain/use_cases/get_concrete_number_trivia.dart';
import 'package:clean_architeture_app/features/trivial_navigator/domain/use_cases/get_random_number_trivia.dart';
import 'package:clean_architeture_app/presentation/number_trivia_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetConcreteNumberTrivia extends Mock
    implements GetConcreteNumberTrivia {}

class MockGetRandomNumberTrivia extends Mock implements GetRandomNumberTrivia {}

class MockInputConverter extends Mock implements InputConverter {}

void main() {
  late NumberTriviaBloc bloc;
  late MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  late MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  late MockInputConverter mockInputConverter;

  setUp(() {
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockInputConverter = MockInputConverter();

    bloc = NumberTriviaBloc(
        getConcreteNumberTrivia: mockGetConcreteNumberTrivia,
        getRandomNumberTrivia: mockGetRandomNumberTrivia,
        inputConverter: mockInputConverter);
  });
  
  test('initalState should be Empty', () {
    //assert
    expect(bloc.state,equals(NumberTriviaInitial()));
  });

  group('GetTriviaForConcreteNumber', () {
    const tNumberString = '1';
    const tNumberParsed = 1;
    final tNumberTrivia = NumberTrivia(text: 'test trivia', number: 1);

    test(
      'should call the InputConverter to validate and convert the string to an unsigned integer',
        () async {
        // arrange
          when(()=> mockInputConverter.stringToUnsignedInteger(any()))
              .thenReturn(Right(tNumberParsed));
        // act
        bloc.add(GetTriviaForConcreteNumber(tNumberString));
        await untilCalled(()=> mockInputConverter.stringToUnsignedInteger(any()));
        // assert
        verify(()=>mockInputConverter.stringToUnsignedInteger(tNumberString));
        }
    );
  });
}
