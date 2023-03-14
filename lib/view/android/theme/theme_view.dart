import 'package:flutter/material.dart';
import 'package:flutter_lucid_bell/view/android/theme/theme_setting.dart';
import 'package:flutter_lucid_bell/view/view.dart';

// ignore: must_be_immutable
class CustomThemes extends StatefulWidget {
  Function updateCallback;
  static ThemesEnum _themeValue = View.currentTheme.themeEnum;

  CustomThemes(this.updateCallback, {super.key});

  void setTheme(ThemesEnum newTheme) {
    _themeValue = newTheme;
    View.currentTheme = CustomTheme.selectTheme(theme: newTheme);
    View.currentTheme.saveToStorageAsync(View.currentTheme.themeEnum);
    updateCallback();
  }

  @override
  State<CustomThemes> createState() => _CustomThemesState();
}

class _CustomThemesState extends State<CustomThemes> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Radio(
              value: ThemesEnum.orange,
              groupValue: CustomThemes._themeValue,
              activeColor: Colors.orange,
              fillColor:
                  MaterialStateColor.resolveWith((states) => Colors.orange),
              onChanged: (value) {
                setState(() {
                  widget.setTheme(ThemesEnum.orange);
                });
              },
            ),
            Radio(
              value: ThemesEnum.brown,
              groupValue: CustomThemes._themeValue,
              activeColor: Colors.brown,
              fillColor:
                  MaterialStateColor.resolveWith((states) => Colors.brown),
              onChanged: (value) {
                setState(() {
                  widget.setTheme(ThemesEnum.brown);
                });
              },
            ),
            Radio(
              value: ThemesEnum.grey,
              groupValue: CustomThemes._themeValue,
              activeColor: Colors.grey,
              fillColor:
                  MaterialStateColor.resolveWith((states) => Colors.grey),
              onChanged: (value) {
                setState(() {
                  widget.setTheme(ThemesEnum.grey);
                });
              },
            ),
            Radio(
              value: ThemesEnum.green,
              groupValue: CustomThemes._themeValue,
              activeColor: Colors.teal.shade400,
              fillColor: MaterialStateColor.resolveWith(
                  (states) => Colors.teal.shade400),
              onChanged: (value) {
                setState(() {
                  widget.setTheme(ThemesEnum.green);
                });
              },
            ),
            Radio(
              value: ThemesEnum.blueDefault,
              groupValue: CustomThemes._themeValue,
              fillColor:
                  MaterialStateColor.resolveWith((states) => Colors.blue),
              activeColor: Colors.blue,
              onChanged: (value) {
                setState(() {
                  widget.setTheme(ThemesEnum.blueDefault);
                });
              },
            ),
            Radio(
              value: ThemesEnum.purple,
              groupValue: CustomThemes._themeValue,
              fillColor:
                  MaterialStateColor.resolveWith((states) => Colors.deepPurple),
              activeColor: Colors.deepPurple,
              onChanged: (value) {
                setState(() {
                  widget.setTheme(ThemesEnum.orange);
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
