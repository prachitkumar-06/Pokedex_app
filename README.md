# 🎮 Pokédex — Flutter REST API App

<p align="center">
  <strong>A modern Flutter Pokédex powered by PokéAPI</strong><br>
  Search Pokémon instantly • Filter by type • Explore detailed stats
</p>

---

## ✨ Overview

**Pokédex** is a Flutter mobile application built as a **REST API Integration** project.

The app connects to **PokéAPI** to retrieve Pokémon data and presents it through a clean, responsive and user-friendly interface.

> **Project focus:** API integration, asynchronous programming, JSON parsing, local search/filtering, navigation and reusable Flutter widgets.

---

## 🚀 Features

| Feature | Description |
|---|---|
| 📋 Pokémon List | Displays Pokémon with ID, name, image and type |
| 🔎 Live Search | Search Pokémon by name while typing |
| 🏷️ Type Filter | Filter Pokémon by their type |
| 🔀 Combined Filtering | Search and type filtering work together |
| 👆 Interactive Cards | Tap a Pokémon to open its details |
| 📊 Base Stats | Displays HP, Attack, Defense, Speed and other stats |
| 📏 Physical Details | Shows height and weight |
| 🎨 Type-Based UI | Pokémon types use distinct visual styling |
| ⚡ Optimized Loading | Batched concurrent API requests using `Future.wait()` |
| 🛡️ Error Handling | User-friendly loading, error and empty-result states |
| 📱 Android Ready | Tested as a Flutter Android application |

---

## 🛠️ Tech Stack

- **Flutter**
- **Dart**
- **REST API**
- **PokéAPI**
- **HTTP package**
- **JSON**
- **Material 3**
- **Android**

---

## 🌐 API

This project uses:

**PokéAPI**

- Base API: https://pokeapi.co/api/v2/
- Documentation: https://pokeapi.co/docs/v2

The application retrieves Pokémon information through HTTP GET requests and converts the JSON response into Dart model objects.

---

## 🧩 Project Architecture

```text
lib/
├── main.dart
│
├── models/
│   └── pokemon.dart
│
├── services/
│   └── pokemon_service.dart
│
├── screens/
│   ├── home_screen.dart
│   └── pokemon_details_screen.dart
│
├── utils/
│   └── type_utils.dart
│
└── widgets/
    └── pokemon_card.dart
```

### Architecture flow

```text
PokéAPI
   ↓
HTTP GET
   ↓
PokemonService
   ↓
JSON Response
   ↓
Pokemon.fromJson()
   ↓
Pokemon Model
   ↓
Home / Details UI
```

---

## ⚡ Performance Optimization

Instead of making every Pokémon detail request sequentially, the application retrieves details in **small concurrent batches**.

Conceptually:

```text
Sequential:
Request 1 → Request 2 → Request 3 → ...

Optimized:
Request 1 ─┐
Request 2 ─┤
Request 3 ─┤ → Future.wait()
Request 4 ─┤
Request 5 ─┘
```

A short search debounce is also used to avoid unnecessary filtering work while the user is typing.

---

## 🔍 Search & Filtering

The home screen supports:

```text
Search by name
       +
Filter by type
       ↓
Final filtered Pokémon list
```

Filtering is performed locally on the already-loaded Pokémon data, avoiding a network request for every search character.

---

## 📱 Screens

### 🏠 Home Screen

- Pokédex header
- Search field
- Horizontal Pokémon type filters
- Pokémon cards
- Loading state
- Error state
- Empty-result state

### 🔎 Search & Filter

Users can enter a Pokémon name and select a type. Both conditions can be applied together.

### 📖 Pokémon Details

Displays:

- Pokémon image
- Pokémon ID
- Name
- Type
- Height
- Weight
- Base statistics
- Visual stat indicators

---

## 📦 Installation & Setup

### 1. Clone the repository

```bash
git clone https://github.com/prachitkumar-06/Pokedex_app.git
cd Pokedex
```

### 2. Install dependencies

```bash
flutter pub get
```

### 3. Run the application

```bash
flutter run
```

### 4. Analyze the project

```bash
flutter analyze
```

### 5. Build release APK

```bash
flutter build apk --release
```

APK output:

```text
build/app/outputs/flutter-apk/app-release.apk
```

---

## 📥 APK

A release APK is included with this repository under:

```text
release/Pokedex-v1.0.0.apk
```

You can download it directly from the repository's **release** folder, or from the GitHub Releases section if a release has been created.

---

## 🧪 Functional Checklist

- [x] Pokémon list
- [x] Pokémon name
- [x] Pokémon image
- [x] Pokémon ID
- [x] Pokémon type
- [x] Search by name
- [x] Search while typing
- [x] Type filtering
- [x] Search + type filtering
- [x] Pokémon detail screen
- [x] Height
- [x] Weight
- [x] Base stats
- [x] Navigation
- [x] API error handling
- [x] Optimized API loading
- [x] Android release build

---

## 📚 Concepts Demonstrated

This project demonstrates practical use of:

- Flutter widgets
- StatefulWidget
- StatelessWidget
- `setState()`
- `TextEditingController`
- `ListView.builder`
- `Navigator.push`
- `Navigator.pop`
- Dart classes and constructors
- Factory constructors
- JSON parsing
- REST APIs
- HTTP GET requests
- `Future`
- `async` / `await`
- `Future.wait()`
- Debouncing
- Exception handling
- Reusable widgets
- Material 3 UI
- Responsive layouts
- Release APK generation

---

## 🎯 Project Objective

The objective of this project is to demonstrate how a Flutter application can consume a REST API, transform JSON data into usable Dart models, and present that information through an interactive mobile UI.

---

## 👨‍💻 Developer

**Prachit Kumar**

B.Tech — Computer Science & Engineering (AI & ML)

---

## ⭐ If you found this project useful

Feel free to explore the code, test the APK and check out the implementation of the API integration.

**Built with Flutter • Powered by PokéAPI • Designed for learning**

