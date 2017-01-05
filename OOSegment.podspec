Pod::Spec.new do |s|

  s.name         = "OOSegment"
  s.version      = "4.3.3"
  s.summary      = "oosegment pageviewcontroller navigatioin"

  s.description  = <<-DESC
		navigation segment bar pageViewController cursor
                   DESC

  s.homepage     = "https://github.com/lijianwei-jj/OOSegmentViewController"
  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author             = { "lijianwei" => "lijianwei.jj@gmail.com" }

  s.platform     = :ios, "8.0"

  s.source       = { :git => "https://github.com/lijianwei-jj/OOSegmentViewController.git", :tag => s.version }

  s.source_files  = "OOSegmentViewController/OO*.swift"
  
  s.pod_target_xcconfig = { 'SWIFT_VERSION' => 2.3 }

  s.pod_target_xcconfig = { 'SWIFT_VERSION' => '3.0' }
end
