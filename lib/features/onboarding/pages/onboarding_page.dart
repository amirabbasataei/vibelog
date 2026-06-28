import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theme/app_theme.dart';
import '../../../l10n/app_localizations.dart';
import '../../settings/cubit/settings_cubit.dart';

class _OnboardingStep {
  const _OnboardingStep({
    required this.icon,
    required this.color,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String body;
}

/// Full-screen onboarding shown once on first launch, before the home page.
class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final _controller = PageController();
  int _page = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<_OnboardingStep> _steps(AppLocalizations l10n) => [
        _OnboardingStep(
          icon: Icons.auto_awesome,
          color: moodColor,
          title: l10n.tutorialWelcomeTitle,
          body: l10n.tutorialWelcomeBody,
        ),
        _OnboardingStep(
          icon: Icons.article,
          color: moodColor,
          title: l10n.tutorialNotesTitle,
          body: l10n.tutorialNotesBody,
        ),
        _OnboardingStep(
          icon: Icons.show_chart,
          color: moodColor,
          title: l10n.tutorialGraphTitle,
          body: l10n.tutorialGraphBody,
        ),
        _OnboardingStep(
          icon: Icons.bubble_chart,
          color: boredomColor,
          title: l10n.tutorialMindTitle,
          body: l10n.tutorialMindBody,
        ),
      ];

  void _finish() => context.read<SettingsCubit>().markTutorialSeen();

  void _next(int lastIndex) {
    if (_page >= lastIndex) {
      _finish();
    } else {
      _controller.nextPage(
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOutCubic,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;
    final steps = _steps(l10n);
    final lastIndex = steps.length - 1;
    final isLast = _page == lastIndex;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: AlignmentDirectional.topEnd,
              child: Padding(
                padding: const EdgeInsetsDirectional.only(top: 8, end: 8),
                child: TextButton(
                  onPressed: _finish,
                  child: Text(l10n.tutorialSkip),
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: steps.length,
                onPageChanged: (i) => setState(() => _page = i),
                itemBuilder: (context, i) => _StepView(step: steps[i]),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(steps.length, (i) {
                final active = i == _page;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 240),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: active ? 22 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: active
                        ? cs.primary
                        : cs.onSurfaceVariant.withAlpha(90),
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => _next(lastIndex),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(isLast ? l10n.tutorialDone : l10n.tutorialNext),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StepView extends StatelessWidget {
  const _StepView({required this.step});

  final _OnboardingStep step;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 104,
            height: 104,
            decoration: BoxDecoration(
              color: step.color.withAlpha(38),
              shape: BoxShape.circle,
            ),
            child: Icon(step.icon, size: 52, color: step.color),
          ),
          const SizedBox(height: 32),
          Text(
            step.title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: cs.onSurface,
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            step.body,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: cs.onSurfaceVariant,
              fontSize: 16,
              height: 1.55,
            ),
          ),
        ],
      ),
    );
  }
}
