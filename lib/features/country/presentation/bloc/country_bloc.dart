import 'package:flagle/features/country/domain/use_cases/get_all_countries_use_case.dart';
import 'package:flagle/features/country/domain/use_cases/get_random_country_use_case.dart';
import 'package:flagle/features/country/domain/use_cases/save_all_countries_use_case.dart';
import 'package:flagle/features/country/presentation/bloc/country_events.dart';
import 'package:flagle/features/country/presentation/bloc/country_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CountryBloc extends Bloc<CountryEvent, CountryState> {
  final GetAllCountriesUseCase getAllCountriesUseCase;
  final GetRandomCountryUseCase getRandomCountryUseCase;
  final SaveAllCountriesUseCase saveAllCountriesUseCase;

  CountryBloc(
    this.getAllCountriesUseCase,
    this.getRandomCountryUseCase,
    this.saveAllCountriesUseCase,
  ) : super(CountryInitial()) {
    // Main Country Events

    on<GetAllCountriesEvent>((event, emit) async {
      emit(CountryLoading());

      final resp = await getAllCountriesUseCase.call();

      resp.fold(
        (failure) => emit(GetAllCountriesFailure(failure: failure)),
        (countries) => emit(GetAllCountriesSuccess(countries: countries)),
      );
    });

    on<SaveAllCountriesEvent>((event, emit) async {
      emit(CountryLoading());

      final resp = await saveAllCountriesUseCase.call(event.countries);

      resp.fold(
        (failure) => emit(SaveAllCountriesFailure(failure: failure)),
        (_) => emit(SaveAllCountriesSuccess(countries: event.countries)),
      );
    });

    // Guess Country Events

    on<GetRandomCountryEvent>((_, emit) async {
      emit(CountryLoading());

      final resp = await getRandomCountryUseCase.call();

      resp.fold(
        (failure) => emit(GetRandomCountryFailure(failure: failure)),
        (country) => emit(GetRandomCountrySuccess(country: country)),
      );
    });

    on<SkipCountryEvent>((_, emit) async {
      emit(CountryLoading());

      final resp = await getRandomCountryUseCase.call();

      resp.fold(
        (failure) => emit(GetRandomCountryFailure(failure: failure)),
        (country) => emit(GetRandomCountrySuccess(country: country)),
      );
    });

    on<IncrementCurrentTryEvent>((_, emit) async {
      emit(
        GetRandomCountrySuccess(
          country: state.country,
          currentTry: state.currentTry + 1,
        ),
      );
    });

    on<ResetCurrentTryEvent>((_, emit) async {
      emit(GetRandomCountrySuccess(country: state.country, currentTry: 0));
    });
  }
}
