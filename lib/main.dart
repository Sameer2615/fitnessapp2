import 'package:firebase_core/firebase_core.dart';
import 'package:fitnessapp/core/presentation/main_screen.dart';
import 'package:fitnessapp/login_signup/login_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:logging/logging.dart';
import 'package:fitnessapp/core/data/data_source/user_data_source.dart';
import 'package:fitnessapp/core/data/repository/config_repository.dart';
import 'package:fitnessapp/core/domain/entity/app_theme_entity.dart';
import 'package:fitnessapp/core/presentation/widgets/image_full_screen.dart';
import 'package:fitnessapp/core/styles/color_schemes.dart';
import 'package:fitnessapp/core/styles/fonts.dart';
import 'package:fitnessapp/core/utils/env.dart';
import 'package:fitnessapp/core/utils/locator.dart';
import 'package:fitnessapp/core/utils/logger_config.dart';
import 'package:fitnessapp/core/utils/navigation_options.dart';
import 'package:fitnessapp/core/utils/theme_mode_provider.dart';
import 'package:fitnessapp/features/activity_detail/activity_detail_screen.dart';
import 'package:fitnessapp/features/add_meal/presentation/add_meal_screen.dart';
import 'package:fitnessapp/features/add_activity/presentation/add_activity_screen.dart';
import 'package:fitnessapp/features/edit_meal/presentation/edit_meal_screen.dart';
import 'package:fitnessapp/features/onboarding/onboarding_screen.dart';
import 'package:fitnessapp/features/scanner/scanner_screen.dart';
import 'package:fitnessapp/features/meal_detail/meal_detail_screen.dart';
import 'package:fitnessapp/features/settings/settings_screen.dart';
import 'package:fitnessapp/generated/l10n.dart';
import 'package:provider/provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<ScaffoldMessengerState> scaffoldKey =
    GlobalKey<ScaffoldMessengerState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await LocalNotification.init();
  // Get.lazyPut(() => FavoritesController());
  await Firebase.initializeApp();
  WidgetsFlutterBinding.ensureInitialized();
  LoggerConfig.intiLogger();
  await initLocator();
  final isUserInitialized = await locator<UserDataSource>().hasUserData();
  final configRepo = locator<ConfigRepository>();
  final hasAcceptedAnonymousData =
      await configRepo.getConfigHasAcceptedAnonymousData();
  final savedAppTheme = await configRepo.getConfigAppTheme();
  final log = Logger('main');

  // If the user has accepted anonymous data collection, run the app with
  // sentry enabled, else run without it
  if (kReleaseMode && hasAcceptedAnonymousData) {
    log.info('Starting App with Sentry enabled ...');
    _runAppWithSentryReporting(isUserInitialized, savedAppTheme);
  } else {
    log.info('Starting App ...');
    runAppWithChangeNotifiers(isUserInitialized, savedAppTheme);
  }
}

void _runAppWithSentryReporting(
    bool isUserInitialized, AppThemeEntity savedAppTheme) async {
  await SentryFlutter.init((options) {
    options.dsn = Env.sentryDns;
    options.tracesSampleRate = 1.0;
  },
      appRunner: () =>
          runAppWithChangeNotifiers(isUserInitialized, savedAppTheme));
}

void runAppWithChangeNotifiers(
        bool userInitialized, AppThemeEntity savedAppTheme) =>
    runApp(ChangeNotifierProvider(
        create: (_) => ThemeModeProvider(appTheme: savedAppTheme),
        child: FitTrack(userInitialized: userInitialized)));

class FitTrack extends StatelessWidget {
  final bool userInitialized;

  const FitTrack({super.key, required this.userInitialized});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      scaffoldMessengerKey: scaffoldKey,
      onGenerateTitle: (context) => S.of(context).appTitle,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          useMaterial3: true,
          colorScheme: lightColorScheme,
          textTheme: appTextTheme),
      // darkTheme: ThemeData(
      //     useMaterial3: true,
      //     colorScheme: darkColorScheme,
      //     textTheme: appTextTheme),
      themeMode: Provider.of<ThemeModeProvider>(context).themeMode,
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      initialRoute: userInitialized
          ? NavigationOptions.mainRoute
          : NavigationOptions.onboardingRoute,
      routes: {
        NavigationOptions.mainRoute: (context) => const MainScreen(),
        NavigationOptions.onboardingRoute: (context) =>
            const OnboardingScreen(),
        NavigationOptions.settingsRoute: (context) => const SettingsScreen(),
        NavigationOptions.addMealRoute: (context) => const AddMealScreen(),
        NavigationOptions.scannerRoute: (context) => const ScannerScreen(),
        NavigationOptions.mealDetailRoute: (context) =>
            const MealDetailScreen(),
        NavigationOptions.editMealRoute: (context) => const EditMealScreen(),
        NavigationOptions.addActivityRoute: (context) =>
            const AddActivityScreen(),
        NavigationOptions.activityDetailRoute: (context) =>
            const ActivityDetailScreen(),
        NavigationOptions.imageFullScreenRoute: (context) =>
            const ImageFullScreen(),
      },
    );
  }
}
