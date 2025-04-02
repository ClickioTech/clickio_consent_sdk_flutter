#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint clickio_consent_sdk.podspec` to validate before publishing.
#
Pod::Spec.new do |spec|
  spec.name             = 'clickio_consent_sdk'
  spec.version          = '1.1.3'
  spec.summary          = 'A Flutter plugin for Clickio Consent SDK.'
  spec.description      = <<-DESC
A Flutter plugin that integrates the Clickio Consent SDK for iOS.
It helps manage user consent for tracking and data collection.
  DESC
  spec.homepage         = 'https://clickio.com/'
  spec.license          = { :type => 'MIT', :file => '../LICENSE' }
  spec.author           = { 'Clickio' => 'app-dev@clickio.com' }
  spec.source           = { :git => "https://github.com/ClickioTech/ClickioConsentSDK-IOS.git", :tag => "#{spec.version}" }

  spec.source_files = 'Classes/**/*'
  spec.dependency 'Flutter'
  spec.platform = :ios, '15.0'

  # Flutter.framework does not contain an i386 slice.
  spec.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  spec.swift_version = '5.0'

  # If your plugin requires a privacy manifest, for example if it uses any
  # required reason APIs, update the PrivacyInfo.xcprivacy file to describe your
  # plugin's privacy impact, and then uncomment this line. For more information,
  # see https://developer.apple.com/documentation/bundleresources/privacy_manifest_files
  # s.resource_bundles = {'clickio_consent_sdk_privacy' => ['Resources/PrivacyInfo.xcprivacy']}
end
