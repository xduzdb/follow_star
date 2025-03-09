# Uncomment the next line to define a global platform for your project

target 'StartTimeLine' do
  
  use_frameworks!
  pod 'SwiftyJSON'
  pod 'ObjectMapper', '~> 4.2.0'
  pod 'KakaJSON'
  pod 'SDWebImageSwiftUI'
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
  #pod 'JPImageresizerView'
  pod 'SDWebImageSwiftUI'
  pod 'LunarSwift'
  # 折线图
  pod 'AAInfographics', :git => 'https://github.com/AAChartModel/AAChartKit-Swift.git'
  
  # 友盟相关信息
  #新版本pod
  # U-Share SDK UI模块，分享面板
  pod 'UMShare/UI'
  #必须集成，由原来的UMCCommon变为了UMCommon
  pod 'UMCommon'
  #必须集成
  pod 'UMDevice'

  pod 'UMShare/Social/WeChat'
  pod 'UMShare/Social/QQ'
  pod 'UMShare/Social/Sina'
  
  pod 'LookinServer', :configurations => ['Debug']
  
end

#修改Pod targets 版本
post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '15.0'
            config.build_settings['EXPANDED_CODE_SIGN_IDENTITY'] = ""
            config.build_settings['CODE_SIGNING_REQUIRED'] = "NO"
            config.build_settings['CODE_SIGNING_ALLOWED'] = "NO"
        end
    end
end
