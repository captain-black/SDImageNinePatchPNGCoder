#
# Be sure to run `pod lib lint SDImage9PatchPNGCoder.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SDImage9PatchPNGCoder'
  s.version          = '0.1.0'
  s.summary          = 'Parse Nine Patch chunk in the PNG file.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  SDImage9PatchPNGCoder inherits from SDImageAPNGCoder, it can parse the Nine Patch chunk in the PNG file and set the padding data to the sd_extendedObject of the UIImage object.
                       DESC

  s.homepage         = 'https://github.com/captain-black/SDImageNinePatchPNGCoder'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Captain Black' => 'captainblack.soul@gmail.com' }
  s.source           = { :git => 'https://github.com/captain-black/SDImageNinePatchPNGCoder.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'

  s.source_files = 'SDImage9PatchPNGCoder/Classes/**/*'
  
  # s.resource_bundles = {
  #   'SDImage9PatchPNGCoder' => ['SDImage9PatchPNGCoder/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
  s.dependency 'SDWebImage'
end
