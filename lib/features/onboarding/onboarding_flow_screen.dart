import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/providers/app_state_provider.dart';
import '../../core/providers/streak_provider.dart';
import '../../core/providers/user_profile_provider.dart';
import '../../data/sync/sync_engine.dart';
import '../../infrastructure/auth/auth_provider.dart';
import '../../infrastructure/auth/auth_state.dart';
import '../../routing/route_names.dart';
import 'onboarding_flow_provider.dart';
import 'phases/phase_a_welcome/auth_sign_up_page.dart';
import 'phases/phase_a_welcome/profile_card_preview_page.dart';
import 'phases/phase_b_quiz/extended_quiz_page.dart';
import 'phases/phase_b_quiz/extended_quiz_provider.dart';
import 'phases/phase_c_analysis/analysis_complete_page.dart';
import 'phases/phase_c_analysis/calculating_page.dart';
import 'phases/phase_c_analysis/symptoms_selection_page.dart';
import 'phases/phase_d_education/education_carousel_page.dart';
import 'phases/phase_e_features/feature_showcase_page.dart';
import 'phases/phase_f_social_proof/expert_quotes_page.dart';
import 'phases/phase_f_social_proof/goals_selection_page.dart';
import 'phases/phase_f_social_proof/recovery_graph_page.dart';
import 'phases/phase_f_social_proof/testimonials_page.dart';
import 'phases/phase_g_notifications/notification_permission_page.dart';
import 'phases/phase_h_paywall/build_relationships_page.dart';
import 'phases/phase_h_paywall/choose_plan_page.dart';
import 'phases/phase_h_paywall/custom_plan_page.dart';
import 'phases/phase_h_paywall/invest_in_yourself_page.dart';
import 'phases/phase_h_paywall/recovery_plan_page.dart';
import 'phases/phase_h_paywall/recovery_plan_provider.dart';
import 'phases/phase_h_paywall/welcome_video_page.dart';

/// Main orchestrator for the entire onboarding flow.
/// Uses a PageView with physics:NeverScrollable, advancing programmatically.
class OnboardingFlowScreen extends ConsumerStatefulWidget {
  const OnboardingFlowScreen({super.key});

  @override
  ConsumerState<OnboardingFlowScreen> createState() =>
      _OnboardingFlowScreenState();
}

class _OnboardingFlowScreenState extends ConsumerState<OnboardingFlowScreen> {
  late PageController _pageController;
  // ignore: unused_field — stored for potential future use in OnboardingData.
  List<String> _selectedSymptoms = [];
  bool _completing = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToPage(int page) {
    if (_pageController.hasClients) {
      _pageController.animateToPage(
        page,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    }
  }

  void _nextPage() {
    // Dismiss keyboard before page transition.
    FocusScope.of(context).unfocus();
    ref.read(onboardingFlowProvider.notifier).nextPage();
    final newIndex = ref.read(onboardingFlowProvider).pageIndex;
    _goToPage(newIndex);
  }

  void _previousPage() {
    ref.read(onboardingFlowProvider.notifier).previousPage();
    final newIndex = ref.read(onboardingFlowProvider).pageIndex;
    _goToPage(newIndex);
  }

  Future<void> _completeOnboarding() async {
    if (_completing) return;
    _completing = true;

    final quizState = ref.read(extendedQuizProvider);
    final selectedGoals = ref.read(selectedGoalsProvider);

    // Create user profile.
    await ref.read(userProfileNotifierProvider.notifier).createProfile(
          name: quizState.name.isNotEmpty ? quizState.name : 'חבר',
          quitDate: DateTime.now(),
          quizAnswers: quizState.answers,
          gender: quizState.gender,
          age: quizState.age,
          selectedGoals: selectedGoals,
        );

    // Start streak from now.
    await ref
        .read(streakNotifierProvider.notifier)
        .startStreak(DateTime.now());

    // Complete onboarding.
    await ref.read(appStateNotifierProvider.notifier).completeOnboarding();

    // Attempt sync.
    try {
      final authState = ref.read(authNotifierProvider);
      if (authState.status == AuthStatus.anonymous) {
        await ref.read(syncEngineProvider.notifier).migrateLocalToCloud();
      } else if (authState.status == AuthStatus.authenticated) {
        await ref.read(syncEngineProvider.notifier).migrateLocalToCloud();
      }
    } catch (_) {
      // Sync failure should not block navigation.
    }

    if (mounted) context.go(Routes.home);
  }

  @override
  Widget build(BuildContext context) {
    final quizState = ref.watch(extendedQuizProvider);
    final userName = quizState.name;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0D2E),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          // ── Phase A (0-1) ──
          // Page 0: Auth sign up
          AuthSignUpPage(
            onComplete: _nextPage,
            onSignIn: () => context.go('${Routes.auth}?mode=signIn'),
          ),
          // Page 1: Profile card preview
          ProfileCardPreviewPage(
            onNext: _nextPage,
            userName: userName,
          ),

          // ── Phase B (2) ──
          // Page 2: Extended quiz (internal step management)
          ExtendedQuizPage(
            onComplete: _nextPage,
            onBack: _previousPage,
          ),

          // ── Phase C (3-5) ──
          // Page 3: Calculating animation
          CalculatingPage(onComplete: _nextPage),
          // Page 4: Analysis complete
          AnalysisCompletePage(onNext: _nextPage),
          // Page 5: Symptoms selection
          SymptomsSelectionPage(
            onComplete: _nextPage,
            onSymptomsChanged: (s) => _selectedSymptoms = s,
          ),

          // ── Phase D (6) ──
          // Page 6: Education carousel
          EducationCarouselPage(onComplete: _nextPage),

          // ── Phase E (7) ──
          // Page 7: Feature showcase
          FeatureShowcasePage(onComplete: _nextPage),

          // ── Phase F (8-11) ──
          // Page 8: Expert quotes
          ExpertQuotesPage(onNext: _nextPage),
          // Page 9: Recovery graph
          RecoveryGraphPage(onNext: _nextPage),
          // Page 10: Goals selection
          GoalsSelectionPage(
            onComplete: _nextPage,
            onGoalsChanged: (g) =>
                ref.read(selectedGoalsProvider.notifier).state = g,
          ),
          // Page 11: Testimonials
          TestimonialsPage(onNext: _nextPage),

          // ── Phase G (12) ──
          // Page 12: Notifications
          NotificationPermissionPage(onComplete: _nextPage),

          // ── Phase H (13-18) ──
          // Page 13: Welcome video
          WelcomeVideoPage(onNext: _nextPage),
          // Page 14: Invest in yourself
          InvestInYourselfPage(onNext: _nextPage, userName: userName),
          // Page 15: Custom plan
          CustomPlanPage(onNext: _nextPage),
          // Page 16: Build relationships
          BuildRelationshipsPage(onNext: _nextPage),
          // Page 17: Recovery plan
          RecoveryPlanPage(onNext: _nextPage),
          // Page 18: Choose plan (final)
          ChoosePlanPage(onComplete: _completeOnboarding),
        ],
      ),
      ),
    );
  }
}
