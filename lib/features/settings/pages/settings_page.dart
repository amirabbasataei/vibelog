import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vibelog/l10n/app_localizations.dart';
import '../../../core/di/injection.dart';
import '../../../features/notes/repository/notes_repository.dart';
import '../cubit/settings_cubit.dart';
import '../cubit/settings_state.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, settings) {
        final cubit = context.read<SettingsCubit>();
        return Scaffold(
          body: SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsetsDirectional.only(
                      start: 20,
                      end: 20,
                      top: 24,
                      bottom: 8,
                    ),
                    child: Text(
                      l10n.tabSettings,
                      style: Theme.of(context)
                          .textTheme
                          .headlineLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      _SectionLabel(l10n.settingsAppearanceSection),
                      _SettingsCard(
                        children: [
                          _SettingsTile(
                            iconData: Icons.brightness_6_rounded,
                            iconColor: Colors.purple,
                            title: l10n.settingsThemeTitle,
                            subtitle: l10n.settingsThemeSubtitle,
                            trailing: _ThemeSegmentedButton(
                              current: settings.themeMode,
                              onChanged: cubit.setThemeMode,
                              l10n: l10n,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      _SectionLabel(l10n.settingsLanguageSection),
                      _SettingsCard(
                        children: [
                          _LanguageTile(
                            current: settings.locale,
                            onChanged: cubit.setLocale,
                            l10n: l10n,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      _SectionLabel(l10n.settingsDataSection),
                      _SettingsCard(
                        children: [
                          _DeleteAllTile(l10n: l10n),
                        ],
                      ),
                      const SizedBox(height: 20),
                      _SectionLabel(l10n.settingsAboutSection),
                      _SettingsCard(
                        children: [
                          _GitHubTile(l10n: l10n),
                        ],
                      ),
                      const SizedBox(height: 32),
                      Center(
                        child: Text(
                          l10n.appVersion,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurface
                                    .withValues(alpha: 0.4),
                                fontStyle: FontStyle.italic,
                              ),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ]),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 4, bottom: 8),
      child: Text(
        text.toUpperCase(),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
              letterSpacing: 1.2,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  const _SettingsCard({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          for (int i = 0; i < children.length; i++) ...[
            children[i],
            if (i < children.length - 1)
              Divider(
                height: 1,
                indent: 60,
                endIndent: 0,
                color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.4),
              ),
          ],
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.iconData,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.trailing,
  });

  final IconData iconData;
  final Color iconColor;
  final String title;
  final String subtitle;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          _IconBox(iconData: iconData, color: iconColor),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.bodyLarge),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.55),
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          trailing,
        ],
      ),
    );
  }
}

class _IconBox extends StatelessWidget {
  const _IconBox({required this.iconData, required this.color});
  final IconData iconData;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(iconData, color: color, size: 20),
    );
  }
}

class _ThemeSegmentedButton extends StatelessWidget {
  const _ThemeSegmentedButton({
    required this.current,
    required this.onChanged,
    required this.l10n,
  });
  final ThemeMode current;
  final ValueChanged<ThemeMode> onChanged;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<ThemeMode>(
      style: SegmentedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
        visualDensity: VisualDensity.compact,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      segments: [
        ButtonSegment(
          value: ThemeMode.light,
          label: Text(l10n.settingsThemeLight, style: const TextStyle(fontSize: 12)),
        ),
        ButtonSegment(
          value: ThemeMode.dark,
          label: Text(l10n.settingsThemeDark, style: const TextStyle(fontSize: 12)),
        ),
      ],
      selected: {current},
      onSelectionChanged: (v) => onChanged(v.first),
    );
  }
}

class _ScaleSegmentedButton extends StatelessWidget {
  const _ScaleSegmentedButton({
    required this.current,
    required this.onChanged,
    required this.l10n,
  });
  final int current;
  final ValueChanged<int> onChanged;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<int>(
      style: SegmentedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
        visualDensity: VisualDensity.compact,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      segments: [
        ButtonSegment(
          value: 5,
          label: Text(l10n.settingsScaleOption5, style: const TextStyle(fontSize: 12)),
        ),
        ButtonSegment(
          value: 10,
          label: Text(l10n.settingsScaleOption10, style: const TextStyle(fontSize: 12)),
        ),
      ],
      selected: {current},
      onSelectionChanged: (v) => onChanged(v.first),
    );
  }
}

class _LanguageTile extends StatelessWidget {
  const _LanguageTile({
    required this.current,
    required this.onChanged,
    required this.l10n,
  });
  final String current;
  final ValueChanged<String> onChanged;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          const _IconBox(iconData: Icons.language_rounded, color: Colors.indigo),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.settingsLanguageTitle,
                    style: Theme.of(context).textTheme.bodyLarge),
                Text(
                  l10n.settingsLanguageSubtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.55),
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          DropdownButton<String>(
            value: current,
            underline: const SizedBox.shrink(),
            borderRadius: BorderRadius.circular(12),
            items: [
              DropdownMenuItem(
                value: 'en',
                child: Text(l10n.settingsLanguageEn,
                    style: const TextStyle(fontSize: 14)),
              ),
              DropdownMenuItem(
                value: 'fa',
                child: Text(l10n.settingsLanguageFa,
                    style: const TextStyle(fontSize: 14)),
              ),
            ],
            onChanged: (v) {
              if (v != null) onChanged(v);
            },
          ),
        ],
      ),
    );
  }
}

class _GitHubTile extends StatelessWidget {
  const _GitHubTile({required this.l10n});
  final AppLocalizations l10n;

  static const _repoUrl = 'https://github.com/amirabbasataei/vibelog';

  Future<void> _openGitHub() async {
    final uri = Uri.parse(_repoUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _openGitHub,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            const _IconBox(iconData: Icons.star_rounded, color: Colors.orange),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.settingsGitHubTitle,
                      style: Theme.of(context).textTheme.bodyLarge),
                  Text(
                    l10n.settingsGitHubSubtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withValues(alpha: 0.55),
                        ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.open_in_new_rounded,
              size: 18,
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4),
            ),
          ],
        ),
      ),
    );
  }
}

class _DeleteAllTile extends StatelessWidget {
  const _DeleteAllTile({required this.l10n});
  final AppLocalizations l10n;

  Future<void> _confirm(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.deleteAllConfirmTitle),
        content: Text(l10n.deleteAllConfirmBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(ctx).colorScheme.error,
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(l10n.deleteAllConfirm),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      await getIt<NotesRepository>().deleteAll();
    }
  }

  @override
  Widget build(BuildContext context) {
    final errorColor = Theme.of(context).colorScheme.error;
    return InkWell(
      onTap: () => _confirm(context),
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            _IconBox(iconData: Icons.delete_outline_rounded, color: errorColor),
            const SizedBox(width: 14),
            Text(
              l10n.deleteAllData,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(color: errorColor, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
