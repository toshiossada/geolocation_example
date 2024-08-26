import 'package:flutter_background_geolocation/flutter_background_geolocation.dart';

class AppController {
  Future<State> init({
    required Function(Location) onLocation,
    // required Function(Location) onMotionChange,
    // required Function(ActivityChangeEvent) onActivityChange,
    // required Function(ProviderChangeEvent) onProviderChange,
    // required Function(ConnectivityChangeEvent) onConnectivityChange,
  }) async {
    // 1.  Listen to events (See docs for all 12 available events).
    BackgroundGeolocation.onLocation(onLocation);
    // BackgroundGeolocation.onMotionChange(onMotionChange);
    // BackgroundGeolocation.onActivityChange(onActivityChange);
    // BackgroundGeolocation.onProviderChange(onProviderChange);
    // BackgroundGeolocation.onConnectivityChange(onConnectivityChange);

    // 2.  Configure the plugin
    final result = await BackgroundGeolocation.ready(
      Config(
          desiredAccuracy: Config.DESIRED_ACCURACY_HIGH,
          distanceFilter: 10.0,
          stopOnTerminate: false,
          startOnBoot: true,
          debug: true,
          logLevel: Config.LOG_LEVEL_VERBOSE),
    );

    return result;
  }

  Future<void> enableBackground(enabled) async {
    if (enabled) {
      BackgroundGeolocation.start().then((State state) {
        print('[start] success $state');
        BackgroundGeolocation.changePace(enabled);
      });
    } else {
      BackgroundGeolocation.stop().then((State state) {
        print('[stop] success: $state');
        // Reset odometer.
        BackgroundGeolocation.setOdometer(0.0);
      });
    }
  }
}
