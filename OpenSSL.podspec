# coding: utf-8
#
#  Be sure to run `pod spec lint FFmpeg.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
Pod::Spec.new do |spec|
  spec.name         = "OpenSSL"
  spec.version      = "1.0.0"
  spec.summary      = "OpenSSL library"
  spec.description  = <<-DESC 
FFmpeg library.
                      DESC
  spec.homepage     = "http://example.com"
  spec.license      = "MIT"
  spec.author       = { 'Your Company' => 'email@example.com' }
  spec.platform     = :ios, "9.0"
  spec.source       = { :git => "https://github.com/myvideoyun/TinyGiftRendererIOS.git", :tag => "1.0.07" }
  spec.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }

  spec.libraries = 'c++', 'z', 'iconv'
  # spec.frameworks = 'AudioToolBox'
  spec.private_header_files = "OpenSSL/include/**/*.h"
  spec.header_mappings_dir = "OpenSSL/include"
  spec.vendored_libraries = "OpenSSL/**/*.a"
end
