# Pokédex Flutter App

A Flutter Pokédex app using the REST API provided by PokéAPI.

## Features
- Displays Pokémon with official artwork, ID, name and type.
- Search Pokémon by name as the user types.
- Filter Pokémon by type.
- Open a Pokémon to view detailed information.
- Shows height, weight and base stats.
- Handles loading, empty and network-error states.
- Uses batched parallel API requests for faster initial loading.
- Responsive Material 3 UI.

## API
PokéAPI: https://pokeapi.co/api/v2/

## Run
From the project root (the folder containing `pubspec.yaml`):

```bash
flutter pub get
flutter analyze
flutter run
```

## Build release APK

```bash
flutter clean
flutter pub get
flutter analyze
flutter build apk --release
```

APK output:
`build/app/outputs/flutter-apk/app-release.apk`

## Project structure

```text
lib/
├── main.dart
├── models/
│   └── pokemon.dart
├── services/
│   └── pokemon_service.dart
├── screens/
│   ├── home_screen.dart
│   └── pokemon_details_screen.dart
├── utils/
│   └── type_utils.dart
└── widgets/
    └── pokemon_card.dart
```
