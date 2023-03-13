import 'package:flutter/material.dart';

class CustomThemes extends StatefulWidget {
  static ThemesEnum themeValue = ThemesEnum.purpledefault;

  const CustomThemes({super.key});

  @override
  State<CustomThemes> createState() => _CustomThemesState();
}

enum ThemesEnum { orange, brown, grey, green, blue, pink, purpledefault, red }

class _CustomThemesState extends State<CustomThemes> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Radio(
          value: ThemesEnum.orange,
          groupValue: CustomThemes.themeValue,
          activeColor: Colors.orange,
          fillColor: MaterialStateColor.resolveWith((states) => Colors.orange),
          onChanged: (value) {
            setState(() {
              CustomThemes.themeValue = ThemesEnum.orange;
            });
          },
        ),
        Radio(
          value: ThemesEnum.brown,
          groupValue: CustomThemes.themeValue,
          activeColor: Colors.brown,
          fillColor: MaterialStateColor.resolveWith((states) => Colors.brown),
          onChanged: (value) {
            setState(() {
              CustomThemes.themeValue = ThemesEnum.brown;
            });
          },
        ),
        Radio(
          value: ThemesEnum.grey,
          groupValue: CustomThemes.themeValue,
          activeColor: Colors.grey,
          fillColor: MaterialStateColor.resolveWith((states) => Colors.grey),
          onChanged: (value) {
            setState(() {
              CustomThemes.themeValue = ThemesEnum.grey;
            });
          },
        ),
        Radio(
          value: ThemesEnum.green,
          groupValue: CustomThemes.themeValue,
          activeColor: Colors.green,
          fillColor: MaterialStateColor.resolveWith((states) => Colors.green),
          onChanged: (value) {
            setState(() {
              CustomThemes.themeValue = ThemesEnum.green;
            });
          },
        ),
        Radio(
          value: ThemesEnum.blue,
          groupValue: CustomThemes.themeValue,
          fillColor: MaterialStateColor.resolveWith((states) => Colors.blue),
          activeColor: Colors.blue,
          onChanged: (value) {
            setState(() {
              CustomThemes.themeValue = ThemesEnum.blue;
            });
          },
        ),
        Radio(
          value: ThemesEnum.purpledefault,
          groupValue: CustomThemes.themeValue,
          fillColor: MaterialStateColor.resolveWith((states) => Colors.purple),
          activeColor: Colors.purple,
          onChanged: (value) {
            setState(() {
              CustomThemes.themeValue = ThemesEnum.purpledefault;
            });
          },
        ),
        Radio(
          value: ThemesEnum.red,
          groupValue: CustomThemes.themeValue,
          fillColor: MaterialStateColor.resolveWith((states) => Colors.red),
          activeColor: Colors.red,
          onChanged: (value) {
            setState(() {
              CustomThemes.themeValue = ThemesEnum.red;
            });
          },
        ),
      ],
    );
  }
}
