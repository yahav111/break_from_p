import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/providers/journal_provider.dart';
import '../../design_system/design_system.dart';
import '../../routing/route_names.dart';
import 'widgets/journal_entry_card.dart';

/// Main Journal tab screen showing entries list with search and mood filtering.
class JournalScreen extends ConsumerStatefulWidget {
  const JournalScreen({super.key});

  @override
  ConsumerState<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends ConsumerState<JournalScreen> {
  final _searchController = TextEditingController();
  int? _selectedMoodFilter;
  String _searchText = '';

  static const _moodFilters = [
    _MoodFilter(null, 'הכל', null),
    _MoodFilter(4, 'מעולה', Icons.sentiment_very_satisfied),
    _MoodFilter(3, 'טוב', Icons.sentiment_satisfied),
    _MoodFilter(2, 'בסדר', Icons.sentiment_neutral),
    _MoodFilter(1, 'מתקשה', Icons.sentiment_dissatisfied),
    _MoodFilter(0, 'רע', Icons.sentiment_very_dissatisfied),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final journalData = ref.watch(journalNotifierProvider);
    final allEntries = journalData?.entries ?? [];

    // Apply filters.
    final filteredEntries = allEntries.where((entry) {
      // Mood filter.
      if (_selectedMoodFilter != null && entry.mood != _selectedMoodFilter) {
        return false;
      }
      // Search filter.
      if (_searchText.isNotEmpty) {
        final query = _searchText.toLowerCase();
        return entry.content.toLowerCase().contains(query) ||
            (entry.prompt?.toLowerCase().contains(query) ?? false);
      }
      return true;
    }).toList();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height,
        ),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0A0D2E), Color(0xFF080B22)],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: AppSpacing.xl),
                  _buildHeader(),
                  const SizedBox(height: AppSpacing.lg),
                  _buildSearchBar(),
                  const SizedBox(height: AppSpacing.md),
                  _buildMoodFilters(),
                  const SizedBox(height: AppSpacing.lg),
                  Expanded(
                    child: filteredEntries.isEmpty
                        ? _buildEmptyState()
                        : _buildEntryList(filteredEntries),
                  ),
                ],
              ),
              Positioned(
                right: AppSpacing.lg,
                bottom: AppSpacing.lg,
                child: _buildFab(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'יומן',
            style: AppTypography.headlineLarge.copyWith(
              color: Colors.white,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'הרהר על המסע שלך',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.darkTextSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: TextField(
        controller: _searchController,
        onChanged: (value) => setState(() => _searchText = value),
        style: AppTypography.bodyMedium.copyWith(color: Colors.white),
        decoration: InputDecoration(
          hintText: 'חפש רשומות...',
          hintStyle: AppTypography.bodyMedium.copyWith(
            color: AppColors.darkTextTertiary,
          ),
          filled: true,
          fillColor: AppColors.darkCard,
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: AppColors.darkTextSecondary,
            size: 22,
          ),
          suffixIcon: _searchText.isNotEmpty
              ? IconButton(
                  icon: const Icon(
                    Icons.close_rounded,
                    color: AppColors.darkTextSecondary,
                    size: 20,
                  ),
                  onPressed: () {
                    _searchController.clear();
                    setState(() => _searchText = '');
                  },
                )
              : null,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xl,
            vertical: AppSpacing.lg,
          ),
          border: OutlineInputBorder(
            borderRadius: AppRadius.borderPill,
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: AppRadius.borderPill,
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: AppRadius.borderPill,
            borderSide: const BorderSide(
              color: AppColors.primary,
              width: 2,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMoodFilters() {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        itemCount: _moodFilters.length,
        separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
        itemBuilder: (context, index) {
          final filter = _moodFilters[index];
          final isSelected = _selectedMoodFilter == filter.mood;

          return FilterChip(
            label: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (filter.icon != null) ...[
                  Icon(
                    filter.icon,
                    size: 16,
                    color: isSelected
                        ? Colors.white
                        : AppColors.darkTextSecondary,
                  ),
                  const SizedBox(width: AppSpacing.xs),
                ],
                Text(filter.label),
              ],
            ),
            selected: isSelected,
            onSelected: (_) {
              setState(() {
                _selectedMoodFilter = isSelected ? null : filter.mood;
              });
            },
            backgroundColor: AppColors.darkCard,
            selectedColor: AppColors.primary,
            labelStyle: AppTypography.caption.copyWith(
              color: isSelected ? Colors.white : AppColors.darkTextSecondary,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: AppRadius.borderPill,
              side: BorderSide(
                color: isSelected
                    ? AppColors.primary
                    : AppColors.darkBorderSubtle,
              ),
            ),
            showCheckmark: false,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.xs,
            ),
          );
        },
      ),
    );
  }

  Widget _buildEntryList(List<dynamic> entries) {
    return ListView.separated(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.lg,
        0,
        AppSpacing.lg,
        // Extra bottom padding so last card isn't hidden behind FAB.
        80,
      ),
      itemCount: entries.length,
      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
      itemBuilder: (context, index) {
        final entry = entries[index];
        return JournalEntryCard(
          entry: entry,
          onTap: () {
            // Navigate to view/edit entry (future enhancement).
          },
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.edit_note_rounded,
            size: 64,
            color: AppColors.darkTextTertiary,
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'התחל ליומן',
            style: AppTypography.titleMedium.copyWith(
              color: Colors.white,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'כתוב את הרשומה הראשונה שלך כדי להתחיל\nלעקוב אחר המסע שלך',
            textAlign: TextAlign.center,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.darkTextSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFab(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(Routes.journalEntry),
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.gradientStart, AppColors.gradientEnd],
          ),
          shape: BoxShape.circle,
          boxShadow: AppShadows.gradientGlow,
        ),
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 28,
        ),
      ),
    );
  }
}

class _MoodFilter {
  const _MoodFilter(this.mood, this.label, this.icon);

  final int? mood;
  final String label;
  final IconData? icon;
}
