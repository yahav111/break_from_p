import 'package:flutter_riverpod/flutter_riverpod.dart';

enum OnboardingPhase {
  phaseA, // Welcome & Auth (screens 2-3, after welcome route)
  phaseB, // Extended Quiz (screens 4-14)
  phaseC, // Analysis & Symptoms (screens 15-17)
  phaseD, // Education Carousel (screens 18-22)
  phaseE, // Feature Showcase (screens 23-27)
  phaseF, // Social Proof & Goals (screens 28-31)
  phaseG, // Notifications (screen 32)
  phaseH, // Paywall & Conversion (screens 33-38)
}

final onboardingFlowProvider =
    NotifierProvider<OnboardingFlowNotifier, OnboardingFlowState>(
  OnboardingFlowNotifier.new,
);

class OnboardingFlowState {
  const OnboardingFlowState({
    this.currentPhase = OnboardingPhase.phaseA,
    this.currentStepInPhase = 0,
  });

  final OnboardingPhase currentPhase;
  final int currentStepInPhase;

  /// Total number of top-level pages in the flow orchestrator.
  /// Phase A: 2 screens (auth + profile card)
  /// Phase B: 1 container (quiz manages its own steps internally)
  /// Phase C: 3 screens
  /// Phase D: 1 container (carousel)
  /// Phase E: 1 container (carousel)
  /// Phase F: 4 screens
  /// Phase G: 1 screen
  /// Phase H: 6 screens
  static const int totalPages = 19;

  /// Maps each orchestrator page index to its phase.
  static OnboardingPhase phaseForPage(int pageIndex) {
    if (pageIndex < 2) return OnboardingPhase.phaseA;
    if (pageIndex < 3) return OnboardingPhase.phaseB;
    if (pageIndex < 6) return OnboardingPhase.phaseC;
    if (pageIndex < 7) return OnboardingPhase.phaseD;
    if (pageIndex < 8) return OnboardingPhase.phaseE;
    if (pageIndex < 12) return OnboardingPhase.phaseF;
    if (pageIndex < 13) return OnboardingPhase.phaseG;
    return OnboardingPhase.phaseH;
  }

  /// The overall page index in the orchestrator PageView.
  int get pageIndex {
    switch (currentPhase) {
      case OnboardingPhase.phaseA:
        return currentStepInPhase; // 0-1
      case OnboardingPhase.phaseB:
        return 2; // single container
      case OnboardingPhase.phaseC:
        return 3 + currentStepInPhase; // 3-5
      case OnboardingPhase.phaseD:
        return 6; // single container
      case OnboardingPhase.phaseE:
        return 7; // single container
      case OnboardingPhase.phaseF:
        return 8 + currentStepInPhase; // 8-11
      case OnboardingPhase.phaseG:
        return 12; // single screen
      case OnboardingPhase.phaseH:
        return 13 + currentStepInPhase; // 13-18
    }
  }

  OnboardingFlowState copyWith({
    OnboardingPhase? currentPhase,
    int? currentStepInPhase,
  }) {
    return OnboardingFlowState(
      currentPhase: currentPhase ?? this.currentPhase,
      currentStepInPhase: currentStepInPhase ?? this.currentStepInPhase,
    );
  }
}

class OnboardingFlowNotifier extends Notifier<OnboardingFlowState> {
  @override
  OnboardingFlowState build() => const OnboardingFlowState();

  /// Advance to the next page in the overall flow.
  void nextPage() {
    final current = state.pageIndex;
    if (current >= OnboardingFlowState.totalPages - 1) return;

    final nextIndex = current + 1;
    final nextPhase = OnboardingFlowState.phaseForPage(nextIndex);

    if (nextPhase == state.currentPhase) {
      state = state.copyWith(
        currentStepInPhase: state.currentStepInPhase + 1,
      );
    } else {
      state = OnboardingFlowState(
        currentPhase: nextPhase,
        currentStepInPhase: 0,
      );
    }
  }

  /// Go back one page.
  void previousPage() {
    final current = state.pageIndex;
    if (current <= 0) return;

    final prevIndex = current - 1;
    final prevPhase = OnboardingFlowState.phaseForPage(prevIndex);

    if (prevPhase == state.currentPhase) {
      state = state.copyWith(
        currentStepInPhase: state.currentStepInPhase - 1,
      );
    } else {
      // Calculate step within previous phase.
      int step = 0;
      for (int i = 0; i <= prevIndex; i++) {
        if (OnboardingFlowState.phaseForPage(i) == prevPhase) {
          step = i - _firstPageOfPhase(prevPhase);
        }
      }
      state = OnboardingFlowState(
        currentPhase: prevPhase,
        currentStepInPhase: step,
      );
    }
  }

  /// Jump to a specific phase.
  void goToPhase(OnboardingPhase phase) {
    state = OnboardingFlowState(currentPhase: phase, currentStepInPhase: 0);
  }

  /// Reset to beginning.
  void reset() {
    state = const OnboardingFlowState();
  }

  int _firstPageOfPhase(OnboardingPhase phase) {
    switch (phase) {
      case OnboardingPhase.phaseA:
        return 0;
      case OnboardingPhase.phaseB:
        return 2;
      case OnboardingPhase.phaseC:
        return 3;
      case OnboardingPhase.phaseD:
        return 6;
      case OnboardingPhase.phaseE:
        return 7;
      case OnboardingPhase.phaseF:
        return 8;
      case OnboardingPhase.phaseG:
        return 12;
      case OnboardingPhase.phaseH:
        return 13;
    }
  }
}
