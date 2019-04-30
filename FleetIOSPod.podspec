#
# Be sure to run `pod lib lint FleetIOSPod.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
    s.name             = 'FleetIOSPod'
    s.version          = '0.1.0'
    s.summary          = 'Fast Development open source UI Framework for iOS Development.'
    s.description      = <<-DESC
    Channeling MacApp from the early days of Macintosh, Fleet is an open source UI Framework designed to help developers quickly created their iOS App.
    DESC
    
    s.name             = 'FleetIOSPod'
    s.homepage         = 'https://github.com/magesteve/FleetIOSPod'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'Steve Sheets' => 'magesteve@mac.com' }
    s.source           = { :git => 'https://github.com/magesteve/FleetIOSPod.git', :tag =>     s.version.to_s }
    s.social_media_url = 'https://twitter.com/magesteve'
    
    s.ios.deployment_target = ’11.0’
    s.source_files = 'FleetIOSPod/Classes/*.swift'
    s.frameworks = 'UIKit'
    s.swift_version = '5.0'
end
