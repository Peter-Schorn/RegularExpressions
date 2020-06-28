Pod::Spec.new do |spec|

  spec.name         = "RegularExpressions"
  spec.version      = "2.0.4"
  spec.summary      = "A regular expressions library for Swift"
  spec.homepage     = "https://github.com/Peter-Schorn/RegularExpressions"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author             = { "Peter Schorn" => "petervschorn@gmail.com" }

  spec.ios.deployment_target = "8.0"
  spec.osx.deployment_target = "10.10"
  spec.watchos.deployment_target = "2.0"
  spec.tvos.deployment_target = "9.0"

  spec.source       = { :git => "https://github.com/Peter-Schorn/RegularExpressions.git", :tag => "2.0.4" }
  spec.source_files  = "Sources/**/*.swift"

  spec.swift_versions = '5.2'

end
