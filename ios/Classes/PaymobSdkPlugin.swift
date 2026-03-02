import Flutter
import UIKit
import PaymobSDK

public class PaymobSdkPlugin: NSObject, FlutterPlugin {
  var SDKResult: FlutterResult?

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "paymob_sdk_flutter", binaryMessenger: registrar.messenger())
    let instance = PaymobSdkPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
      if call.method == "payWithPaymob",
      let args = call.arguments as? [String: Any]{
            self.SDKResult = result
            if let rootViewController = UIApplication.shared.delegate?.window??.rootViewController {
                self.callNativeSDK(arguments: args, VC: rootViewController)
            } else {
                result(FlutterError(code: "NO_VIEW_CONTROLLER", message: "Could not find root view controller", details: nil))
            }
          } else {
            result(FlutterMethodNotImplemented)
        }
  }

   private func callNativeSDK(arguments: [String: Any], VC: UIViewController) {
          // Initialize Paymob SDK
          let paymob = PaymobSDK()
          paymob.delegate = self

          //customize the SDK
          if let appName = arguments["appName"] as? String{
              paymob.paymobSDKCustomization.appName = appName
          }
          if let buttonBackgroundColor = arguments["buttonBackgroundColor"] as? NSNumber{

              let colorInt = buttonBackgroundColor.intValue
              let alpha = CGFloat((colorInt >> 24) & 0xFF) / 255.0
              let red = CGFloat((colorInt >> 16) & 0xFF) / 255.0
              let green = CGFloat((colorInt >> 8) & 0xFF) / 255.0
              let blue = CGFloat(colorInt & 0xFF) / 255.0

              let color = UIColor(red: red, green: green, blue: blue, alpha: alpha)

              paymob.paymobSDKCustomization.buttonBackgroundColor = color
          }
          if let buttonTextColor = arguments["buttonTextColor"] as? NSNumber{

              let colorInt = buttonTextColor.intValue
              let alpha = CGFloat((colorInt >> 24) & 0xFF) / 255.0
              let red = CGFloat((colorInt >> 16) & 0xFF) / 255.0
              let green = CGFloat((colorInt >> 8) & 0xFF) / 255.0
              let blue = CGFloat(colorInt & 0xFF) / 255.0

              let color = UIColor(red: red, green: green, blue: blue, alpha: alpha)

              paymob.paymobSDKCustomization.buttonTextColor = color
          }
          if let saveCardDefault = arguments["saveCardDefault"] as? Bool{
              paymob.paymobSDKCustomization.saveCardDefault = saveCardDefault
          }
          if let showSaveCard = arguments["showSaveCard"] as? Bool{
              paymob.paymobSDKCustomization.showSaveCard = showSaveCard
          }
          // Call Paymob SDK with publicKey and clientSecret
          if let publicKey = arguments["publicKey"] as? String,
             let clientSecret = arguments["clientSecret"] as? String{
              do{
                  try paymob.presentPayVC(VC: VC, PublicKey: publicKey, ClientSecret: clientSecret)
              } catch let error {
                  print(error.localizedDescription)
              }
              return
          }
      }
}

extension PaymobSdkPlugin: PaymobSDKDelegate {
    public func transactionAccepted(transactionDetails: [String: Any]) {
        self.SDKResult?("Successfull")
        self.SDKResult = nil

    }

    public func transactionRejected(message : String) {
        self.SDKResult?("Rejected")
        self.SDKResult = nil
    }


    public func transactionPending() {
        self.SDKResult?("Pending")
        self.SDKResult = nil
    }
}
