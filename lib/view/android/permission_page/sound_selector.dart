import 'package:flutter/material.dart';
import 'package:flutter_lucid_bell/constant.dart';
import 'package:flutter_lucid_bell/presenter/presenter.dart';
import 'package:flutter_lucid_bell/view/view.dart';

class SoundSelector extends StatelessWidget {
  final Function updateCallback;
  const SoundSelector(this.updateCallback, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: generateSoundOptions(),
    );
  }

  List<Widget> generateSoundOptions() {
    List<Widget> soundOption = [];
    for (var playSound in [
      defaultReminder,
      uwuReminder,
      dripReminder,
      kpkReminder
    ]) {
      soundOption.add(Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            BellPresenter.bell!.reminderSoundEnum == playSound.enumName
                ? Center(
                    child: IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.check,
                      color: View
                          .currentTheme.appTheme.activeBottomNavigationBarColor,
                    ),
                  ))
                : Center(
                    child: IconButton(
                        onPressed: () async {
                          await BellPresenter.bell!
                              .setReminderSoundEnum(playSound.enumName);
                          updateCallback();
                        },
                        icon: Icon(
                          Icons.add,
                          color: View.currentTheme.appTheme
                              .activeBottomNavigationBarColor,
                        )),
                  ),
            Text(
                "Set ${playSound.enumName.name} to notification reminder sound")
          ],
        ),
      ));
    }
    return soundOption;
  }
}
