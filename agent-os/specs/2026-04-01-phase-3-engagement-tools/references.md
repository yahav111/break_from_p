# Phase 3 References

## Pattern References

### Data Layer Pattern (model + repo + provider)
- **Reference model**: `lib/core/models/relapse_data.dart` + `relapse_entry.dart`
- **Reference repo**: `lib/data/repositories/relapse_repository.dart`
- **Reference provider**: `lib/core/providers/relapse_provider.dart`
- **Key pattern**: Container model (RelapseData) holds List of entry models (RelapseEntry). Repo uses single key. Provider notifier has methods that read current state, create new entry, update via copyWith, save, set state.

### Screen Pattern
- **Reference**: `lib/features/home/home_screen.dart` (ConsumerStatefulWidget with live state)
- **Reference**: `lib/features/profile/profile_screen.dart` (ConsumerWidget, simpler)
- **Reference**: `lib/features/settings/settings_screen.dart` (back button, sections, dialogs)
- **Key pattern**: Gradient Container > SafeArea > SingleChildScrollView > Column with _build* methods.

### Integration Points
- **CopingPlaceholder**: `lib/features/panic_mode/widgets/coping_placeholder.dart` — replaced with CopingTools
- **Quick actions**: `lib/features/home/home_screen.dart:214-229` — wired onTap handlers
- **Bootstrap**: `lib/main.dart` — expanded from 6 to 9 Hive boxes, 7 to 10 provider overrides

### Design System
- **Barrel import**: `lib/design_system/design_system.dart`
- **Tokens**: `lib/design_system/tokens/` (colors, spacing, typography, radius, shadows)
- **Components**: `lib/design_system/components/` (buttons, cards, dialogs, navigation)
