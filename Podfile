# Uncomment the next line to define a global platform for your project
platform :ios, '15.0'

target 'PLUV' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for PLUV

  target 'PLUVTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'PLUVUITests' do
    # Pods for testing
  end

  pod 'Alamofire'
  pod 'SnapKit'
  pod 'Tabman', '~> 3.0'

  post_install do |installer|
    installer.pods_project.build_configurations.each do |config|
      config.build_settings['EXCLUDED_ARCHS[sdk=iphonesimulator*]'] = 'arm64'
    end
  end

  pod 'Then'
  pod 'Kingfisher'
  pod 'SwiftyJSON'
  pod 'RxSwift'
  pod 'RxCocoa'
  pod 'Firebase/Analytics'
  pod 'Firebase/Crashlytics'
end