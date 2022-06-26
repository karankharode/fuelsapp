import UIKit
import Flutter
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
GMSServices.provideAPIKey("AIzaSyDLVF-akyb-LkuVsfs6P8a89U4QbIKpR7k")
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
