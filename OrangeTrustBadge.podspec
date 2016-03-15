Pod::Spec.new do |s|
  s.name         = "OrangeTrustBadge"
  s.version      = "1.0.17"
  s.summary      = "Orange Trust Badge"
  s.description  = <<-DESC
With Orange trust badge, aka Badge de confiance, give transparent information and user control on personal data and help users to identify if your application has any sensitive features.
DESC
  s.homepage     = "https://developer.orange.com/apis/orange-trust-badge/"
  s.license      = "Apache License, Version 2.0"
  s.author       = { "Orange" => "romain.biard@orange.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/Orange-OpenSource/orange-trust-badge-ios" ,:tag => s.version.to_s }
  s.source_files = "OrangeTrustBadge/Classes/**/*.swift"
  s.resources 	 = ["OrangeTrustBadge/**/*.{lproj,storyboard,xib,css}","OrangeTrustBadge/**/*.xcassets"]
  s.dependency "dailymotion-player-objc"
end
