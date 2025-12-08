import 'package:flagle/features/country/domain/entities/country.dart';
import 'package:flagle/features/country/presentation/bloc/country_bloc.dart';
import 'package:flagle/features/country/presentation/bloc/country_events.dart';
import 'package:flagle/features/country/presentation/bloc/country_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GuessCountryScreen extends StatefulWidget {
  const GuessCountryScreen({super.key});

  @override
  State<GuessCountryScreen> createState() => _GuessCountryScreenState();
}

class _GuessCountryScreenState extends State<GuessCountryScreen> {
  final TextEditingController countryNameController = TextEditingController();
  List<String> _countryNames = [];
  List<String> _remainingCountryNames = [];
  List<String> _selectedCountryNames = [];

  @override
  void initState() {
    super.initState();
    // Obtener un país aleatorio y la lista de países cuando se inicializa la pantalla
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final bloc = context.read<CountryBloc>();
      bloc.add(GetRandomCountryEvent());
      bloc.add(GetAllCountriesEvent());
    });
  }

  @override
  void dispose() {
    countryNameController.dispose();
    super.dispose();
  }

  void _checkAnswer(Country country) {
    final selectedCountry = countryNameController.text;
    final countryInList = _remainingCountryNames.firstWhere(
      (country) => country.toLowerCase() == selectedCountry.toLowerCase(),
      orElse: () => '',
    );

    if (countryInList.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Country not in remaining countries'),
          duration: const Duration(seconds: 1),
        ),
      );
      return;
    }
    if (selectedCountry.toLowerCase() == country.name.toLowerCase()) {
      // Respuesta correcta: resetear todo y obtener nuevo país
      _onSuccessTry();
    } else {
      // Respuesta incorrecta: eliminar el país del pool de opciones
      setState(() {
        _remainingCountryNames.remove(countryInList);
        _selectedCountryNames.add(countryInList);
      });
      countryNameController.clear();
      context.read<CountryBloc>().add(IncrementCurrentTryEvent());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Incorrect answer'),
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }

  void _skipCountry() {
    setState(() {
      _remainingCountryNames = List<String>.from(_countryNames);
      _selectedCountryNames.clear();
    });
    context.read<CountryBloc>().add(GetRandomCountryEvent());
    countryNameController.clear();
  }

  void _onSuccessTry() {
    setState(() {
      _remainingCountryNames = List<String>.from(_countryNames);
      _selectedCountryNames.clear();
    });
    context.read<CountryBloc>().add(GetRandomCountryEvent());
    countryNameController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Guess Country'),
        leading: IconButton(
          onPressed: () => Scaffold.of(context).openDrawer(),
          icon: const Icon(Icons.menu),
        ),
      ),
      body: BlocConsumer<CountryBloc, CountryState>(
        listener: (context, state) {
          // Actualizar la lista de nombres de países cuando se cargan
          if (state is GetAllCountriesSuccess) {
            setState(() {
              _countryNames = state.countries.map((c) => c.name).toList();
              _remainingCountryNames = List<String>.from(_countryNames);
            });
          }
        },
        builder: (context, state) {
          switch (state) {
            case CountryLoading():
              return const Center(child: CircularProgressIndicator());
            case GetRandomCountrySuccess():
              final country = state.country;
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  child: Column(
                    spacing: 16,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (country.flagImageUrl.isNotEmpty)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            width: double.infinity,
                            height: 250,
                            color: Theme.of(context).colorScheme.secondary,
                            child: country.flagImageUrl.endsWith('.svg')
                                ? SvgPicture.network(
                                    country.flagImageUrl,
                                    placeholderBuilder: (context) =>
                                        const CircularProgressIndicator(),
                                    fit: BoxFit.fill,
                                  )
                                : Image.network(
                                    country.flagImageUrl,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Icon(Icons.error);
                                    },
                                    fit: BoxFit.contain,
                                  ),
                          ),
                        )
                      else
                        const Text('No flag image url found'),
                      Text('Current try: ${state.currentTry}'),
                      Row(
                        spacing: 8,
                        children: <Widget>[
                          if (state.currentTry > 1)
                            _HintComponent(hint: '🗺️ ${country.continent}'),
                          if (state.currentTry > 2)
                            _HintComponent(
                              hint: '👥 ${country.population.toString()}',
                            ),
                          if (state.currentTry > 3)
                            _HintComponent(hint: '🚩 ${country.name}'),
                        ],
                      ),
                      Column(
                        spacing: 8,
                        children: [
                          for (var selectedCountry in _selectedCountryNames)
                            _SelectedCountryComponent(
                              countryName: selectedCountry,
                            ),
                        ],
                      ),
                      _CountryAutocomplete(
                        controller: countryNameController,
                        countryNames: _remainingCountryNames,
                      ),
                      Row(
                        spacing: 8,
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).colorScheme.secondary,
                                minimumSize: const Size(0, 36.0),
                              ),
                              onPressed: () => _skipCountry(),
                              child: Text('Skip', style: TextStyle(color: Theme.of(context).colorScheme.onSecondary)),
                            ),
                          ),
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(
                                  context,
                                ).colorScheme.primary,
                                foregroundColor: Theme.of(
                                  context,
                                ).colorScheme.onPrimary,
                                minimumSize: const Size(0, 36.0),
                              ),
                              onPressed: () => _checkAnswer(country),
                              child: Text('Check Answer', style: TextStyle(color: Theme.of(context).colorScheme.onPrimary)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            case GetRandomCountryFailure():
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Error: ${state.failure.message}'),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 36.0),
                      ),
                      onPressed: () =>
                          context.read<CountryBloc>().add(SkipCountryEvent()),
                      child: const Text('Try Again'),
                    ),
                  ],
                ),
              );
            default:
              return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

