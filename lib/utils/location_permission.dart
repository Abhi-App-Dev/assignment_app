import 'package:permission_handler/permission_handler.dart';

class FetchLocation {
  Future<bool> getLocationPermission() async {
    var locationStatus =
        await Permission.locationAlways.request();
    if (locationStatus.isGranted) {
      print("Location permission inside controller allow");
      return true;
    } else {
      return false;
    }
  }
}
