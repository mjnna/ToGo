# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Mjnna_Delivery' do
  use_frameworks!
pod 'Alamofire', '~> 5.2'
pod 'Moya/RxSwift', '~> 14.0.0'
pod 'RxSwift', '~> 5'
pod 'RxCocoa', '~> 5'
pod "RxGesture", '~> 3.0'
pod 'SQLite.swift', '~> 0.12.2'
pod 'Kingfisher', '~> 5.15.8'

pod 'GoogleMaps', '= 3.9.0'
pod 'GooglePlaces', '= 3.9.0'

pod 'Firebase/Core', '5.20.1'
pod 'Firebase/Messaging'
pod 'FirebaseInstanceID'

pod 'MaterialComponents/ActivityIndicator'

pod 'IQKeyboardManagerSwift'

pod 'FSPagerView'
#pod 'WhatsNewKit'
pod 'SwiftMessages'

pod 'StepIndicator', '~> 1.0.8'

pod 'TransitionButton'
pod 'MaterialComponents/TextFields'
pod 'SDWebImage'

pod 'lottie-ios'
pod 'RealmSwift'
#amr
pod 'Firebase/Analytics'
pod 'Cosmos', '~> 23.0'
pod 'SwiftyGif'

pod 'FloatingPanel'
pod 'GoogleSignIn'
pod 'FBSDKLoginKit'

pod 'ReachabilitySwift'

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      # some older pods don't support some architectures, anything over iOS 11 resolves that
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
    end
  end
end
