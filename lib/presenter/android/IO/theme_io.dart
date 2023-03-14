import 'package:flutter_lucid_bell/presenter/android/IO/android_local_path_provider.dart';
import 'package:flutter_lucid_bell/view/android/theme/theme_setting.dart';

mixin ThemeIO{
  Future<bool> saveToStorageAsync(ThemesEnum themeName) async {
    await LocalManager.initAsync();

    bool result = await LocalManager.writeToFile(
        LocalManager.themeFilePath!, themeName.name);

    return result;
  }

  static Future<CustomTheme> loadFromStorageAsync() async {
    await LocalManager.initAsync();

    String? customTheme =
        await LocalManager.readFile(LocalManager.themeFilePath!);

    // load from file
    if (customTheme != null) {
      try {
        ThemesEnum convertedEnum = ThemesEnum.values.byName(customTheme);
        
        
        return CustomTheme.selectTheme(theme: convertedEnum);
      } catch (e) {
        await StorageLogger.logBackgroundAsync(
            'error in theme_io.dart.loadFromStorageAsync() ${e.toString()}');
      }
    }
    // create default
    return CustomTheme.blueDefault();
  }
}