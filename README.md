# TTRabbit

[![CI Status](https://img.shields.io/travis/acct<blob>=0xE99FA6E68CAFE5AE81/TTKit.svg?style=flat)](https://travis-ci.org/acct<blob>=0xE99FA6E68CAFE5AE81/TTKit)
[![Version](https://img.shields.io/cocoapods/v/TTKit.svg?style=flat)](https://cocoapods.org/pods/TTKit)
[![License](https://img.shields.io/cocoapods/l/TTKit.svg?style=flat)](https://cocoapods.org/pods/TTKit)
[![Platform](https://img.shields.io/cocoapods/p/TTKit.svg?style=flat)](https://cocoapods.org/pods/TTKit)

## Usage

Categories: 基于YYCategories的扩展集合

BaseViewControllers: 封装的视图控制器基类集合

Toast: UIView和UIViewController基于MBProgressHUB的展示toast的方法，展示空页面的方法

SafeKit: 集合类取值容错处理

UIKit: 自己封装的视图小组件

Utilities: 简单的工具类

UtilitiesWithLocation: 简单的工具类（包含定位权限，CoreLocation）

YYKitDependency: 对YYKit的依赖

YYCategoryDependency: 对YYCategories的依赖

All: [Categories, BaseViewControllers, Toast, SafeKit, UIKit, UtilitiesWithLocation]

Pod导入方式：
如果项目中引入了YYKit
```ruby
pod 'TTRabbit', :subspecs => ['All', 'YYKitDependency']
```
否则
```ruby
pod 'TTRabbit', :subspecs => ['All', 'YYCategoryDependency']
```

## Example

TTDemo:https://github.com/rollingstoneW/TTDemo<br/>
To run the example project, clone TTDemo, and run `pod install`.

## License

TTRabbit is available under the MIT license. See the LICENSE file for more info.
