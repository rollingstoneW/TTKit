Pod::Spec.new do |s|
  s.name             = 'TTKit'
  s.version          = '0.0.1'
  s.summary          = '你可能会用到的基础库'

  s.description      = <<-DESC
开发中常用的基础功能库。基于YYCategory，不断扩充中...
                       DESC

  s.homepage         = 'https://github.com/rollingstoneW/TTKit'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'rollingstoneW' => '190268198@qq.com' }
  s.source           = { :git => 'https://github.com/rollingstoneW/TTKit.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.source_files = 'TTKit/Classes/**/*'
  
  s.resource_bundles = {
    'TTKit' => ['TTKit/Assets/**/*.*']
  }

  s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit', 'Foundation'
  s.dependency 'Masonry'
  s.dependency 'MJRefresh'
  s.dependency 'SDWebImage'
  s.dependency 'YYCategories'
  s.dependency 'MBProgressHUD'

end
