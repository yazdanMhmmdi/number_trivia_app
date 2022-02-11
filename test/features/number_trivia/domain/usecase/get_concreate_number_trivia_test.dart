import 'package:dartz/dartz.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia_clean_architecture_tdd/core/error/failure.dart';
import 'package:number_trivia_clean_architecture_tdd/core/params/concrete_number_trivia_params.dart';
import 'package:number_trivia_clean_architecture_tdd/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:number_trivia_clean_architecture_tdd/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:number_trivia_clean_architecture_tdd/features/number_trivia/domain/usecases/get_concrete_number_trivia_usecase.dart';
import 'get_concreate_number_trivia_test.mocks.dart';

@GenerateMocks([NumberTriviaRepository])
main() {
  MockNumberTriviaRepository mockNumberTriviaRepository =
      MockNumberTriviaRepository();
  final usecase = GetConcreteNumberTriviaUseCase(mockNumberTriviaRepository);
  final numberTrivia = NumberTrivia(number: 1, text: "test");

  test("should get trivia for the spcified number from the repository",
      () async {
    //  arrange
    when(mockNumberTriviaRepository.getConcreateNumberTrivia(any))
        .thenAnswer((_) async => Right(numberTrivia));
    //  act
    final result = await usecase(ConcreteNumberTriviaParams(number: 1));
    //  assert
    expect(result, Right(numberTrivia));
    verify(mockNumberTriviaRepository.getConcreateNumberTrivia(1));
    verifyNoMoreInteractions(mockNumberTriviaRepository);
  });

  test("should get failure object for the spcified number from the repository",
      () async {
    final failure = ServerFailure();
    when(mockNumberTriviaRepository.getConcreateNumberTrivia(any))
        .thenAnswer((_) async => Left(failure));

    //  act
    final result = await usecase(ConcreteNumberTriviaParams(number: 1));

    //  assert
    expect(result, Left(failure));
  });
}
