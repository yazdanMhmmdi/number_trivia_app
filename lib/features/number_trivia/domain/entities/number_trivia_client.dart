import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../../data/models/number_trivia_model.dart';
part 'number_trivia_client.g.dart';

@RestApi(baseUrl: "http://numbersapi.com")
abstract class NumberTriviaClient {
  factory NumberTriviaClient(Dio dio, {String baseUrl}) = _NumberTriviaClient;

  @GET('/')
  Future<HttpResponse<NumberTriviaModel>> getConcreteNumberTrivia(
      @Query("") int number);
  @GET('/random')
  Future<HttpResponse<NumberTriviaModel>> getRandomNumberTrivia();
}
