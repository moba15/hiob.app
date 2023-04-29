import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:smart_home/manager/cubit/manager_cubit.dart';
import 'package:smart_home/manager/manager.dart';
import 'package:smart_home/manager/screen_manager.dart';
import 'package:smart_home/settings/view/main_screen.dart';
import 'package:smart_home/utils/theme.dart';
class App extends MaterialApp {
  App(
      {Key? key,
      required Manager manager,
      required ScreenManager screenManager})
      : super(
            key: key,
            localizationsDelegates: [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: [

              const Locale('en', ''),
              const Locale('de', ''),
            ],
            theme: ThemeData.light(useMaterial3: true),
            darkTheme: Material3Theme.darkMaterial3Theme,
            home: RepositoryProvider<Manager>.value(
                value: manager,
                child: BlocProvider(
                  child: const MainPage(),
                    create: (_) => ManagerCubit(manager: manager))));
}
