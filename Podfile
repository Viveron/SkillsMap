platform :ios, '10.0'

target 'SkillsMap' do
  inhibit_all_warnings!
  use_frameworks!

  pod 'KeychainAccess'
  pod 'ScrollableGraphView'
  pod 'RadioGroup'
  pod "KRProgressHUD"
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
    end

    swift_5 = [
    'ScrollableGraphView'
    ]

    if swift_5.include?(target.name)
      target.build_configurations.each do |config|
        config.build_settings['SWIFT_VERSION'] = '5.0'
      end
    end
  end
end
