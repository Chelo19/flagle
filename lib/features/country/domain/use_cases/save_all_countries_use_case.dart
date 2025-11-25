import 'package:dartz/dartz.dart';
import 'package:flagle/core/error/failures.dart';
import 'package:flagle/features/country/domain/entities/country.dart';
import 'package:flagle/features/country/domain/repositories/countries_repository.dart';

class SaveAllCountriesUseCase {
  final CountriesRepository countriesRepository;

  SaveAllCountriesUseCase(this.countriesRepository);

  Future<Either<Failure, void>> call(List<Country> countries) async {
    return await countriesRepository.saveAllCountries(countries);
  }
}