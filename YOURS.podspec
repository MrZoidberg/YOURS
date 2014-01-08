Pod::Spec.new do |s|
  s.name         = "YOURS"
  s.version      = "0.1"
  s.summary      = "Objective-C class for accessing Yet another OpenStreetMap Route Service"
  s.description  = <<-DESC
                  Objective-C class for accessing [Yet another OpenStreetMap Route Service](http://wiki.openstreetmap.org/wiki/YOURS#API_documentation) that provides routing API based on OSM.
                   DESC

  s.homepage     = "https://github.com/MrZoidberg/YOURS"
  s.license      = 'MIT'
  s.author             = { "Mikhail Merkulov" => "Mihail.Merkulov@gmail.com" }
  s.social_media_url = "https://twitter.com/mikhailmerkulov"
  s.ios.deployment_target = '6.0'
  s.osx.deployment_target = '10.8'
  s.source       = { :git => "https://github.com/MrZoidberg/YOURS.git", :tag => s.version.to_s }
  s.source_files  = 'YOURS', 'YOURS/YOURS/*.{h,m}'
  s.exclude_files = 'YOURS/YOURS/YOURS-Prefix.pch'
  s.framework  = 'CoreLocation'
  s.requires_arc = true
  s.dependency 'AFNetworking', '~> 2.0.0'
end
