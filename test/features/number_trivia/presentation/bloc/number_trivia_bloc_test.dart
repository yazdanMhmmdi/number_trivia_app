import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia_clean_architecture_tdd/core/constants/value.dart';
import 'package:number_trivia_clean_architecture_tdd/core/error/failure.dart';
import 'package:number_trivia_clean_architecture_tdd/core/params/concrete_number_trivia_params.dart';
import 'package:number_trivia_clean_architecture_tdd/core/params/no_params.dart';
import 'package:number_trivia_clean_architecture_tdd/core/util/input_converter.dart';
import 'package:number_trivia_clean_architecture_tdd/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:number_trivia_clean_architecture_tdd/features/number_trivia/domain/usecases/get_concrete_number_trivia_usecase.dart';
import 'package:number_trivia_clean_architecture_tdd/features/number_trivia/domain/usecases/get_random_number_trivia_usecase.dart';
import 'package:number_trivia_clean_architecture_tdd/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';

import 'number_trivia_bloc_test.mocks.dart';

@GenerateMocks([
  GetConcreteNumberTriviaUseCase,
  GetRandomNumberTriviaUseCase,
  InputConverter,
  ConcreteNumberTriviaParams,
])
void main() {
  NumberTriviaBloc? bloc;
  MockGetConcreteNumberTriviaUseCase? mockGetConcreteNumberTriviaUseCase;
  MockGetRandomNumberTriviaUseCase? mockGetRandomNumberTriviaUseCase;

  MockInputConverter? mockInputConverter;

  setUp(() {
    mockGetConcreteNumberTriviaUseCase = MockGetConcreteNumberTriviaUseCase();
    mockGetRandomNumberTriviaUseCase = MockGetRandomNumberTriviaUseCase();
    mockInputConverter = MockInputConverter();

    bloc = NumberTriviaBloc(
        getConcreteNumberTrivia: mockGetConcreteNumberTriviaUseCase!,
        getRandomNumberTriviaUseCase: mockGetRandomNumberTriviaUseCase!,
        inputConverter: mockInputConverter!);
  });

  test("initState should be empty", () {
    //  Arrange

    //  Act

    //  Assert
    expect(bloc!.state, equals(Empty()));
  });

  group('getTriviaForConcreteNumber', () {
    final tNumberString = '1';
    final tNumberParsed = 1;
    final tNumberTrivia = NumberTrivia(number: 1, text: "test trivia");

    test(
        "should call the inputConverter to validate and convert the string to an unsinged integer",
        () async {
      //  Arrange
      when(mockInputConverter!.stringToUnsignedInteger(any))
          .thenReturn(Right(tNumberParsed));
      when(mockGetConcreteNumberTriviaUseCase!(any))
          .thenAnswer((_) async => Right(tNumberTrivia));
      //  Act
      bloc!.add(GetTriviaConcreteNumber(tNumberString));
      await untilCalled(mockInputConverter!.stringToUnsignedInteger(any));
      //  Assert
      verify(mockInputConverter!.stringToUnsignedInteger(tNumberString));
    });

    test("should emit [Error] when the input is invalid", () {
      //  Arrange
      when(mockInputConverter!.stringToUnsignedInteger(any))
          .thenReturn(Left(InvalideInputFailure()));

      //  Assert >>>>later<<<<
      expectLater(
          bloc!.stream,
          emitsInOrder(
            [
              Empty(),
              Error(message: kInvalidInputFailureMessage),
            ],
          ));

      //  Act
      bloc!.add(GetTriviaConcreteNumber(tNumberString));
    });

    test("should get data from the concrete usecase", () async {
      //  Arrange
      when(mockInputConverter!.stringToUnsignedInteger(any))
          .thenReturn(Right(tNumberParsed));
      when(mockGetConcreteNumberTriviaUseCase!(any))
          .thenAnswer((_) async => Right(tNumberTrivia));

      //  Act

      bloc!.add(GetTriviaConcreteNumber(tNumberString));
      await untilCalled(mockGetConcreteNumberTriviaUseCase!(any));
      //  Assert
      verify(mockGetConcreteNumberTriviaUseCase!(ConcreteNumberTriviaParams(
        number: tNumberParsed,
      )));
    });

    test("should emit[Loading, Loaded] when data is gotten successfully", () {
      //  Arrange
      when(mockInputConverter!.stringToUnsignedInteger(any))
          .thenReturn(Right(tNumberParsed));
      when(mockGetConcreteNumberTriviaUseCase!(any))
          .thenAnswer((_) async => Right(tNumberTrivia));

      //  Assert >>> LATER <<<<
      final expected = [
        Empty(),
        Loading(),
        Loaded(trivia: tNumberTrivia),
      ];
      expectLater(bloc!.stream, emitsInOrder(expected));
      //  Act
      bloc!.add(GetTriviaConcreteNumber(tNumberString));
    });

    test("should emit[Loading, Loaded] when data is getting fails", () {
      //  Arrange
      when(mockInputConverter!.stringToUnsignedInteger(any))
          .thenReturn(Right(tNumberParsed));
      when(mockGetConcreteNumberTriviaUseCase!(any))
          .thenAnswer((_) async => Left(ServerFailure()));

      //  Assert >>> LATER <<<<
      final expected = [
        Empty(),
        Loading(),
        Error(message: kServerFailureMessage)
      ];
      expectLater(bloc!.stream, emitsInOrder(expected));
      //  Act
      bloc!.add(GetTriviaConcreteNumber(tNumberString));
    });

    test(
        "should emit[Loading, Loaded] with a proper mesage for the error when getting data fails",
        () {
      //  Arrange
      when(mockInputConverter!.stringToUnsignedInteger(any))
          .thenReturn(Right(tNumberParsed));
      when(mockGetConcreteNumberTriviaUseCase!(any))
          .thenAnswer((_) async => Left(CacheFaliure()));

      //  Assert >>> LATER <<<<
      final expected = [
        Empty(),
        Loading(),
        Error(message: kCacheFailureMessage)
      ];
      expectLater(bloc!.stream, emitsInOrder(expected));
      //  Act
      bloc!.add(GetTriviaConcreteNumber(tNumberString));
    });
  });

  ///////////

  group('getTriviaForRandomNumber', () {
    final tNumberTrivia = NumberTrivia(number: 1, text: "test trivia");
    test("should get data from the randoms usecase", () async {
      //  Arrange

      when(mockGetRandomNumberTriviaUseCase!(any))
          .thenAnswer((_) async => Right(tNumberTrivia));

      //  Act

      bloc!.add(GetTriviaRandomNumber());
      await untilCalled(mockGetRandomNumberTriviaUseCase!(any));
      //  Assert
      verify(mockGetRandomNumberTriviaUseCase!(NoParams()));
      // expect(1, 1);
    });
    test("should emit[Loading, Loaded] when data is gotten successfully", () {
      //  Arrange

      when(mockGetRandomNumberTriviaUseCase!(any))
          .thenAnswer((_) async => Right(tNumberTrivia));

      //  Assert >>> LATER <<<<
      final expected = [
        Empty(),
        Loading(),
        Loaded(trivia: tNumberTrivia),
      ];
      expectLater(bloc!.stream, emitsInOrder(expected));
      //  Act
      bloc!.add(GetTriviaRandomNumber());
    });

    test("should emit[Loading, Loaded] when data is getting fails", () {
      //  Arrange

      when(mockGetRandomNumberTriviaUseCase!(any))
          .thenAnswer((_) async => Left(ServerFailure()));

      //  Assert >>> LATER <<<<
      final expected = [
        Empty(),
        Loading(),
        Error(message: kServerFailureMessage)
      ];
      expectLater(bloc!.stream, emitsInOrder(expected));
      //  Act
      bloc!.add(GetTriviaRandomNumber());
    });

    test(
        "should emit[Loading, Loaded] with a proper mesage for the error when getting data fails",
        () {
      //  Arrange
      when(mockGetRandomNumberTriviaUseCase!(any))
          .thenAnswer((_) async => Left(CacheFaliure()));

      //  Assert >>> LATER <<<<
      final expected = [
        Empty(),
        Loading(),
        Error(message: kCacheFailureMessage)
      ];
      expectLater(bloc!.stream, emitsInOrder(expected));
      //  Act
      bloc!.add(GetTriviaRandomNumber());
    });

    blocTest(
        "should emit [Loading, Loaded] when data gotten successsfully with bloc_test package",
        build: () => bloc!,
        setUp: () {
          //  Arrange
          when(mockGetRandomNumberTriviaUseCase!(any)).thenAnswer((_) async {
            return Right(tNumberTrivia);
          });
        },
        act: (NumberTriviaBloc? b) {
          b!.add(GetTriviaRandomNumber());
        },
        expect: () => [
              Empty(),
              Loading(),
              Loaded(trivia: tNumberTrivia),
            ]);

    blocTest(
        "should emit [Loading, Error] when ServerFailure occurred with bloc_test package",
        build: () => bloc!,
        setUp: () {
          //  Arrange
          when(mockGetRandomNumberTriviaUseCase!(any)).thenAnswer((_) async {
            return Left(ServerFailure());
          });
        },
        act: (NumberTriviaBloc? b) {
          b!.add(GetTriviaRandomNumber());
        },
        expect: () => [
              Empty(),
              Loading(),
              Error(message: kServerFailureMessage),
            ]);

    blocTest(
        "should emit [Loading, Error] when CacheFailure occurred with bloc_test package",
        build: () => bloc!,
        setUp: () {
          //  Arrange
          when(mockGetRandomNumberTriviaUseCase!(any)).thenAnswer((_) async {
            return Left(CacheFaliure());
          });
        },
        act: (NumberTriviaBloc? b) {
          b!.add(GetTriviaRandomNumber());
        },
        expect: () => [
              Empty(),
              Loading(),
              Error(message: kCacheFailureMessage),
            ]);
  });
}
