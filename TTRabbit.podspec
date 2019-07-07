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

  s.subspec 'Core' do |ss|
    ss.source_files = 'TTRabbit/Classes/**/*'
    ss.public_header_files = 'TTRabbit/Classes/**/*.h'
    ss.resource_bundles = {
      'TTRabbit' => ['TTRabbit/Assets/**/*.*']
    }
    ss.frameworks = 'UIKit', 'Foundation'
    ss.dependency 'Masonry'
    ss.dependency 'MJRefresh'
    ss.dependency 'SDWebImage'
    ss.dependency 'MBProgressHUD'
  end

#如果项目中引用了YYKit，请使用此子模块, pod 'TTRabbit', :subspecs => [YYKitDependency]
  s.subspec 'YYKitDependency' do |ss|
    ss.dependency 'YYKit'
    ss.dependency 'TTRabbit/Core'
  end

  s.default_subspecs = 'Core'


end
