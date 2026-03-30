# Screen Structure

## Rule

Follow the established screen layout pattern: private `_build*` methods for each section, SafeArea wrapping, and consistent spacing.

## Pattern

```dart
class FeatureScreen extends StatelessWidget {
  const FeatureScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF0A0D2E), Color(0xFF080B22)],
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.xl),
              _buildHeader(),
              // ... sections
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() { ... }
  Widget _buildContent() { ... }
}
```

## Conventions

- Each visual section is a private `_build*` method
- `SafeArea` wraps content on every screen
- `SingleChildScrollView` for scrollable content
- Horizontal padding: `AppSpacing.lg` (16) or `AppSpacing.xxl` (24)
- Section spacing: `SizedBox(height: AppSpacing.xxl)` between major sections
- Back button: 44x44 circle with `overlayWhiteSubtle` background
