import 'package:number_trivia_clean_architecture_tdd/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:number_trivia_clean_architecture_tdd/core/params/no_params.dart';
import 'package:number_trivia_clean_architecture_tdd/core/usecase/usecase.dart';
import 'package:number_trivia_clean_architecture_tdd/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:number_trivia_clean_architecture_tdd/features/number_trivia/domain/repositories/number_trivia_repository.dart';

class GetRandomNumberTriviaUseCase implements UseCase<NumberTrivia, NoParams> {
  NumberTriviaRepository repository;
  GetRandomNumberTriviaUseCase(this.repository);

  @override
  Future<Either<Failure, NumberTrivia>> call(NoParams params) async {
    return await repository.getRandomNumberTrivia();
  }
}
