import 'package:dartz/dartz.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia_clean_architecture_tdd/core/error/failure.dart';
import 'package:number_trivia_clean_architecture_tdd/core/params/concrete_number_trivia_params.dart';
import 'package:number_trivia_clean_architecture_tdd/core/params/no_params.dart';
import 'package:number_trivia_clean_architecture_tdd/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:number_trivia_clean_architecture_tdd/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:number_trivia_clean_architecture_tdd/features/number_trivia/domain/usecases/get_concrete_number_trivia_usecase.dart';
import 'package:number_trivia_clean_architecture_tdd/features/number_trivia/domain/usecases/get_random_number_trivia_usecase.dart';

import 'get_random_number_trivia_test.mocks.dart';

@GenerateMocks([NumberTriviaRepository])
main() {
  MockNumberTriviaRepository mockNumberTriviaRepository =
      MockNumberTriviaRepository();
  final usecase = GetRandomNumberTriviaUseCase(mockNumberTriviaRepository);
  final numberTrivia = NumberTrivia(number: 1, text: "test");

  test("should get random trivia from the repository", () async {
    //  arrange
    when(mockNumberTriviaRepository.getRandomNumberTrivia())
        .thenAnswer((_) async => Right(numberTrivia));
    //  act
    final result = await usecase(NoParams());
    //  assert
    expect(result, Right(numberTrivia));
    verify(mockNumberTriviaRepository.getRandomNumberTrivia());
    verifyNoMoreInteractions(mockNumberTriviaRepository);
  });

  test("should get ranidom failure object from the repository", () async {
    final failure = ServerFailure();
    when(mockNumberTriviaRepository.getRandomNumberTrivia())
        .thenAnswer((_) async => Left(failure));

    //  act
    final result = await usecase(NoParams());

    //  assert
    expect(result, Left(failure));
  });
}
