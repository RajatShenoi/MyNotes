import 'package:in_app_update/in_app_update.dart';
import 'dart:developer' as devtools show log;

Future<void> checkAndPerformUpdates() async {
  try {
    InAppUpdate.checkForUpdate().then((updateInfo) => {
          if (updateInfo.updateAvailability ==
              UpdateAvailability.updateAvailable)
            {
              if (updateInfo.immediateUpdateAllowed)
                {
                  InAppUpdate.performImmediateUpdate().then((appUpdateResult) {
                    if (appUpdateResult == AppUpdateResult.success) {
                      devtools.log("Update Successfull");
                    } else {
                      devtools.log("Update failed");
                    }
                  })
                }
            }
          else if (updateInfo.flexibleUpdateAllowed)
            {
              InAppUpdate.startFlexibleUpdate().then((appUpdateResult) {
                if (appUpdateResult == AppUpdateResult.success) {
                  InAppUpdate.completeFlexibleUpdate();
                }
              })
            }
        });
  } catch (e) {
    devtools.log(e.toString());
  }
}
