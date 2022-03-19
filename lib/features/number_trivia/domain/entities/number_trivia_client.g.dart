// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'number_trivia_client.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

class _NumberTriviaClient implements NumberTriviaClient {
  _NumberTriviaClient(this._dio, {this.baseUrl}) {
    baseUrl ??= 'http://numbersapi.com';
  }

  final Dio _dio;

  String? baseUrl;

  @override
  Future<HttpResponse<NumberTriviaModel>> getConcreteNumberTrivia(
      number) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'': number};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<HttpResponse<NumberTriviaModel>>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, '/',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = NumberTriviaModel.fromJson(_result.data!);
    final httpResponse = HttpResponse(value, _result);
    return httpResponse;
  }

  @override
  Future<HttpResponse<NumberTriviaModel>> getRandomNumberTrivia() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<HttpResponse<NumberTriviaModel>>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, '/random',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = NumberTriviaModel.fromJson(_result.data!);
    final httpResponse = HttpResponse(value, _result);
    return httpResponse;
  }

  RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
    if (T != dynamic &&
        !(requestOptions.responseType == ResponseType.bytes ||
            requestOptions.responseType == ResponseType.stream)) {
      if (T == String) {
        requestOptions.responseType = ResponseType.plain;
      } else {
        requestOptions.responseType = ResponseType.json;
      }
    }
    return requestOptions;
  }
}
