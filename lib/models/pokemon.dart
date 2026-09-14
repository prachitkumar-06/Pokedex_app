class Pokemon {
  final int id;
  final String name;
  final String imageUrl;
  final List<String> types;
  final int height;
  final int weight;
  final Map<String, int> stats;

  const Pokemon({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.types,
    required this.height,
    required this.weight,
    required this.stats,
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    final types = (json['types'] as List<dynamic>? ?? [])
        .map((item) {
          final type = item as Map<String, dynamic>;
          final typeData = type['type'] as Map<String, dynamic>? ?? {};
          return typeData['name']?.toString() ?? 'unknown';
        })
        .toList();

    final stats = <String, int>{};
    for (final item in json['stats'] as List<dynamic>? ?? []) {
      final stat = item as Map<String, dynamic>;
      final statData = stat['stat'] as Map<String, dynamic>? ?? {};
      final name = statData['name']?.toString();
      final value = stat['base_stat'];

      if (name != null && value is num) {
        stats[name] = value.toInt();
      }
    }

    final sprites = json['sprites'] as Map<String, dynamic>? ?? {};
    final other = sprites['other'] as Map<String, dynamic>? ?? {};
    final artwork =
        other['official-artwork'] as Map<String, dynamic>? ?? {};

    final imageUrl =
        artwork['front_default']?.toString() ??
        sprites['front_default']?.toString() ??
        '';

    return Pokemon(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name']?.toString() ?? 'unknown',
      imageUrl: imageUrl,
      types: types,
      height: (json['height'] as num?)?.toInt() ?? 0,
      weight: (json['weight'] as num?)?.toInt() ?? 0,
      stats: stats,
    );
  }
}
