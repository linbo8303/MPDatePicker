Pod::Spec.new do |s|

  s.name         = "MPDatePicker"
  s.version      = "1.0"
  s.summary      = "A window level datePicker for iOS"
  s.homepage     = "https://github.com/linbo8303/MPDatePicker"
  s.screenshots  = "https://github.com/linbo8303/MPDatePicker/raw/master/Screenshot1.png"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "Bo Lin" => "linbo8303@gmail.com" }
  s.platform     = :ios
  s.ios.deployment_target = "10.0"
  s.source       = { :git => "https://github.com/linbo8303/MPDatePicker.git", :tag => s.version }
  s.source_files  = "Classes/*.swift"
  s.requires_arc = true
end
