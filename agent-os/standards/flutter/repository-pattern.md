# Repository Pattern

## Rule

All persistence goes through repository classes in `lib/data/repositories/`. Repositories are concrete classes (no abstract interfaces). They are injected into Riverpod providers via `ProviderScope.overrides` at bootstrap.

## Structure

```
lib/data/
├── repositories/
│   ├── app_state_repository.dart       # SharedPreferences-backed
│   ├── user_profile_repository.dart    # Hive-backed
│   ├── streak_repository.dart          # Hive-backed
│   └── repositories.dart               # Barrel export
└── data.dart                           # Barrel export
```

## Hive Repository Pattern

```dart
class MyRepository {
  MyRepository(this._box);
  final Box<MyModel> _box;
  static const _key = 'my_model';

  MyModel? get() => _box.get(_key);
  Future<void> save(MyModel model) => _box.put(_key, model);
  Future<void> delete() => _box.delete(_key);
}
```

## SharedPreferences Repository Pattern

```dart
class AppStateRepository {
  AppStateRepository(this._prefs);
  final SharedPreferences _prefs;

  AppState load() => AppState(
    myFlag: _prefs.getBool('my_flag') ?? false,
  );

  Future<void> save(AppState state) async {
    await _prefs.setBool('my_flag', state.myFlag);
  }
}
```

## Hive Model Convention

- Use `@HiveType(typeId: N)` and `@HiveField(N)` annotations
- Run `dart run build_runner build --delete-conflicting-outputs` to generate adapters
- Register adapters in `main()` before opening boxes
- Models extend `HiveObject` and have manual `copyWith` methods
