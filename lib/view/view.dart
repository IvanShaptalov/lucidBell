import 'package:flutter_lucid_bell/view/android/theme/theme_setting.dart';
import 'package:flutter_lucid_bell/view/config_view.dart';
import 'package:intl/intl.dart';

/// USE VIEW TO CREATE LAST IN ANDROID PLATFORM IN THIS CASE
class View {
  static ThemesEnum themesEnum = ThemesEnum.purpleDefault;
  static CustomTheme currentTheme = CustomTheme.selectTheme();

  static Future<void> initAsync() async{
    // TODO load theme from storage
    currentTheme = CustomTheme.selectTheme(theme: themesEnum);
  }

  static String formatLeftSeconds(int seconds) {
    DateTime date =
        DateTime.fromMicrosecondsSinceEpoch(seconds * 1000000, isUtc: true);
    String format = 'ss';

    if (seconds >= 60) {
      format = 'mm:ss';
    }
    if (seconds >= 3600) {
      format = 'hh:mm:ss';
    }

    String dateStringFormat = DateFormat(format).format(date);
    return dateStringFormat;
  }

  static String formatTime(DateTime date) {
    String dateStringFormat = DateFormat(ViewConfig.timeFormat).format(date);
    return dateStringFormat;
  }

  static String humanLikeDuration(Duration duration, {bool shortLabel= false}) {
    int totalHours = duration.inHours;
    int minutesLeft = duration.inMinutes - (totalHours * 60);
    String? strHours;
    String? strMinutes;

    String hour = shortLabel? "h": "hour";
    String hours = shortLabel? "h": "hours";
    String minute = shortLabel? "min": "minute";
    String minutes = shortLabel? "min": "minutes";
    switch (totalHours) {
      case 0:
        strHours = null;
        break;
      case 1:
        strHours = "$totalHours $hour";
        break;
      default:
        strHours = "$totalHours $hours";
        break;
    }

    switch (minutesLeft) {
      case 0:
        strMinutes = null;
        break;
      case 1:
        strMinutes = "$minutesLeft $minute";
        break;
      default:
        strMinutes = "$minutesLeft $minutes";
        break;
    }
    if (strMinutes == null && strHours != null) {
      return strHours;
    } else if (strHours == null && strMinutes != null) {
      return strMinutes;
    } else if (strHours == null && strMinutes == null) {
      return "";
    }

    return "$strHours $strMinutes";
  }

}
