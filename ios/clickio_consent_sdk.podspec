Pod::Spec.new do |s|
  s.name                  = 'clickio_consent_sdk'
  s.version               = '1.0.1'
  s.summary               = 'Clickio Consent SDK for Flutter'
  s.description           = <<-DESC
                            A Flutter plugin that integrates the Clickio Consent SDK for iOS.
                            It helps manage user consent for tracking and data collection.
                            DESC
  s.homepage              = 'https://clickio.com/'
  s.license               = { :type => 'MIT', :file => '../LICENSE' }
  s.author                = { 'Clickio' => 'app-dev@clickio.com' }
  s.source                = { :git => "https://github.com/ClickioTech/clickio_consent_sdk_flutter.git", :tag => "#{s.version}" }

  s.ios.deployment_target = '15.0'    
  s.swift_version = '5.0'     

  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.dependency 'ClickioConsentSDKManager', '1.0.9'
end
