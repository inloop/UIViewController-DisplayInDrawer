#
# Be sure to run `pod lib lint UIViewController-DisplayInDrawer.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'UIViewController-DisplayInDrawer'
  s.version          = '1.2.0'
  s.summary          = 'Present any view controller easily in a drawer (iOS Maps style)'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
    Present any view controller easily in a drawer (iOS Maps style). It is implemented as a UIViewController extension, which means no subclassing and no invasive view hierarchy setup. It is designed to be as easy to use as possible:

  You can present any controller. Make it conform to the DrawerConfiguration protocol
  Optionally setup a DrawerPositionDelegate which is notified about drawer's position
  Call `displayInDrawer(controller, drawerPositionDelegate: delegate)`.
  DESC

  s.homepage         = 'https://github.com/inloop/UIViewController-DisplayInDrawer'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'vilemkurz' => 'vilem.kurz@inloopx.com' }
  s.source           = { :git => 'https://github.com/inloop/UIViewController-DisplayInDrawer.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'
  s.swift_version = '4.1'
  s.source_files = 'UIViewController-DisplayInDrawer/Classes/**/*'
  
  # s.resource_bundles = {
  #   'UIViewController-DisplayInDrawer' => ['UIViewController-DisplayInDrawer/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
