import 'dart:convert';

import 'package:clean_architeture_app/core/error/exceptions.dart';
import 'package:clean_architeture_app/features/trivial_navigator/data/datasources/number_trevia_remote_data_source.dart';
import 'package:clean_architeture_app/features/trivial_navigator/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {

}

void main() {
  late NumberTriviaRemoteDataSourceImpl dataSource;
  late MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = NumberTriviaRemoteDataSourceImpl(client: mockHttpClient);
    registerFallbackValue(Uri(path: 'http://numersapi.com/42'));
  });

  void setUpMockHttpClientSuccess200(){
    when(()=> mockHttpClient.get(any(), headers: any(named: "headers"))).
    thenAnswer((_) async => http.Response(fixture('trivia.json'),200));
  }

  void setUpMockHttpClientFailure404(){
    when(()=> mockHttpClient.get(any(), headers: any(named: "headers"))).
    thenAnswer((_) async => http.Response('Something went wrong',404));
  }



  group('getConcreteTrivia',(){
    final tNumber = 1;
    final tNumberTriviaModel = NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));
    final uri = Uri(path: 'http://numersapi.com/$tNumber');
    test(
      'should perform a GET request on a URL with number being the endpoint and with application/json header',
        () async {
        //arrange
          setUpMockHttpClientSuccess200();
        // act
          dataSource.getConcreteNumberTrivia(tNumber);
        // assert
          verify(()=>mockHttpClient.get(uri,
            headers: {'Content-Type': 'applicatoin/json',
            },
          ));
        }
    );

    test(
      'should return NumberTrivia when the response code is 200 (success)',
        () async {
          //arrange
          setUpMockHttpClientSuccess200();
          // act
          final result = await dataSource.getConcreteNumberTrivia(tNumber);
          // assert
          expect(result, equals(tNumberTriviaModel));
        }

    );

    test(
      'should throw a ServerException when response code is 404 or other',
        () async {
          //arrange
          setUpMockHttpClientFailure404();
          // act
          final call = dataSource.getConcreteNumberTrivia;
          // assert
          expect(()=> call (tNumber), throwsA(const TypeMatcher<ServerException>()));
        }
    );
  });

  group('getRandomNumberTrivia',(){
    final tNumberTriviaModel = NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));
    final uri = Uri(path: 'http://numersapi.com/random');
    test(
        'should perform a GET request on a URL with number being the endpoint and with application/json header',
            () async {
          //arrange
          setUpMockHttpClientSuccess200();
          // act
          dataSource.getRandomNumberTrivia();
          // assert
          verify(()=>mockHttpClient.get(uri,
            headers: {'Content-Type': 'applicatoin/json',
            },
          ));
        }
    );

    test(
        'should return NumberTrivia when the response code is 200 (success)',
            () async {
          //arrange
          setUpMockHttpClientSuccess200();
          // act
          final result = await dataSource.getRandomNumberTrivia();
          // assert
          expect(result, equals(tNumberTriviaModel));
        }

    );

    test(
        'should throw a ServerException when response code is 404 or other',
            () async {
          //arrange
          setUpMockHttpClientFailure404();
          // act
          final call = dataSource.getRandomNumberTrivia;
          // assert
          expect(()=> call(), throwsA(const TypeMatcher<ServerException>()));
        }
    );
  });
}