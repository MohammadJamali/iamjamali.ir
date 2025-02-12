import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// import 'package:just_audio_media_kit/just_audio_media_kit.dart';
import 'package:media_kit/media_kit.dart';
import 'package:portfolio/pages/app/page.dart';
import 'package:portfolio/pages/detail_page.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MediaKit.ensureInitialized();
  // JustAudioMediaKit.ensureInitialized(
  //   android: Platform.isAndroid,
  //   windows: Platform.isWindows,
  //   linux: Platform.isLinux, // sudo apt install libmpv-dev mpv
  //   iOS: Platform.isIOS,
  //   macOS: Platform.isMacOS,
  // );
  
  usePathUrlStrategy();
  runApp(const MyApp());
}

final countryIcons = {
  'en': AssetImage(
    'icons/flags/png250px/us.png',
    package: 'country_icons',
  ),
  'fa': AssetImage(
    'icons/flags/png250px/ir.png',
    package: 'country_icons',
  ),
};

class AppSetting extends Equatable {
  final String? locale;
  final ThemeMode themeMode;

  const AppSetting({
    this.locale,
    required this.themeMode,
  });

  AppSetting copyWith({
    String? locale,
    ThemeMode? themeMode,
  }) {
    return AppSetting(
      locale: locale ?? this.locale,
      themeMode: themeMode ?? this.themeMode,
    );
  }

  @override
  List<Object?> get props => [locale, themeMode];
}

class AppSettingCubit extends Cubit<AppSetting> {
  AppSettingCubit({
    AppSetting? initialValue,
  }) : super(
          initialValue ??
              const AppSetting(
                themeMode: ThemeMode.light,
              ),
        );

  void setLocale(String lang) {
    if (countryIcons.keys.any((supportedLang) => supportedLang == lang)) {
      emit(state.copyWith(locale: lang));
      return;
    }
    emit(state.copyWith(locale: countryIcons.keys.first));
  }

  void setTheme(ThemeMode mode) {
    emit(state.copyWith(themeMode: mode));
  }

  void toggleTheme() {
    emit(
      state.copyWith(
        themeMode: state.themeMode == ThemeMode.dark
            ? ThemeMode.light
            : ThemeMode.dark,
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  ThemeMode getSystemThemeMode(BuildContext context) {
    var brightness = MediaQueryData.fromView(WidgetsBinding.instance.window)
        .platformBrightness;
    return brightness == Brightness.dark ? ThemeMode.dark : ThemeMode.light;
  }

  String getLocal() {
    var uriParams = Uri.base.queryParameters;
    if (uriParams.containsKey('lang') &&
        AppLocalizations.supportedLocales.any((supportedLocale) =>
            supportedLocale.languageCode == uriParams['lang'])) {
      return uriParams['lang']!;
    }
    return 'en';
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AppSettingCubit(
        initialValue: AppSetting(
          themeMode: getSystemThemeMode(context),
          locale: getLocal(),
        ),
      ),
      child: const MyAppPage(),
    );
  }
}

class MyAppPage extends StatefulWidget {
  const MyAppPage({super.key});

  @override
  State<MyAppPage> createState() => _MyAppPageState();
}

class _MyAppPageState extends State<MyAppPage> {
  Map<String, String>? initQueryParams;

  Locale getLocal(String? locale) {
    if (locale != null) return Locale(locale);

    var uriParams = Uri.base.queryParameters;
    if (uriParams.containsKey('lang') &&
        AppLocalizations.supportedLocales.any((supportedLocale) =>
            supportedLocale.languageCode == uriParams['lang'])) {
      return Locale(uriParams['lang']!);
    }

    return const Locale('en');
  }

  @override
  Widget build(BuildContext context) {
    final setting = context.select((AppSettingCubit cubit) => cubit.state);

    return MaterialApp(
      onGenerateTitle: (context) {
        return AppLocalizations.of(context)!.title;
      },
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: getLocal(setting.locale),
      onGenerateRoute: (RouteSettings route) {
        var uri = Uri.tryParse(route.name!);
        initQueryParams ??= uri?.queryParameters;

        try {
          if (initQueryParams != null) {
            final urlqp = Map.of(uri!.queryParameters);
            urlqp.addAll(initQueryParams!);

            route = RouteSettings(
              name: Uri(path: uri.path, queryParameters: urlqp).toString(),
              arguments: route.arguments,
            );
          }
        } catch (_) {}

        if (uri?.path == DetailPage.routeName) {
          return PageRouteBuilder(
            settings: route,
            pageBuilder: (_, __, ___) => const DetailPage(bodyWidth: 600),
            transitionsBuilder: (
              BuildContext transitionsBuildContext,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child,
            ) =>
                FadeTransition(
              opacity: animation,
              child: child,
            ),
            transitionDuration: const Duration(milliseconds: 500),
          );
        }

        // if (uri?.path == AppPage.routeName) {
        return MaterialPageRoute(
          settings: route,
          builder: (_) => const TabControllerAppPage(),
        );
      },
      builder: (BuildContext context, Widget? navigator) {
        final localeName = AppLocalizations.of(context)!.localeName;
        final fontFamily = localeName == 'fa' ? 'pnazanin' : 'times';

        ThemeData theme;
        if (setting.themeMode == ThemeMode.dark) {
          theme = ThemeData.dark(useMaterial3: false);
          theme = theme.copyWith(
            textTheme: theme.textTheme.apply(
              fontFamily: fontFamily,
              // fontSizeDelta: localeName == 'fa' ? -2.0 : 0.0,
            ),
          );
        } else {
          theme = ThemeData.light(useMaterial3: false);
          theme = theme.copyWith(
            tabBarTheme: const TabBarTheme(
              labelColor: Colors.blue,
              unselectedLabelColor: Colors.black,
              unselectedLabelStyle: TextStyle(color: Colors.black),
              labelStyle: TextStyle(color: Color(0xFFF6F6F8)),
            ),
            textTheme: theme.textTheme.apply(
              fontFamily: fontFamily,
              // fontSizeDelta: localeName == 'fa' ? -2.0 : 0.0,
            ),
          );
        }

        return Theme(
          data: theme,
          child: navigator!,
        );
      },
      home: const TabControllerAppPage(),
    );
  }
}
