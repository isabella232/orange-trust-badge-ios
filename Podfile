source 'https://github.com/CocoaPods/Specs.git'

inhibit_all_warnings!
use_frameworks!

workspace 'OrangeTrustBadge'
xcodeproj 'OrangeTrustBadge.xcodeproj'
xcodeproj 'OrangeTrustBadgeDemo.xcodeproj'

target :OrangeTrustBadge do
    platform :ios, '8.0'
    xcodeproj 'OrangeTrustBadge.xcodeproj'
end

target :OrangeTrustBadgeDemo do
    platform :ios, '8.0'
    pod 'OrangeTrustBadge', :path => "./"
    xcodeproj 'OrangeTrustBadgeDemo.xcodeproj'
end