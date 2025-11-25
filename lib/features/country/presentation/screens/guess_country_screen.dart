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
    if (countryNameController.text.toLowerCase() ==
        country.name.toLowerCase()) {
      context.read<CountryBloc>().add(GetRandomCountryEvent());
      countryNameController.clear();
    } else {
      context.read<CountryBloc>().add(IncrementCurrentTryEvent());
      ScaffoldMessenger.of(context)
          .showSnackBar(
            SnackBar(
              content: const Text('Incorrect answer'),
              duration: const Duration(seconds: 1),
            ),
          )
          .closed
          .whenComplete(() {
            countryNameController.clear();
          });
    }
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
            });
          }
        },
        builder: (context, state) {
          switch (state) {
            case CountryLoading():
              return const Center(child: CircularProgressIndicator());
            case GetRandomCountrySuccess():
              final country = state.country;
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (country.flagImageUrl.isNotEmpty)
                      SizedBox(
                        width: 200,
                        height: 150,
                        child: country.flagImageUrl.endsWith('.svg')
                            ? SvgPicture.network(
                                country.flagImageUrl,
                                placeholderBuilder: (context) =>
                                    const CircularProgressIndicator(),
                                fit: BoxFit.contain,
                              )
                            : Image.network(
                                country.flagImageUrl,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(Icons.error);
                                },
                                fit: BoxFit.contain,
                              ),
                      )
                    else
                      const Text('No flag image url found'),
                    const SizedBox(height: 20),
                    _CountryAutocomplete(
                      controller: countryNameController,
                      countryNames: _countryNames,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () => {_checkAnswer(country)},
                      child: const Text('Check Answer'),
                    ),
                    const SizedBox(height: 20),
                    Text('Current try: ${state.currentTry}'),
                    const SizedBox(height: 20),
                    if (state.currentTry > 1)
                      Text(
                        country.continent,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    const SizedBox(height: 20),
                    if (state.currentTry > 2)
                      Text(
                        country.population.toString(),
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    const SizedBox(height: 20),
                    if (state.currentTry > 3)
                      Text(
                        country.name,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ElevatedButton(
                      onPressed: () => context.read<CountryBloc>().add(
                        GetRandomCountryEvent(),
                      ),
                      child: const Text('Skip'),
                    ),
                  ],
                ),
              );
            case GetRandomCountryFailure():
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Error: ${state.failure.message}'),
                    const SizedBox(height: 20),
                    ElevatedButton(
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
