import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'composition_root.dart';
import 'presentation/helpers/helpers.dart';
import 'presentation/states_management/current_user_cubit/current_user_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await CompositionRoot.configure();

  runApp(
    BlocProvider(
      create: (context) => CurrentUserCubit(),
      child: MyApp(
        startPage: CompositionRoot.composeAuthPage(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  final Widget startPage;

  const MyApp({Key? key, required this.startPage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: kAppTitle,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''),
        Locale('pl', ''),
      ],
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        primaryColor: kNavyBlue,
        appBarTheme: AppBarTheme(
          toolbarHeight: 50.0,
          titleTextStyle: Theme.of(context).textTheme.subtitle1!.copyWith(
                color: kNavyBlue,
                fontWeight: FontWeight.bold,
              ),
          backgroundColor: kOrange,
          foregroundColor: kNavyBlue,
        ),
        scaffoldBackgroundColor: kNavyBlue,
        dialogTheme: DialogTheme(
          backgroundColor: kNavyBlueLight,
          titleTextStyle: Theme.of(context).textTheme.headline6!.copyWith(
                color: Colors.white,
              ),
          contentTextStyle: Theme.of(context).textTheme.subtitle1!.copyWith(
                color: Colors.white,
              ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(16.0),
            primary: kNavyBlueLight,
          ),
        ),
        popupMenuTheme: PopupMenuThemeData(
          color: kOrange,
          textStyle: Theme.of(context).textTheme.subtitle2!.copyWith(color: Colors.white),
          elevation: 0.0,
          shape: const RoundedRectangleBorder(),
        ),
      ),
      home: startPage,
    );
  }
}
