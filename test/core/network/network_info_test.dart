import 'package:clean_architeture_app/core/network/network_info.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';


class MockDataConnectionChecker extends Mock implements DataConnectionChecker {}

void main(){
  late NetworkInfoImpl networkInfoImpl;
  late MockDataConnectionChecker mockDataConnectionChecker;

  setUpAll(() {
    mockDataConnectionChecker = MockDataConnectionChecker();
    networkInfoImpl = NetworkInfoImpl(mockDataConnectionChecker);
  });

  group('isConnected', () {
    test('should forward the call to DataConnectionChecker.hasConnect',
        () async {
      // arrange
          final tHasConnectionFuture = Future.value(true);

          when(()=> mockDataConnectionChecker.hasConnection).thenAnswer((_) => tHasConnectionFuture);
          // act
          final result = networkInfoImpl.isConnected;
          verify(()=>mockDataConnectionChecker.hasConnection);
          expect(result, tHasConnectionFuture);

        }

    );
  });
}