import 'package:flutter_lucid_bell/presenter/android/IO/android_local_path_provider.dart' show LocalManager, StorageLogger;
import 'package:flutter_lucid_bell/view/android/theme/theme_setting.dart' show CustomTheme, Themes;

mixin ThemeIO{
  Future<bool> saveToStorageAsync(Themes themeName) async {
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
        Themes convertedEnum = Themes.values.byName(customTheme);
        
        
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