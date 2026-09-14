import 'package:flutter/material.dart';

import '../models/pokemon.dart';
import '../utils/type_utils.dart';

class PokemonDetailsScreen extends StatelessWidget {
  final Pokemon pokemon;

  const PokemonDetailsScreen({
    super.key,
    required this.pokemon,
  });

  @override
  Widget build(BuildContext context) {
    final primaryType = pokemon.types.isNotEmpty ? pokemon.types.first : 'normal';
    final accent = TypeUtils.color(primaryType);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 355,
            pinned: true,
            elevation: 0,
            foregroundColor: Colors.white,
            backgroundColor: accent,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsetsDirectional.fromSTEB(
                20,
                0,
                20,
                16,
              ),
              title: Text(
                TypeUtils.capitalize(pokemon.name),
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                ),
              ),
              background: _buildHero(accent),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(18, 20, 18, 30),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildIdentity(),
                const SizedBox(height: 20),
                _buildMeasurements(),
                const SizedBox(height: 26),
                _buildStats(context, accent),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHero(Color accent) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            accent,
            accent.withValues(alpha: 0.72),
          ],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -35,
            top: 35,
            child: Icon(
              Icons.catching_pokemon_rounded,
              size: 190,
              color: Colors.white.withValues(alpha: 0.10),
            ),
          ),
          Center(
            child: Hero(
              tag: 'pokemon-${pokemon.id}',
              child: Container(
                width: 245,
                height: 245,
                margin: const EdgeInsets.only(top: 42),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.14),
                  shape: BoxShape.circle,
                ),
                child: pokemon.imageUrl.isEmpty
                    ? const Icon(
                        Icons.catching_pokemon_rounded,
                        color: Colors.white70,
                        size: 100,
                      )
                    : Image.network(
                        pokemon.imageUrl,
                        fit: BoxFit.contain,
                        errorBuilder: (_, _, _) => const Icon(
                          Icons.image_not_supported_outlined,
                          color: Colors.white70,
                          size: 80,
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIdentity() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '#${pokemon.id.toString().padLeft(3, '0')}',
          style: TextStyle(
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 7),
        Text(
          TypeUtils.capitalize(pokemon.name),
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: pokemon.types
              .map(
                (type) => Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: TypeUtils.color(type),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    TypeUtils.capitalize(type),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  Widget _buildMeasurements() {
    return Row(
      children: [
        Expanded(
          child: _InfoCard(
            icon: Icons.height_rounded,
            label: 'Height',
            value: '${(pokemon.height / 10).toStringAsFixed(1)} m',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _InfoCard(
            icon: Icons.monitor_weight_outlined,
            label: 'Weight',
            value: '${(pokemon.weight / 10).toStringAsFixed(1)} kg',
          ),
        ),
      ],
    );
  }

  Widget _buildStats(BuildContext context, Color accent) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Base Stats',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 15),
        ...pokemon.stats.entries.map(
          (entry) => _StatRow(
            name: TypeUtils.formatStatName(entry.key),
            value: entry.value,
            accent: accent,
          ),
        ),
      ],
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 17, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Icon(icon, color: const Color(0xFF3949AB), size: 27),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  final String name;
  final int value;
  final Color accent;

  const _StatRow({
    required this.name,
    required this.value,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    final progress = (value / 150).clamp(0.0, 1.0);

    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  name,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
              Text(
                value.toString(),
                style: TextStyle(
                  color: accent,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 7),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 9,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(accent),
            ),
          ),
        ],
      ),
    );
  }
}
