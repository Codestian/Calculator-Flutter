import 'package:calculator/providers/settings_provider.dart';
import 'package:calculator/screens/CalculatorScreen.dart';
import 'package:calculator/screens/FunctionScreen.dart';
import 'package:calculator/screens/SettingsScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(
    const ProviderScope(
      child: SwiftCalc(),
    ),
  );
}

class SwiftCalc extends ConsumerStatefulWidget {
  const SwiftCalc({super.key});

  @override
  ConsumerState<SwiftCalc> createState() => _SwiftCalcState();
}

class _SwiftCalcState extends ConsumerState<SwiftCalc> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          colorScheme: const ColorScheme.light().copyWith(
            primary: ref.watch(settingsThemePrimaryProvider),
            surfaceTint: Colors.transparent,
            surface: ref.watch(settingsThemeModeProvider)
                ? Color.alphaBlend(
                    ref.watch(settingsEnableMaterialYouProvider)
                        ? Colors.black.withOpacity(0.85)
                        : Colors.black.withOpacity(1.0),
                    ref.watch(settingsThemePrimaryProvider))
                : Color.alphaBlend(
                    ref.watch(settingsEnableMaterialYouProvider)
                        ? Colors.white.withOpacity(0.9)
                        : Colors.white.withOpacity(1.0),
                    ref.watch(settingsThemePrimaryProvider)),
            secondary: ref.watch(settingsThemeModeProvider)
                ? Colors.white
                : Colors.black,
          ),
        ),
        home: MainScaffold());
  }
}

class MainScaffold extends StatefulWidget {
  MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int currentPageIndex = 1;

  final List<Widget> _screens = <Widget>[
    FunctionScreen(),
    CalculatorScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      resizeToAvoidBottomInset: false,
      // bottomNavigationBar: Container(
      //   decoration: BoxDecoration(
      //     color: Theme.of(context).colorScheme.surface,
      //     border: Border(
      //       top: BorderSide(
      //         color: Colors.grey.withOpacity(0.2),
      //         width: 2.0,
      //       ),
      //     ),
      //   ),
      //   child: NavigationBarTheme(
      //     data: NavigationBarThemeData(
      //       indicatorColor: Theme.of(context).colorScheme.primary,
      //       backgroundColor: Colors.transparent,
      //       labelTextStyle: WidgetStateProperty.resolveWith((state) {
      //         return Theme.of(context)
      //             .textTheme
      //             .labelMedium!
      //             .copyWith(color: Theme.of(context).colorScheme.secondary);
      //       }),
      //       height: 72,
      //     ),
      //     child: NavigationBar(
      //       surfaceTintColor: Colors.transparent,
      //       indicatorColor: Theme.of(context).colorScheme.primary,
      //       onDestinationSelected: (int index) {
      //         setState(() {
      //           currentPageIndex = index;
      //         });
      //       },
      //       selectedIndex: currentPageIndex,
      //       destinations: <Widget>[
      //         NavigationDestination(
      //           icon: Icon(
      //             Icons.functions,
      //             color: Theme.of(context).colorScheme.secondary,
      //           ),
      //           label: 'Functions',
      //         ),
      //         NavigationDestination(
      //           icon: Icon(
      //             Icons.calculate,
      //             color: Theme.of(context).colorScheme.secondary,
      //           ),
      //           label: 'Calculator',
      //         ),
      //         NavigationDestination(
      //           icon: Icon(
      //             Icons.settings,
      //             color: Theme.of(context).colorScheme.secondary,
      //           ),
      //           label: 'Settings',
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
      body: IndexedStack(
        index: currentPageIndex,
        children: _screens,
      ),
    );
  }
}
