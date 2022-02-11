import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia_clean_architecture_tdd/core/error/exceptions.dart';
import 'package:number_trivia_clean_architecture_tdd/core/error/failure.dart';
import 'package:number_trivia_clean_architecture_tdd/core/network/network_info.dart';
import 'package:number_trivia_clean_architecture_tdd/features/number_trivia/data/datasources/local/number_trivia_local_data_souce.dart';
import 'package:number_trivia_clean_architecture_tdd/features/number_trivia/data/datasources/remote/number_trivia_remote_data_source.dart';
import 'package:number_trivia_clean_architecture_tdd/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:number_trivia_clean_architecture_tdd/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:number_trivia_clean_architecture_tdd/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:number_trivia_clean_architecture_tdd/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'number_trivia_repository_impl_test.mocks.dart';

@GenerateMocks(
    [NumberTriviaRemoteDataSource, NumberTriviaLocalDataSource, NetworkInfo])
void main() {
  NumberTriviaRepositoryImpl repositoryImpl;

  MockNumberTriviaRemoteDataSource mockNumberTriviaRemoteDataSource;
  MockNumberTriviaLocalDataSource mockNumberTriviaLocalDataSource;
  MockNetworkInfo mockNetworkInfo;
  NetworkInfo networkInfo;

  mockNumberTriviaRemoteDataSource = MockNumberTriviaRemoteDataSource();
  mockNumberTriviaLocalDataSource = MockNumberTriviaLocalDataSource();
  mockNetworkInfo = MockNetworkInfo();

  repositoryImpl = NumberTriviaRepositoryImpl(
    remoteDataSource: mockNumberTriviaRemoteDataSource,
    localDataSource: mockNumberTriviaLocalDataSource,
    networkInfo: mockNetworkInfo,
  );

  group("concrete number trivia", () {
    final tNumberTriviaModel =
        NumberTriviaModel(text: "test trivia", number: 1);
    NumberTrivia numberTrivia = tNumberTriviaModel;

    group("device is online", () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });
      test(
          "should return remote data when the call to remote data source sucess",
          () async {
        //  Arrange
        when(mockNumberTriviaRemoteDataSource.getConcreteNumberTrivia(any))
            .thenAnswer((_) async => tNumberTriviaModel);
        //  Act
        final result = await repositoryImpl.getConcreateNumberTrivia(1);
        //  Assert
        verify(mockNumberTriviaRemoteDataSource.getConcreteNumberTrivia(1));
        expect(result, equals(Right(numberTrivia)));
      });

      test(
          "should return server failure  when the call to remote data source unsucessfully",
          () async {
        //  Arrange
        when(mockNumberTriviaRemoteDataSource.getConcreteNumberTrivia(any))
            .thenThrow(ServerException());
        //  Act
        final result = await repositoryImpl.getConcreateNumberTrivia(1);
        //  Assert
        verify(mockNumberTriviaRemoteDataSource.getConcreteNumberTrivia(1));
        expect(result, equals(Left(ServerFailure())));
      });

      test(
          "should cache the data locally when call to remote data source is successfull",
          () async {
        //  Arrange
        when(mockNumberTriviaRemoteDataSource.getConcreteNumberTrivia(any))
            .thenAnswer((_) async => tNumberTriviaModel);
        //  Act
        final result = await repositoryImpl.getConcreateNumberTrivia(1);
        //  Assert
        verify(mockNumberTriviaRemoteDataSource.getConcreteNumberTrivia(1));
        expect(result, equals(Right(tNumberTriviaModel)));
      });
    });

    group("device is offline", () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });
      // verify(mockNetworkInfo.isConnected);

      test("should return last locally cached data  when the cached is present",
          () async {
        //  Arrange
        when(mockNumberTriviaLocalDataSource.getLastNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);
        //  Act
        final result = await repositoryImpl.getConcreateNumberTrivia(1);

        //  Assert
        // verifyZeroInteractions(mockNumberTriviaRemoteDataSource);
        verify(mockNumberTriviaLocalDataSource.getLastNumberTrivia());
        expect(result, equals(Right(tNumberTriviaModel)));
      });

      test("should return CacheFailure when there si no cached data present",
          () async {
        //  Arrange
        when(mockNumberTriviaLocalDataSource.getLastNumberTrivia())
            .thenThrow(CacheException());
        //  Act
        final result = await repositoryImpl.getConcreateNumberTrivia(1);
        //  Assert
        verifyNoMoreInteractions(mockNumberTriviaRemoteDataSource);
        verify(mockNumberTriviaLocalDataSource.getLastNumberTrivia());
        expect(result, equals(Left(CacheFaliure())));
      });
    });
  });

  group("random number trivia", () {
    final tNumberTriviaModel =
        NumberTriviaModel(text: "test trivia", number: 123);
    NumberTrivia numberTrivia = tNumberTriviaModel;
    group("device is online", () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });
      test(
          "should return remote data when the call to remote data source sucess",
          () async {
        //  Arrange
        when(mockNumberTriviaRemoteDataSource.getRandomNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);
        //  Act
        final result = await repositoryImpl.getRandomNumberTrivia();
        //  Assert
        verify(mockNumberTriviaRemoteDataSource.getRandomNumberTrivia());
        expect(result, equals(Right(numberTrivia)));
      });

      test(
          "should return server failure  when the call to remote data source unsucessfully",
          () async {
        //  Arrange
        when(mockNumberTriviaRemoteDataSource.getRandomNumberTrivia())
            .thenThrow(ServerException());
        //  Act
        final result = await repositoryImpl.getRandomNumberTrivia();
        //  Assert
        verify(mockNumberTriviaRemoteDataSource.getRandomNumberTrivia());
        expect(result, equals(Left(ServerFailure())));
      });

      test(
          "should cache the data locally when call to remote data source is successfull",
          () async {
        //  Arrange
        when(mockNumberTriviaRemoteDataSource.getRandomNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);
        //  Act
        final result = await repositoryImpl.getRandomNumberTrivia();
        //  Assert
        verify(mockNumberTriviaRemoteDataSource.getRandomNumberTrivia());
        expect(result, equals(Right(tNumberTriviaModel)));
      });
    });

    group("device is offline", () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });
      // verify(mockNetworkInfo.isConnected);

      test("should return last locally cached data  when the cached is present",
          () async {
        //  Arrange
        when(mockNumberTriviaLocalDataSource.getLastNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);
        //  Act
        final result = await repositoryImpl.getRandomNumberTrivia();

        //  Assert
        // verifyZeroInteractions(mockNumberTriviaRemoteDataSource);
        verify(mockNumberTriviaLocalDataSource.getLastNumberTrivia());
        expect(result, equals(Right(tNumberTriviaModel)));
      });

      test("should return CacheFailure when there si no cached data present",
          () async {
        //  Arrange
        when(mockNumberTriviaLocalDataSource.getLastNumberTrivia())
            .thenThrow(CacheException());
        //  Act
        final result = await repositoryImpl.getRandomNumberTrivia();
        //  Assert
        verifyNoMoreInteractions(mockNumberTriviaRemoteDataSource);
        verify(mockNumberTriviaLocalDataSource.getLastNumberTrivia());
        expect(result, equals(Left(CacheFaliure())));
      });
    });
  });
}
