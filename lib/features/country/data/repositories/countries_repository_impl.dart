import 'package:dartz/dartz.dart';
import 'package:flagle/core/error/failures.dart';
import 'package:flagle/features/country/data/datasources/countries_local_datasource.dart';
import 'package:flagle/features/country/data/datasources/countries_remote_datasource.dart';
import 'package:flagle/features/country/domain/entities/country.dart';
import 'package:flagle/features/country/domain/repositories/countries_repository.dart';

class CountriesRepositoryImpl implements CountriesRepository {
  final CountriesLocalDatasource countriesLocalDatasource;
  final CountriesRemoteDatasource countriesRemoteDatasource;

  CountriesRepositoryImpl({
    required this.countriesLocalDatasource,
    required this.countriesRemoteDatasource,
  });

  @override
  Future<Either<Failure, List<Country>>> getAllCountries() async {
    try {
      List<Country> countries = await countriesLocalDatasource
          .getAllCountries();
      return Right(countries);
    } on LocalFailure catch (e) {
      return Left(LocalFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, Country>> getRandomCountry() async {
    try {
      Country country = await countriesLocalDatasource.getRandomCountry();
      String flagImageUrl = await countriesRemoteDatasource.getFlagImageUrl(
        country.alpha2Code,
      );

      country = Country(
        id: country.id,
        name: country.name,
        continent: country.continent,
        alpha2Code: country.alpha2Code,
        population: country.population,
        flagImageUrl: flagImageUrl,
      );

      return Right(country);
    } on LocalFailure catch (e) {
      return Left(LocalFailure(message: e.message));
    } catch (e) {
      return Left(LocalFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> saveAllCountries(
    List<Country> countries,
  ) async {
    try {
      await countriesLocalDatasource.saveAllCountries(countries);
      return Right(null);
    } on LocalFailure catch (e) {
      return Left(LocalFailure(message: e.message));
    } catch (e) {
      return Left(LocalFailure(message: e.toString()));
    }
  }
}
