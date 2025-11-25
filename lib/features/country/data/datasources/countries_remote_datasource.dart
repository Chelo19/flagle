import 'package:dio/dio.dart';

abstract class CountriesRemoteDatasource {
  Future<String> getFlagImageUrl(String countryName);
}

// This refers to the remote data source that fetches the countries from the API
class CountriesRemoteDatasourceImpl implements CountriesRemoteDatasource {
  final Dio dio = Dio();

  final String baseUrl = 'https://api.api-ninjas.com/v1/';
  final String apiKey = 'rGUBqAnXhS2KhfoHG00cgA==Jq7jH4tp66XSy3hp';

  @override
  Future<String> getFlagImageUrl(String alpha2Code) async {
    final response = await dio.get(
      '$baseUrl/countryflag?country=$alpha2Code',
      options: Options(headers: {'X-Api-Key': apiKey}),
    );
    return response.data['rectangle_image_url'];
  }
}
