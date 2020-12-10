library constants;

import 'package:flutter/material.dart';
import 'package:theme_provider/theme_provider.dart';

const String appTitle = 'Nonogram Solver';
const bool debugMode = false;

const String lightThemeId = 'light';
const String darkThemeId = 'dark';

final List<AppTheme> appThemeList = <AppTheme>[
  AppTheme(
      id: lightThemeId,
      data: ThemeData.light().copyWith(
        primaryColor: Colors.indigo[600],
      ),
      description: ''),
  AppTheme(
      id: darkThemeId,
      data: ThemeData.dark().copyWith(
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          foregroundColor: Colors.black,
        ),
      ),
      description: ''),
];
