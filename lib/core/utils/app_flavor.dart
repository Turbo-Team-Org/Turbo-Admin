class AppFlavorConstants {
  static const prod = 'PROD';
  static const pre = 'PRE';
  static const env = 'ENV';
}

class AppFlavor {
  static bool get isPre {
    return const String.fromEnvironment(AppFlavorConstants.env,
            defaultValue: AppFlavorConstants.pre) ==
        AppFlavorConstants.pre;
  }
}
