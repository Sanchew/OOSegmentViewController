Pod::Spec.new do |s|

  s.name         = "OOSegment"
  s.version      = "4.4.0"
  s.summary      = "oosegment pageviewcontroller navigatioin"

  s.description  = <<-DESC
		navigation segment bar pageViewController cursor
                   DESC

  s.homepage     = "https://github.com/sanchew/OOSegmentViewController"
  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author             = { "lijianwei" => "lijianwei.jj@gmail.com" }

  s.platform     = :ios, "10.0"

  s.source       = { :git => "https://github.com/sanchew/OOSegmentViewController.git", :tag => s.version }

  s.source_files  = "OOSegmentViewController/OO*.swift"
  

  s.swift_version = "4.2"
end
