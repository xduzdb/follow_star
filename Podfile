# Uncomment the next line to define a global platform for your project

target 'HomeWidgetExtension' do
  use_frameworks!
  pod 'SwiftyJSON'
  pod 'KakaJSON'
  pod 'SDWebImageSwiftUI'
#  pod 'Moya', '~> 15.0.0'
  pod 'ObjectMapper', '~> 4.2.0'
end

target 'StartTimeLine' do
  
  use_frameworks!
  pod 'JPush'
  pod 'JCore'
  pod 'SnapKit', '~> 5.7.0'
  pod 'SwiftyJSON', '~> 5.0.0'
  pod 'Moya', '~> 15.0.0'
  pod 'ObjectMapper', '~> 4.2.0'
  pod 'RxSwift', '6.7.1'
  pod 'RxCocoa', '6.7.1'
  pod 'SVProgressHUD'
  pod 'FWPopupView'
  pod 'KakaJSON'
  pod 'JPImageresizerView'
  pod 'SDWebImageSwiftUI'
  pod 'LunarSwift'
  pod 'ExytePopupView'
  # 折线图
  pod 'AAInfographics', :git => 'https://github.com/AAChartModel/AAChartKit-Swift.git'
  
  pod 'TZImagePickerController' # Full version with all features
  pod 'TZImagePickerController/Basic' # No location code
  pod 'IQKeyboardManagerSwift'
  
  pod 'mob_sharesdk'
  pod 'mob_sharesdk/ShareSDKUI'
  pod 'mob_sharesdk/ShareSDKPlatforms/WeChat'
  pod 'mob_sharesdk/ShareSDKPlatforms/SinaWeibo'
  pod 'mob_sharesdk/ShareSDKExtension'

  pod 'LookinServer', :configurations => ['Debug']
  
end

#修改Pod targets 版本
post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            if config.name == 'Debug'
              config.build_settings["VALID_ARCHS"] = "arm64 arm64e x86_64 i386"
            else
              config.build_settings["VALID_ARCHS"] = "arm64 arm64e"
            end
            config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '15.0'
            config.build_settings['EXPANDED_CODE_SIGN_IDENTITY'] = ""
            config.build_settings['CODE_SIGNING_REQUIRED'] = "NO"
            config.build_settings['CODE_SIGNING_ALLOWED'] = "NO"
            config.build_settings['ONLY_ACTIVE_ARCH'] = 'NO'
        end
    end
end
