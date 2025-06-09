import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'screens/splash_screen.dart';
import 'screens/onboarding_screen.dart';
import 'providers/habit_provider.dart';
import 'providers/theme_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'theme/app_theme.dart';
import 'theme/font_constants.dart';

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: AppTheme.backgroundColor,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );
    

    
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    
    final themeProvider = await ThemeProvider.init();
    

    final prefs = await SharedPreferences.getInstance();
    final onboardingComplete = prefs.getBool('onboardingComplete') ?? false;
    
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => HabitProvider()),
          ChangeNotifierProvider.value(value: themeProvider),
        ],
        child: MyApp(onboardingComplete: onboardingComplete),
      ),
    );
  } catch (e, stackTrace) {
    print('Erro ao inicializar o aplicativo:');
    print('Erro: $e');
    print('Stack trace: $stackTrace');
    rethrow;
  }
}

class MyApp extends StatelessWidget {
  final bool onboardingComplete;
  
  const MyApp({super.key, required this.onboardingComplete});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Rastreador de Hábitos',
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('pt', 'BR'),
      ],
      locale: const Locale('pt', 'BR'),
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: themeProvider.currentTheme.primary,
        scaffoldBackgroundColor: themeProvider.currentTheme.background,
        colorScheme: themeProvider.currentTheme,
        cardColor: AppTheme.cardColor,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent,
          foregroundColor: AppTheme.textPrimaryColor,
          elevation: 0,
          centerTitle: false,
          titleTextStyle: AppFonts.headingSmall(color: AppTheme.textPrimaryColor),
          iconTheme: const IconThemeData(color: AppTheme.textPrimaryColor),
        ),
        textTheme: TextTheme(
          displayLarge: AppFonts.headingLarge(color: AppTheme.textPrimaryColor),
          displayMedium: AppFonts.headingMedium(color: AppTheme.textPrimaryColor),
          displaySmall: AppFonts.headingSmall(color: AppTheme.textPrimaryColor),
          headlineMedium: AppFonts.headingSmall(color: AppTheme.textPrimaryColor),
          headlineSmall: AppFonts.headingSmall(color: AppTheme.textPrimaryColor),
          titleLarge: AppFonts.headingSmall(color: AppTheme.textPrimaryColor),
          bodyLarge: AppFonts.bodyLarge(color: AppTheme.textPrimaryColor),
          bodyMedium: AppFonts.bodyMedium(color: AppTheme.textPrimaryColor),
          bodySmall: AppFonts.bodySmall(color: AppTheme.textSecondaryColor),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppTheme.cardColor.withOpacity(0.7),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppTheme.textSecondaryColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppTheme.textSecondaryColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppTheme.primaryColor, width: 2),
          ),
          labelStyle: const TextStyle(color: AppTheme.textSecondaryColor),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primaryColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: AppTheme.primaryColor,
          foregroundColor: Colors.white,
          elevation: 8,
        ),
        dialogTheme: DialogThemeData(
          backgroundColor: AppTheme.backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          titleTextStyle: const TextStyle(
            fontSize: 20, 
            fontWeight: FontWeight.bold, 
            color: AppTheme.textPrimaryColor,
          ),
        ),
        snackBarTheme: SnackBarThemeData(
          backgroundColor: AppTheme.cardColor,
          contentTextStyle: const TextStyle(color: AppTheme.textPrimaryColor),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      home: onboardingComplete ? const SplashScreen() : const OnboardingScreen(),
    );
  }
}
