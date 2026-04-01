# State Management

## Rule

Use Riverpod's modern Notifier API for all state management. Providers live in `lib/core/providers/`. Screens consume state via `ConsumerWidget` or `ConsumerStatefulWidget`.

## Provider Pattern

```dart
// Repository provider — overridden at bootstrap
final myRepositoryProvider = Provider<MyRepository>((ref) {
  throw UnimplementedError('must be overridden');
});

// State notifier provider
final myNotifierProvider =
    NotifierProvider<MyNotifier, MyState>(MyNotifier.new);

class MyNotifier extends Notifier<MyState> {
  @override
  MyState build() {
    final repo = ref.read(myRepositoryProvider);
    return repo.load();
  }

  Future<void> update(MyState newState) async {
    final repo = ref.read(myRepositoryProvider);
    await repo.save(newState);
    state = newState;
  }
}
```

## Bootstrap Override Pattern

Repositories are created in `main()` after Hive/SharedPreferences init, then injected via `ProviderScope.overrides`:

```dart
ProviderScope(
  overrides: [
    myRepositoryProvider.overrideWithValue(repo),
  ],
  child: const QuittrApp(),
)
```

## Screen Consumption

- Read-only display: `ref.watch(provider)` in `build()`
- Trigger actions: `ref.read(provider.notifier).method()` in callbacks
- Stateless screens → `ConsumerWidget`
- Screens with local UI state (e.g., text controllers) → `ConsumerStatefulWidget`

## Conventions

- One provider per file in `lib/core/providers/`
- Barrel export via `providers.dart`
- Use `Notifier` (not legacy `StateNotifier`)
- Nullable state (`MyType?`) when data may not exist yet (e.g., no user profile before quiz)
