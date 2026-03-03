#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint paymob_sdk.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'paymob_sdk'
  s.version          = '0.0.1'
  s.summary          = 'A Flutter plugin for integrating Paymob payment gateway.'
  s.description      = <<-DESC
A Flutter plugin that provides seamless integration with the Paymob payment gateway,
enabling secure and easy payment processing for iOS and Android applications.
                       DESC
  s.homepage         = 'https://github.com/ahmedsaleh210/paymob_sdk'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Ahmed Saleh' => 'ahmedsaleh212020@gmail.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '13.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
  s.vendored_frameworks = 'PaymobSDK.xcframework'
  # If your plugin requires a privacy manifest, for example if it uses any
  # required reason APIs, update the PrivacyInfo.xcprivacy file to describe your
  # plugin's privacy impact, and then uncomment this line. For more information,
  # see https://developer.apple.com/documentation/bundleresources/privacy_manifest_files
  # s.resource_bundles = {'paymob_sdk_privacy' => ['Resources/PrivacyInfo.xcprivacy']}
end
