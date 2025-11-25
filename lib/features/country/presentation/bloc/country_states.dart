import 'package:flagle/core/error/failures.dart';
import 'package:flagle/features/country/domain/entities/country.dart';

sealed class CountryState {
  get country => null;
  int currentTry = 0;
}

class CountryInitial extends CountryState {}

class CountryLoading extends CountryState {}

// Main Country States

class GetAllCountriesSuccess extends CountryState {
  final List<Country> countries;

  GetAllCountriesSuccess({required this.countries});
}

class GetAllCountriesFailure extends CountryState {
  final Failure failure;

  GetAllCountriesFailure({required this.failure});
}

class SaveAllCountriesSuccess extends CountryState {
  final List<Country> countries;

  SaveAllCountriesSuccess({required this.countries});
}

class SaveAllCountriesFailure extends CountryState {
  final Failure failure;

  SaveAllCountriesFailure({required this.failure});
}

// Guess Country States

class GetRandomCountrySuccess extends CountryState {
  final Country country;
  final int currentTry;
  GetRandomCountrySuccess({required this.country, this.currentTry = 0});
}

class GetRandomCountryFailure extends CountryState {
  final Failure failure;

  GetRandomCountryFailure({required this.failure});
}
