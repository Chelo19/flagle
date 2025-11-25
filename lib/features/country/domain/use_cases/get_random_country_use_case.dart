import 'package:dartz/dartz.dart';
import 'package:flagle/core/error/failures.dart';
import 'package:flagle/features/country/domain/entities/country.dart';
import 'package:flagle/features/country/domain/repositories/countries_repository.dart';

class GetRandomCountryUseCase {
  final CountriesRepository countriesRepository;

  GetRandomCountryUseCase(this.countriesRepository);

  Future<Either<Failure, Country>> call() async {
    return await countriesRepository.getRandomCountry();
  }
}
