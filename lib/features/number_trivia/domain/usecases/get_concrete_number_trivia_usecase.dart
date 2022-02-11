import 'package:dartz/dartz.dart';
import 'package:number_trivia_clean_architecture_tdd/core/params/concrete_number_trivia_params.dart';
import 'package:number_trivia_clean_architecture_tdd/core/usecase/usecase.dart';

import '../../../../core/error/failure.dart';
import '../entities/number_trivia.dart';
import '../repositories/number_trivia_repository.dart';

class GetConcreteNumberTriviaUseCase
    implements UseCase<NumberTrivia, ConcreteNumberTriviaParams> {
  NumberTriviaRepository repository;
  GetConcreteNumberTriviaUseCase(this.repository);

  @override
  Future<Either<Failure, NumberTrivia>> call(params) async {
    return await repository.getConcreateNumberTrivia(params.number!);
  }
}
