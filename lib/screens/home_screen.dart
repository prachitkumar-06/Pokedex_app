import 'dart:async';

import 'package:flutter/material.dart';

import '../models/pokemon.dart';
import '../services/pokemon_service.dart';
import '../widgets/pokemon_card.dart';
import 'pokemon_details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PokemonService _pokemonService = PokemonService();
  final TextEditingController _searchController = TextEditingController();

  List<Pokemon> _allPokemon = [];
  List<Pokemon> _filteredPokemon = [];

  String _selectedType = 'All';
  bool _isLoading = true;
  String? _errorMessage;
  Timer? _searchDebounce;

  static const List<String> _types = [
    'All',
    'Normal',
    'Fire',
    'Water',
    'Electric',
    'Grass',
    'Ice',
    'Fighting',
    'Poison',
    'Ground',
    'Flying',
    'Psychic',
    'Bug',
    'Rock',
    'Ghost',
    'Dragon',
    'Dark',
    'Steel',
    'Fairy',
  ];

  @override
  void initState() {
    super.initState();
    _loadPokemon();
  }

  Future<void> _loadPokemon() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final pokemon = await _pokemonService.getPokemonList(limit: 151);

      if (!mounted) return;

      setState(() {
        _allPokemon = pokemon;
        _isLoading = false;
      });
      _applyFilters();
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _errorMessage =
            'Could not load Pokémon. Check your internet connection and try again.';
      });
    }
  }

  void _onSearchChanged(String value) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(
      const Duration(milliseconds: 180),
      _applyFilters,
    );
  }

  void _applyFilters() {
    if (!mounted) return;

    final query = _searchController.text.trim().toLowerCase();
    final selectedType = _selectedType.toLowerCase();

    final filtered = _allPokemon.where((pokemon) {
      final matchesSearch =
          query.isEmpty || pokemon.name.toLowerCase().contains(query);

      final matchesType =
          selectedType == 'all' || pokemon.types.contains(selectedType);

      return matchesSearch && matchesType;
    }).toList();

    setState(() {
      _filteredPokemon = filtered;
    });
  }

  void _selectType(String type) {
    if (type == _selectedType) return;

    setState(() {
      _selectedType = type;
    });
    _applyFilters();
  }

  void _clearSearch() {
    _searchController.clear();
    _applyFilters();
    setState(() {});
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchController.dispose();
    _pokemonService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasSearch = _searchController.text.isNotEmpty;
    final resultCount = _filteredPokemon.length;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(hasSearch, resultCount),
            Expanded(child: _buildBody()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(bool hasSearch, int resultCount) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF3949AB), Color(0xFF5C6BC0)],
        ),
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(28),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.catching_pokemon_rounded,
                color: Colors.white,
                size: 31,
              ),
              SizedBox(width: 10),
              Text(
                'Pokédex',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 27,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            _isLoading
                ? 'Loading Pokémon...'
                : '$resultCount Pokémon displayed',
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 15),
          TextField(
            controller: _searchController,
            onChanged: _onSearchChanged,
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              hintText: 'Search by Pokémon name',
              prefixIcon: const Icon(Icons.search_rounded),
              suffixIcon: hasSearch
                  ? IconButton(
                      onPressed: _clearSearch,
                      icon: const Icon(Icons.close_rounded),
                    )
                  : null,
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(vertical: 2),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(17),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 13),
          SizedBox(
            height: 38,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _types.length,
              separatorBuilder: (_, _) => const SizedBox(width: 7),
              itemBuilder: (context, index) {
                final type = _types[index];
                final selected = type == _selectedType;

                return ChoiceChip(
                  label: Text(type),
                  selected: selected,
                  onSelected: (_) => _selectType(type),
                  selectedColor: Colors.white,
                  backgroundColor: Colors.white.withValues(alpha: 0.16),
                  side: BorderSide(
                    color: Colors.white.withValues(alpha: 0.20),
                  ),
                  labelStyle: TextStyle(
                    color: selected ? const Color(0xFF3949AB) : Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_errorMessage != null) {
      return _buildErrorState();
    }

    if (_filteredPokemon.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 24),
      itemCount: _filteredPokemon.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final pokemon = _filteredPokemon[index];

        return PokemonCard(
          pokemon: pokemon,
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => PokemonDetailsScreen(pokemon: pokemon),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.cloud_off_rounded,
              size: 70,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            const Text(
              'Unable to load Pokédex',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _errorMessage!,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade600,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 18),
            FilledButton.icon(
              onPressed: _loadPokemon,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 70,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 14),
            const Text(
              'No Pokémon found',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 7),
            Text(
              'Try another name or type filter.',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }
}
