import 'dart:math' as math;

import 'package:flagle/core/error/failures.dart';
import 'package:flagle/features/country/data/countries_list.dart';
import 'package:flagle/features/country/data/models/country_model.dart';
import 'package:flagle/features/country/domain/entities/country.dart';
import 'package:flutter/rendering.dart';
import 'package:hive_flutter/hive_flutter.dart';

abstract class CountriesLocalDatasource {
  Future<List<CountryModel>> getAllCountries();
  Future<CountryModel> getRandomCountry();
  Future<void> saveAllCountries(List<Country> countries);
}

class HiveCountriesLocalDatasourceImpl implements CountriesLocalDatasource {
  HiveCountriesLocalDatasourceImpl();

  @override
  Future<List<CountryModel>> getAllCountries() async {
    try {
      Box<dynamic> box = await Hive.openBox('countries');
      if (box.values.isEmpty) {
        return countriesList
            .map((country) => CountryModel.fromJson(country))
            .toList();
      }
      final countries = box.values
          .map(
            (country) => CountryModel.fromJson(
              Map<String, dynamic>.from(country as Map),
            ),
          )
          .toList();
      return countries;
    } catch (e) {
      debugPrint('Error getting all countries: $e');
      throw LocalFailure(message: e.toString());
    }
  }

  @override
  Future<CountryModel> getRandomCountry() async {
    try {
      Box<dynamic> box = await Hive.openBox('countries');
      final countryData = box.values.toList().elementAt(
        math.Random().nextInt(box.values.length),
      );
      return CountryModel.fromJson(Map<String, dynamic>.from(countryData as Map));
    } catch (e) {
      debugPrint('Error getting random country: $e');
      throw LocalFailure(message: e.toString());
    }
  }

  @override
  Future<void> saveAllCountries(List<Country> countries) async {
    try {
      Box<dynamic> box = await Hive.openBox('countries');
      for (var country in countries) {
        final countryModel = CountryModel.fromEntity(country);
        await box.put(countryModel.alpha2Code, countryModel.toJson());
      }
    } catch (e) {
      debugPrint('Error saving all countries: $e');
      throw LocalFailure(message: e.toString());
    }
  }
}
