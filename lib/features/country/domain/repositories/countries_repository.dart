import 'package:dartz/dartz.dart';
import 'package:flagle/core/error/failures.dart';
import 'package:flagle/features/country/domain/entities/country.dart';

abstract class CountriesRepository {
  Future<Either<Failure, List<Country>>> getAllCountries();
  Future<Either<Failure, Country>> getRandomCountry();
  Future<Either<Failure, void>> saveAllCountries(List<Country> countries);
}