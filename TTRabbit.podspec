Pod::Spec.new do |s|
  s.name             = 'TTRabbit'
  s.version          = '0.0.2'
  s.summary          = '你可能会用到的基础库'

  s.description      = <<-DESC
开发中常用的基础功能库。基于YYCategory，不断扩充中...
                       DESC

  s.homepage         = 'https://github.com/rollingstoneW/TTKit'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'rollingstoneW' => '190268198@qq.com' }
  s.source           = { :git => 'https://github.com/rollingstoneW/TTKit.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'


  #如果项目中引用了YYKit，请使用此子模块, pod 'TTRabbit', :subspecs => [YYKitDependency]
  s.subspec 'YYKitDependency' do |ss|
    ss.dependency 'YYKit'
  end
  s.subspec 'YYCategoryDependency' do |ss|
    ss.dependency 'YYCategories'
  end

  s.subspec 'Categories' do |ss|
    ss.source_files = 'TTRabbit/Categories/**/*'
    ss.public_header_files = 'TTRabbit/Categories/**/*.h'
    ss.frameworks = 'UIKit', 'Foundation', 'CoreText'
  end

  s.subspec 'BaseViewControllers' do |ss|
    ss.source_files = 'TTRabbit/BaseViewControllers/**/*'
    ss.public_header_files = 'TTRabbit/BaseViewControllers/**/*.h'
    ss.frameworks = 'UIKit', 'Foundation'
    ss.dependency 'TTRabbit/Categories'
    ss.dependency 'MJRefresh'
  end

  s.subspec 'Toast' do |ss|
    ss.source_files = 'TTRabbit/Toast/*'
    ss.public_header_files = 'TTRabbit/Toast/*.h'
    ss.frameworks = 'UIKit', 'Foundation'
    ss.dependency 'MBProgressHUD'
    ss.resource_bundles = {
      'TTToastBundle' => ['TTRabbit/Toast/Assets/*.*']
    }
  end

  s.subspec 'SafeKit' do |ss|
    ss.source_files = 'TTRabbit/SafeKit/**/*'
    ss.public_header_files = 'TTRabbit/SafeKit/**/*.h'
    ss.frameworks = 'UIKit', 'Foundation', 'AVFoundation'
  end

  s.subspec 'UIKit' do |ss|
    ss.source_files = 'TTRabbit/UIKit/**/*'
    ss.public_header_files = 'TTRabbit/UIKit/**/*.h'
    ss.frameworks = 'UIKit', 'Foundation'
    ss.dependency 'TTRabbit/Categories'
    ss.dependency 'Masonry'
  end

  s.subspec 'Utilities' do |ss|
    ss.source_files = 'TTRabbit/Utilities/**/*'
    ss.public_header_files = 'TTRabbit/Utilities/**/*.h'
    ss.frameworks = 'UIKit', 'Foundation', 'WebKit', 'AVFoundation', 'AssetsLibrary', 'JavaScriptCore'
    ss.dependency 'TTRabbit/Categories'
  end

  s.subspec 'UtilitiesWithLocation' do |ss|
    ss.source_files = 'TTRabbit/Utilities/**/*'
    ss.public_header_files = 'TTRabbit/Utilities/**/*.h'
    ss.frameworks = 'UIKit', 'Foundation', 'WebKit', 'AVFoundation', 'AssetsLibrary', 'JavaScriptCore', 'CoreLocation'
    ss.dependency 'TTRabbit/Categories'
  end

  s.subspec 'All' do |ss|
    ss.dependency 'TTRabbit/Categories'
    ss.dependency 'TTRabbit/BaseViewControllers'
    ss.dependency 'TTRabbit/Toast'
    ss.dependency 'TTRabbit/UIKit'
    ss.dependency 'TTRabbit/UtilitiesWithLocation'
    ss.dependency 'TTRabbit/SafeKit'
    ss.public_header_files = 'TTRabbit/TTRabbit.h'
    ss.source_files = 'TTRabbit/TTRabbit.h'
  end

  # s.subspec 'NewFeatureGuide' do |ss|
  #   ss.source_files = 'TTRabbit/NewFeatureGuide/**/*'
  #   ss.public_header_files = 'TTRabbit/NewFeatureGuide/**/*.h'
  #   ss.frameworks = 'UIKit', 'Foundation', 'WebKit', 'AVFoundation', 'AssetsLibrary', 'JavaScriptCore', 'CoreLocation'
  #   ss.dependency 'TTRabbit/Categories'
  # end



  # s.subspec 'CategoriesDependingYYKit' do |ss|
  #   ss.source_files = 'TTRabbit/Categories/**/*'
  #   ss.public_header_files = 'TTRabbit/Categories/**/*.h'
  #   ss.frameworks = 'UIKit', 'Foundation', 'CoreText'
  #   ss.dependency 'YYKit'
  # end

  s.default_subspecs = 'All', 'YYCategoryDependency'


end
