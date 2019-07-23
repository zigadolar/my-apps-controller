Pod::Spec.new do |s|
  s.name             = 'MyOtherApps'
  s.version          = '0.0.1'
  s.summary          = 'An iOS utility for promoting/showing the developer\'s other apps.'

  s.description      = <<-DESC
    A helper utility for fetching other apps from the iTunes API.
    Also provides a simple table view controller for displaying other
    apps and their icons.
                       DESC

  s.homepage         = 'https://github.com/zigadolar/my-apps-controller.git'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Dolar, Ziga' => 'dolar.ziga@gmail.com' }
  s.source           = { :git => 'https://github.com/zigadolar/my-apps-controller.git', :tag => s.version.to_s }

  s.platform = :ios, '9.0'
  s.ios.deployment_target = '9.0'
  s.swift_version = '5.0'

  s.source_files = 'MyOtherApps/Classes/**/*'
  
  s.resource_bundles = {
      'MyOtherApps' => ['MyOtherApps/Assets/*.storyboard']
  }

  s.frameworks = 'UIKit', 'StoreKit'
end
