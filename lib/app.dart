import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:vibelog/l10n/app_localizations.dart';
import 'core/di/injection.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/settings/cubit/settings_cubit.dart';
import 'features/settings/cubit/settings_state.dart';

class VibelogApp extends StatelessWidget {
  const VibelogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<SettingsCubit>(),
      child: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, settings) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'vibelog',
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en'),
              Locale('fa'),
            ],
            locale: Locale(settings.locale),
            theme: settings.locale == 'fa'
                ? lightTheme.copyWith(
                    textTheme: lightTheme.textTheme.apply(fontFamily: 'IRANSansXFaNum'),
                  )
                : lightTheme,
            darkTheme: settings.locale == 'fa'
                ? darkTheme.copyWith(
                    textTheme: darkTheme.textTheme.apply(fontFamily: 'IRANSansXFaNum'),
                  )
                : darkTheme,
            themeMode: settings.themeMode,
            routerConfig: appRouter,
          );
        },
      ),
    );
  }
}
