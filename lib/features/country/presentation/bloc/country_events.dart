import 'package:flagle/features/country/domain/entities/country.dart';

sealed class CountryEvent {}

// Main Country Events

class GetAllCountriesEvent extends CountryEvent {}

class SaveAllCountriesEvent extends CountryEvent {
  final List<Country> countries;

  SaveAllCountriesEvent({required this.countries});
}

// Guess Country Events

class GetRandomCountryEvent extends CountryEvent {}

class SkipCountryEvent extends CountryEvent {}

class IncrementCurrentTryEvent extends CountryEvent {}

class ResetCurrentTryEvent extends CountryEvent {}
