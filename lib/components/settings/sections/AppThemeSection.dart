import 'package:calculator/components/settings/ToggleSwitch.dart';
import 'package:calculator/providers/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppThemeSection extends ConsumerStatefulWidget {
  const AppThemeSection({super.key});

  @override
  ConsumerState<AppThemeSection> createState() => _AppThemeSectionState();
}

class _AppThemeSectionState extends ConsumerState<AppThemeSection> {
  Color primaryColor = Colors.black;

  double primaryColorSliderValue = 0;
  double primaryColorForBrightnessValue = 0.5;

  List<Color> colorList = <Color>[
    const HSVColor.fromAHSV(1.0, 0.0, 1.0, 1.0).toColor(),
    const HSVColor.fromAHSV(1.0, 60.0, 1.0, 1.0).toColor(),
    const HSVColor.fromAHSV(1.0, 120.0, 1.0, 1.0).toColor(),
    const HSVColor.fromAHSV(1.0, 180.0, 1.0, 1.0).toColor(),
    const HSVColor.fromAHSV(1.0, 240.0, 1.0, 1.0).toColor(),
    const HSVColor.fromAHSV(1.0, 300.0, 1.0, 1.0).toColor(),
    const HSVColor.fromAHSV(1.0, 330.0, 1.0, 1.0).toColor(),
        const HSVColor.fromAHSV(1.0, 360.0, 1.0, 1.0).toColor(),
  ];

  bool checkLuminance() {
    if (primaryColor.computeLuminance() >= 0.35) {
      return false;
    } else {
      return true;
    }
  }

  Color getColorfromHueAndBrightness(double hue, double brightness) {
    final double shiftedHue = hue % 360;
    final Color shiftedColor =
        HSVColor.fromAHSV(1.0, shiftedHue, 1.0, 1.0).toColor();
    Color changeColorLightness =
        HSLColor.fromColor(shiftedColor).withLightness(brightness).toColor();

    return changeColorLightness;
  }

  double getHue(Color color) {
    final hsvColor = HSVColor.fromColor(color);
    return hsvColor.hue;
  }

  double getBrightness(Color color) {
    return HSLColor.fromColor(color).lightness;
  }

  @override
  void initState() {
    super.initState();
    primaryColor = ref.read(settingsThemePrimaryProvider);

    primaryColorSliderValue = getHue(primaryColor);
    primaryColorForBrightnessValue = getBrightness(primaryColor);
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(settingsThemePrimaryProvider, (Color? previous, Color next) {
      setState(() {
        primaryColor = next;

        primaryColorSliderValue = getHue(primaryColor);
        primaryColorForBrightnessValue = getBrightness(primaryColor);
      });
    });

    return IgnorePointer(
      ignoring: ref.watch(settingsIsProVersionProvider) ? false : true,
      child: Opacity(
        opacity: ref.watch(settingsIsProVersionProvider) ? 1.0 : 0.25,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _ColorSlider((value) async {
              setState(() {
                primaryColor = getColorfromHueAndBrightness(
                    value, primaryColorForBrightnessValue);
                primaryColorSliderValue = value;
              });

              bool luminance = checkLuminance();


              ref
                  .read(settingsThemePrimaryProvider.notifier)
                  .setCusomTheme(primaryColor);
              ref.read(settingsThemeModeProvider.notifier).set(luminance);

              // GeneralUtility().saveThemeColor(primaryColor);
              // GeneralUtility().saveThemeMode(luminance);
            }, primaryColor, primaryColorSliderValue, colorList, 0.0, 360.0),
            _ColorSlider((double value) async {
              setState(() {
                primaryColor = getColorfromHueAndBrightness(
                    primaryColorSliderValue, value);
                primaryColorForBrightnessValue = value;
              });

              bool luminance = checkLuminance();

              ref
                  .read(settingsThemePrimaryProvider.notifier)
                  .setCusomTheme(primaryColor);
              ref.read(settingsThemeModeProvider.notifier).set(luminance);

              // GeneralUtility().saveThemeColor(primaryColor);
              // GeneralUtility().saveThemeMode(luminance);
            },
                primaryColor,
                primaryColorForBrightnessValue,
                <Color>[
                  HSLColor.fromColor(primaryColor)
                      .withLightness(0.25)
                      .toColor(),
                  HSLColor.fromColor(primaryColor).withLightness(0.5).toColor(),
                  HSLColor.fromColor(primaryColor)
                      .withLightness(0.85)
                      .toColor(),
                ],
                0.2,
                0.9),
            const SizedBox(height: 4),
            ToggleSwitch(
              title: 'Toggle Material You',
              value: ref.watch(settingsEnableMaterialYouProvider),
              onChanged: (value) async {
                // final prefs = await SharedPreferences.getInstance();
                // prefs.setBool('settings_enable_material_you', value);

                ref.read(settingsEnableMaterialYouProvider.notifier).set(value);
              },
            ),
          ],
        ),
      ),
    );
  }
}

Widget _ColorSlider(void Function(double value) onChanged, Color selectedColor,
        double currentValue, List<Color> gradient, double min, double max) =>
    Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Container(
          height: 32,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            border: Border.all(width: 2, color: Colors.black.withOpacity(0.1)),
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: gradient,
            ),
          ),
        ),
        SliderTheme(
          data: SliderThemeData(
              trackShape: const RoundedRectSliderTrackShape(),
              trackHeight: 32,
              thumbShape: const CustomSliderThumbShape(
                enabledThumbRadius: 16,
              ),
              thumbColor: selectedColor.withAlpha(220),
              overlayColor: Colors.transparent,
              activeTrackColor: Colors.transparent,
              inactiveTrackColor: Colors.transparent),
          child: Slider(
            value: currentValue,
            min: min,
            max: max,
            onChanged: onChanged,
            onChangeEnd: (double value) {},
          ),
        ),
      ],
    );

class CustomSliderThumbShape extends RoundSliderThumbShape {
  final Color borderColor;
  final double borderWidth;

  const CustomSliderThumbShape({
    this.borderColor = Colors.white,
    this.borderWidth = 3.0,
    double enabledThumbRadius = 16,
  }) : super(enabledThumbRadius: enabledThumbRadius);

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    bool isDiscrete = false,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    TextDirection? textDirection,
    double value = 0.0,
    double? textScaleFactor,
    Size? sizeWithOverflow,
  }) {
    // Paint the original thumb
    super.paint(
      context,
      center,
      activationAnimation: activationAnimation,
      enableAnimation: enableAnimation,
      isDiscrete: isDiscrete,
      labelPainter: labelPainter,
      parentBox: parentBox,
      sliderTheme: sliderTheme,
      textDirection: TextDirection.ltr,
      value: value,
      textScaleFactor: 1.0,
      sizeWithOverflow: Size.zero,
    );

    // Paint the border
    final Paint paint = Paint()
      ..color = borderColor
      ..strokeWidth = borderWidth
      ..style = PaintingStyle.stroke;

    context.canvas.drawCircle(center, enabledThumbRadius, paint);
  }
}
