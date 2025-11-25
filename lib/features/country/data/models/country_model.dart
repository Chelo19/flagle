import 'package:flagle/features/country/domain/entities/country.dart';

class CountryModel extends Country {
  CountryModel({
    required super.id,
    required super.name,
    required super.continent,
    required super.alpha2Code,
    required super.population,
    required super.flagImageUrl,
  });

  factory CountryModel.fromJson(Map<String, dynamic> json) {
    return CountryModel(
      id: json['id'] as int,
      name: json['name'] as String,
      continent: json['continent'] as String,
      alpha2Code: json['alpha2Code'] as String,
      population: json['population'] as int,
      flagImageUrl: json['flagImageUrl'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'continent': continent,
      'alpha2Code': alpha2Code,
      'population': population,
      'flagImageUrl': flagImageUrl,
    };
  }

  factory CountryModel.fromEntity(Country country) {
    return CountryModel(
      id: country.id,
      name: country.name,
      continent: country.continent,
      alpha2Code: country.alpha2Code,
      population: country.population,
      flagImageUrl: country.flagImageUrl,
    );
  }
}