class _CountryAutocomplete extends StatelessWidget {
  final TextEditingController controller;
  final List<String> countryNames;

  const _CountryAutocomplete({
    required this.controller,
    required this.countryNames,
  });

  @override
  Widget build(BuildContext context) {
    return Autocomplete<String>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text.isEmpty) {
          return const Iterable<String>.empty();
        }
        // Filtrar países que contengan el texto ingresado (case insensitive)
        return countryNames.where(
          (country) => country.toLowerCase().contains(
            textEditingValue.text.toLowerCase(),
          ),
        );
      },
      onSelected: (String selection) {
        controller.text = selection;
      },
      fieldViewBuilder:
          (
            BuildContext context,
            TextEditingController textEditingController,
            FocusNode focusNode,
            VoidCallback onFieldSubmitted,
          ) {
            // Sincronizar el controller externo con el interno del Autocomplete
            if (controller.text != textEditingController.text) {
              textEditingController.text = controller.text;
            }
            return TextFormField(
              controller: textEditingController,
              focusNode: focusNode,
              decoration: const InputDecoration(
                labelText: 'Country Name',
                hintText: 'Type to search...',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onFieldSubmitted: (String value) {
                onFieldSubmitted();
              },
            );
          },
      optionsViewBuilder: (context, onSelected, options) {
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            elevation: 4.0,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 200),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: options.length,
                itemBuilder: (context, index) {
                  final option = options.elementAt(index);
                  return ListTile(
                    title: Text(option),
                    onTap: () => onSelected(option),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

class _HintComponent extends StatelessWidget {
  final String hint;

  const _HintComponent({required this.hint});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Text(
              hint,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSecondary,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SelectedCountryComponent extends StatelessWidget {
  final String countryName;
  const _SelectedCountryComponent({required this.countryName});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minWidth: double.infinity, minHeight: 36.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          spacing: 8,
          children: [
            Icon(
              Icons.wrong_location,
              color: Theme.of(context).colorScheme.onSecondary,
            ),
            Text(
              countryName,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
