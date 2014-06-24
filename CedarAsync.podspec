Pod::Spec.new do |s|
  s.name = "CedarAsync"
  s.version = "0.0.1"
  s.summary = "asynchronous testing for Cedar (and others)."
  s.description = "CedarAsync lets you use [Cedar](http://github.com/pivotal/cedar) matchers to \ntest asynchronous code. This becomes useful when writing intergration tests \nrather than plain unit tests. (CedarAsync only supports Cedar's should syntax.)",
  s.homepage = "https://github.com/cppforlife/CedarAsync"
  s.license = { :type => "MIT", :text => "LICENSE" }
  s.author = { "Dmitriy Kalinin" => "email@address.com" }
  s.source = { :git => "https://github.com/shake-apps/CedarAsync.git", :branch => "HEAD" }
  s.osx.deployment_target = '10.7'
  s.ios.deployment_target = '5.0'

  s.source_files = "Source/**/*.{h,m}"
  
  s.dependency 'Cedar'
  s.xcconfig = {
    "CLANG_CXX_LANGUAGE_STANDARD" => "c++0x",
    "CLANG_CXX_LIBRARY" => "libc++"
  }
  s.requires_arc = false
end
