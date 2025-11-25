import 'package:flagle/features/country/data/datasources/countries_local_datasource.dart';
import 'package:flagle/features/country/data/datasources/countries_remote_datasource.dart';
import 'package:flagle/features/country/data/repositories/countries_repository_impl.dart';
import 'package:flagle/features/country/domain/repositories/countries_repository.dart';
import 'package:flagle/features/country/domain/use_cases/get_all_countries_use_case.dart';
import 'package:flagle/features/country/domain/use_cases/get_random_country_use_case.dart';
import 'package:flagle/features/country/domain/use_cases/save_all_countries_use_case.dart';
import 'package:flagle/features/country/presentation/bloc/country_bloc.dart';
import 'package:flutter/rendering.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';

final dependencyInjection = GetIt.instance;

Future<void> init() async {
  // Initialize Hive before registering any dependencies that use it
  await Hive.initFlutter();

  // Initialize countries box with data if empty
  await _initializeCountriesBox();
  // Blocs
  dependencyInjection.registerFactory(
    () => CountryBloc(
      dependencyInjection(),
      dependencyInjection(),
      dependencyInjection(),
    ),
  );

  // Use cases
  dependencyInjection.registerLazySingleton(
    () => GetAllCountriesUseCase(countriesRepository: dependencyInjection()),
  );
  dependencyInjection.registerLazySingleton(
    () => GetRandomCountryUseCase(dependencyInjection()),
  );
  dependencyInjection.registerLazySingleton(
    () => SaveAllCountriesUseCase(dependencyInjection()),
  );

  // Repositories
  dependencyInjection.registerLazySingleton<CountriesRepository>(
    () => CountriesRepositoryImpl(
      countriesLocalDatasource: dependencyInjection(),
      countriesRemoteDatasource: dependencyInjection(),
    ),
  );

  // Data sources
  dependencyInjection.registerLazySingleton<CountriesLocalDatasource>(
    () => HiveCountriesLocalDatasourceImpl(),
  );
  dependencyInjection.registerLazySingleton<CountriesRemoteDatasource>(
    () => CountriesRemoteDatasourceImpl(),
  );
}

Future<void> _initializeCountriesBox() async {
  try {
    final Box<dynamic> box = await Hive.openBox('countries');

    // Check if box is empty
    if (box.isEmpty) {
      // Get data from local datasource
      final localDatasource = HiveCountriesLocalDatasourceImpl();
      final countries = await localDatasource.getAllCountries();

      // Save to local storage
      await localDatasource.saveAllCountries(countries);

      debugPrint(
        'Countries box initialized with ${countries.length} countries',
      );
    } else {
      debugPrint('Countries box already contains ${box.length} countries');
    }
  } catch (e) {
    debugPrint('Error initializing countries box: $e');
    // Don't throw, just log the error so the app can still start
  }
}
