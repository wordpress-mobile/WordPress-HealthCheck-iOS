#
# Be sure to run `pod lib lint HealthCheck.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "HealthCheck"
  s.version          = "0.1.0"
  s.summary          = "Health check for common iOS problems."
  s.description      = <<-DESC
                        Health check for common iOS problems. Like failures to connect to the XML-RPC
                       DESC

  s.homepage         = "https://github.com/wordpress-mobile/WordPress-HealthCheck-iOS"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'GPLv2'
  s.author           = { "Automattic" => "mobile@automattic.com", "Diego Rey Mendez" => "diego.rey.mendez@automattic.com", "Sérgio Estêvão" => "sergio.estevao@automattic.com" }
  s.source           = { :git => "https://github.com/wordpress-mobile/WordPress-HealthCheck-iOS.git", :tag => s.version.to_s }
  s.social_media_url = 'http://twitter.com/WordPressiOS'
  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'HealthCheck' => ['Pod/Assets/*.png']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
