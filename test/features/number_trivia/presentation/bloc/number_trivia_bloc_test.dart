import 'package:bloc_test/bloc_test.dart';
import 'package:clean_architeture_app/core/error/failures.dart';
import 'package:clean_architeture_app/core/use_cases/usecase.dart';
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

    registerFallbackValue(const Params(number: 69));
    registerFallbackValue( NoParams());

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

    test(
      'should emit [Error] when the input is invalid',
        () async {
        // arrange
          when(()=> mockInputConverter.stringToUnsignedInteger(any())).thenReturn(Left(InvalidInputFailure()));

          // assert later
          final expected = [
            NumberTriviaInitial(),
            Error(errorMessage: INVALID_INPUT_FAILURE_MESSAGE)];
          expectLater(bloc.stream, emitsInOrder(expected));

          // act
          bloc.add(GetTriviaForConcreteNumber(tNumberString));

          },
    );


  });

  // BlocTests for ConcreteTrivia
  blocTest<NumberTriviaBloc, NumberTriviaState>('blocTest - should emit [Error] when the input is invalid', build: () => bloc,

  setUp: () => when(()=> mockInputConverter.stringToUnsignedInteger(any())).thenReturn(Left(InvalidInputFailure())),
    act: (bloc) => bloc.add(GetTriviaForConcreteNumber('1')) ,
    expect: () => [Error(errorMessage: INVALID_INPUT_FAILURE_MESSAGE)]
  );

  blocTest<NumberTriviaBloc, NumberTriviaState>('blocTest - should get data from the concrete use case', build: () => bloc,

      setUp: () {when(()=> mockInputConverter.stringToUnsignedInteger(any())).thenReturn(const Right(1));
      when(()=> mockGetConcreteNumberTrivia(any())).thenAnswer((_) async => Right(NumberTrivia(text: 'test trivia', number: 1)));} ,
      act: (bloc) => bloc.add(GetTriviaForConcreteNumber('1')) ,
      verify: (bloc) => mockGetConcreteNumberTrivia(const Params(number: 1))
  );

  blocTest<NumberTriviaBloc, NumberTriviaState>('blocTest - should emit [Loading, Loaded] when data is gotten seccessfully', build: () => bloc,

      setUp: () {when(()=> mockInputConverter.stringToUnsignedInteger(any())).thenReturn(const Right(1));
      when(()=> mockGetConcreteNumberTrivia(any())).thenAnswer((_) async => Right(NumberTrivia(text: 'test trivia', number: 1)));} ,
      act: (bloc) => bloc.add(GetTriviaForConcreteNumber('1')) ,
      expect: () => [Loading(), Loaded(trivia: NumberTrivia(text: 'test trivia', number: 1))]
  );

  blocTest<NumberTriviaBloc, NumberTriviaState>('blocTest - should emit [Loading, Error] with a proper Message when getting data failes', build: () => bloc,

      setUp: () {when(()=> mockInputConverter.stringToUnsignedInteger(any())).thenReturn(const Right(1));
      when(()=> mockGetConcreteNumberTrivia(any())).thenAnswer((_) async => Left(ServerFailure()));} ,
      act: (bloc) => bloc.add(GetTriviaForConcreteNumber('1')) ,
      expect: () => [Loading(), Error(errorMessage: SERVER_FAILURE_MESSAGE)]
  );

  blocTest<NumberTriviaBloc, NumberTriviaState>('blocTest - should emit [Loading, Error] with a proper Message when getting data failes', build: () => bloc,

      setUp: () {when(()=> mockInputConverter.stringToUnsignedInteger(any())).thenReturn(const Right(1));
      when(()=> mockGetConcreteNumberTrivia(any())).thenAnswer((_) async => Left(CacheFailure()));} ,
      act: (bloc) => bloc.add(GetTriviaForConcreteNumber('1')) ,
      expect: () => [Loading(), Error(errorMessage: CACHE_FAILURE_MESSAGE)]
  );

  // BlocTest for RandomTrivia


  blocTest<NumberTriviaBloc, NumberTriviaState>('blocTest - should get data from the random use case', build: () => bloc,

      setUp: () {when(()=> mockGetRandomNumberTrivia(any())).thenAnswer((_) async => Right(NumberTrivia(text: 'test trivia', number: 1)));} ,
      act: (bloc) => bloc.add(GetTriviaForRandomNumber()) ,
      verify: (bloc) => mockGetRandomNumberTrivia(NoParams())
  );

  blocTest<NumberTriviaBloc, NumberTriviaState>('blocTest - should emit [Loading, Loaded] when data is gotten seccessfully', build: () => bloc,

      setUp: () {when(()=> mockGetRandomNumberTrivia(any())).thenAnswer((_) async => Right(NumberTrivia(text: 'test trivia', number: 1)));} ,
      act: (bloc) => bloc.add(GetTriviaForRandomNumber()) ,
      expect: () => [Loading(), Loaded(trivia: NumberTrivia(text: 'test trivia', number: 1))]
  );

  blocTest<NumberTriviaBloc, NumberTriviaState>('blocTest - should emit [Loading, Error] with a proper Message when getting data failes', build: () => bloc,

      setUp: () {when(()=> mockGetRandomNumberTrivia(any())).thenAnswer((_) async => Left(ServerFailure()));} ,
      act: (bloc) => bloc.add(GetTriviaForRandomNumber()) ,
      expect: () => [Loading(), Error(errorMessage: SERVER_FAILURE_MESSAGE)]
  );

  blocTest<NumberTriviaBloc, NumberTriviaState>('blocTest - should emit [Loading, Error] with a proper Message when getting data failes', build: () => bloc,

      setUp: () {
      when(()=> mockGetRandomNumberTrivia(any())).thenAnswer((_) async => Left(CacheFailure()));} ,
      act: (bloc) => bloc.add(GetTriviaForRandomNumber()) ,
      expect: () => [Loading(), Error(errorMessage: CACHE_FAILURE_MESSAGE)]
  );
}
