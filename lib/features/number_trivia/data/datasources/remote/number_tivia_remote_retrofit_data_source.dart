import 'dart:convert';

import 'package:retrofit/retrofit.dart';

import '../../../../../core/error/exceptions.dart';
import '../../../domain/entities/number_trivia_client.dart';
import '../../models/number_trivia_model.dart';
import 'number_trivia_remote_data_source.dart';

class NumberTriviaRemoteRetrofitDataSourceImpl
    implements NumberTriviaRemoteDataSource {
  NumberTriviaClient? numberTriviaClient;

  NumberTriviaRemoteRetrofitDataSourceImpl(this.numberTriviaClient);

  @override
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number) async {
    final HttpResponse<NumberTriviaModel> httpResponse =
        await numberTriviaClient!.getConcreteNumberTrivia(number);

    if (httpResponse.response.statusCode == 200) {
      return NumberTriviaModel.fromJson(
          json.decode(httpResponse.response.data));
    } else {
      throw ServerException();
    }
  }

  @override
  Future<NumberTriviaModel> getRandomNumberTrivia() {
    // TODO: implement getRandomNumberTrivia
    throw UnimplementedError();
  }
}
