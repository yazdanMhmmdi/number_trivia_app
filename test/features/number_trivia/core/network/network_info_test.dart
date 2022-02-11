import 'package:data_connection_checker_tv/data_connection_checker.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia_clean_architecture_tdd/core/network/network_info.dart';
import 'package:number_trivia_clean_architecture_tdd/core/network/network_info_impl.dart';

import 'network_info_test.mocks.dart';

@GenerateMocks([DataConnectionChecker])
void main() {
  NetworkInfoImpl? networkInfoImpl;
  MockDataConnectionChecker? mockDataConnectionChecker;

  setUp(() {
    mockDataConnectionChecker = MockDataConnectionChecker();
    networkInfoImpl = NetworkInfoImpl(mockDataConnectionChecker);
  });

  group("is Connected", () {
    test("should forward the call to DataConnectionChecker.hasConnected",
        () async {
      final hHasConnectionFuture = Future.value(true);
      //  Arrange
      when(mockDataConnectionChecker!.hasConnection)
          .thenAnswer((_) => hHasConnectionFuture);
      //  Act
      final result = networkInfoImpl!.isConnected;
      //  Assert
      verify(mockDataConnectionChecker!.hasConnection);
      expect(result, hHasConnectionFuture);
    });
  });
}
