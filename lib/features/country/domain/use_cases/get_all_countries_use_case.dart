import 'package:dartz/dartz.dart';
import 'package:flagle/core/error/failures.dart';
import 'package:flagle/features/country/domain/entities/country.dart';
import 'package:flagle/features/country/domain/repositories/countries_repository.dart';

class GetAllCountriesUseCase {
  final CountriesRepository countriesRepository;

  GetAllCountriesUseCase({required this.countriesRepository});

  Future<Either<Failure, List<Country>>> call() async {
    return await countriesRepository.getAllCountries();
  }
}